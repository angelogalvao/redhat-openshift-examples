#Create LDAP guide from:
#https://www.linkedin.com/pulse/deploying-openldap-openshift-users-bootstrapped-ritesh-raj/


#change env vars before executing the script!
source oc-setenv.sh

oc delete ns $NAMESPACE --wait &>/dev/null
oc wait --for=delete ns/"$NAMESPACE" --timeout=180s &>/dev/null

oc create ns $NAMESPACE
oc project $NAMESPACE

rm LAST.bootstrap.ldif
mv bootstrap.ldif LAST.bootstrap.ldif

rm LAST.Dockerfile
mv Dockerfile LAST.Dockerfile

echo "1. Create bootstraf LDIF file"
cat > bootstrap.ldif << EOF
version: 1

# Entry 1: cn=$LDAP_CONSOLE_ADMIN_USER,dc=your,dc=company,dc=com
dn: cn=$LDAP_CONSOLE_ADMIN_USER,dc=your,dc=company,dc=com
changetype: add
cn: $LDAP_CONSOLE_ADMIN_USER
displayname: User 1
givenname: User
mail: $LDAP_CONSOLE_ADMIN_USER@your.company.com
objectclass: inetOrgPerson
sn: 1
userpassword: $LDAP_CONSOLE_ADMIN_PASSWORD

# Entry 2: cn=user2,dc=your,dc=company,dc=com
dn: cn=user2,dc=your,dc=company,dc=com
changetype: add
cn: user2
displayname: User 2
givenname: User
mail: user2@your.company.com
objectclass: inetOrgPerson
sn: 2
userpassword: 1234

# Entry 3: cn=reader,dc=your,dc=company,dc=com
dn: cn=reader,dc=your,dc=company,dc=com
changetype: add
cn: reader
displayname: Reader
givenname: User
mail: reader@your.company.com
objectclass: inetOrgPerson
sn: 3
userpassword: 1234

# Entry 3: ou=Groups,dc=your,dc=company,dc=com
dn: ou=Groups,dc=your,dc=company,dc=com
changetype: add
objectclass: organizationalUnit
ou: Groups

# Entry 4: cn=admin,ou=Groups,dc=your,dc=company,dc=com
dn: cn=admin,ou=Groups,dc=your,dc=company,dc=com
changetype: add
cn: admin
objectclass: groupOfUniqueNames
uniquemember: cn=$LDAP_CONSOLE_ADMIN_USER,dc=your,dc=company,dc=com
uniquemember: cn=user2,dc=your,dc=company,dc=com

# Entry 5: cn=readers,ou=Groups,dc=your,dc=company,dc=com
dn: cn=readers,ou=Groups,dc=your,dc=company,dc=com
changetype: add
cn: readers
objectclass: groupOfUniqueNames
uniquemember: cn=reader,dc=your,dc=company,dc=com

# Entry 6: ou=policies,dc=your,dc=company,dc=com
dn: ou=policies,dc=your,dc=company,dc=com
changetype: add
objectclass: organizationalUnit
ou: policies

# Entry 7: cn=default,ou=policies,dc=your,dc=company,dc=com
dn: cn=default,ou=policies,dc=your,dc=company,dc=com
changetype: add
cn: default
objectclass: organizationalRole
objectclass: pwdPolicy
objectclass: top
pwdattribute: 2.5.4.35
pwdcheckquality: 2
pwdminlength: 4
pwdmustchange: TRUE

# Entry 8: ou=Users,dc=your,dc=company,dc=com
dn: ou=Users,dc=your,dc=company,dc=com
changetype: add
objectclass: organizationalUnit
ou: Users
EOF

echo "2.1 log into CRC internal registry"
podman login -u $OCP_USERNAME -p $(oc whoami -t) $OCP_INTERNAL_REGISTRY --tls-verify=false

echo "Pull LDAP image"
podman pull docker.io/osixia/openldap:latest

echo "2.3. Create Dockerfile and container"
cat > Dockerfile << EOF
FROM docker.io/osixia/openldap:latest
ENV LDAP_ORGANISATION="Your Company Name" \
LDAP_DOMAIN="your.company.com" \
LDAP_BASE_DN="dc=your,dc=company,dc=com"
COPY bootstrap.ldif /container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
EOF

podman build -t $LDAP_IMAGE .

echo "2.4 push image into OCP internal registry"
podman tag $LDAP_IMAGE:latest  $OCP_INTERNAL_REGISTRY/$NAMESPACE/$LDAP_IMAGE:latest
podman push $OCP_INTERNAL_REGISTRY/$NAMESPACE/$LDAP_IMAGE:latest --tls-verify=false

echo "3.1 Create service account"
oc create serviceaccount openldap

echo "3.2 Add the service account to the anyuid Security Context Constraint"
oc adm policy add-scc-to-user anyuid system:serviceaccount:$NAMESPACE:openldap

echo "4. Deploy the LDAP"
oc new-app $LDAP_IMAGE:latest --name=openldap -e LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD --as-deployment-config 
var='{"spec":{"strategy":{"type":"Recreate"},"template":{"spec":{"serviceAccountName":"openldap"}}}}'
oc patch dc/openldap -p $var
