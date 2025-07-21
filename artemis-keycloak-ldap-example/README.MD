# ActiveMQ Artemis integration with Keycloak + LDAP

## Install Keycloak

1. Install Postgres database

~~~
oc apply -f 001-database.yaml
~~~

2. Create the Certificates and keys 

~~~
openssl req -subj '/CN=keycloak-artemis.ocp1.home/O=Test Keycloak Artemis./C=US' -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
openssl x509 -outform der -in certificate.pem -out certificate.crt
keytool -import -noprompt -file certificate.crt -alias keycloak-artemis.ocp1.home -keystore truststore.jks -storepass password
oc create secret generic 
~~~

3. Database credentials secret (The values are configured in 001-database.yaml )

~~~
oc create secret generic keycloak-db-secret \
  --from-literal=username=testuser \
  --from-literal=password=testpassword
~~~

4. Deploy Keycloak

~~~
oc apply -f 002-keycloak.yaml
~~~

5. Get the temporary user and password

~~~
oc get secret example-kc-initial-admin -o jsonpath='{.data.username}' | base64 --decode
oc get secret example-kc-initial-admin -o jsonpath='{.data.password}' | base64 --decode
~~~

## Install AMQ


1. Configure login.config secret

~~~
oc create secret generic sso-jaas-config --from-file=login.config --from-file=_keycloak-bearer-token.json --from-file=_keycloak-direct-access.json --from-file=_keycloak-js-client.json --from-file=truststore.jks
~~~

2. Configure logging.properties config map

~~~
oc create cm newlog4j-logging-config --from-file=logging.properties
~~~

3. Deploy ActiveMQ Artemis 

~~~
oc apply -f 003-artemis.yaml
~~~