
## Generate the Openshift project 

oc new-project artemis-keycloak-example --display-name="Artemis Keycloak Example" --description="Artemis integration with Keycloak Example"

## Generate the Truststore

oc extract secret/router-certs-default -n openshift-ingress --keys=tls.crt --to=/tmp --confirm
keytool -import -noprompt -file /tmp/tls.crt -alias {{.apps.ocp1.home|| change to your enviroment}} -keystore truststore.jks -storepass password

## Generate the Config Map from the truststore

oc create cm rhsso-truststore --from-file truststore.jks

## Preparing the file

Edit bellow files properties with the correct URL of your Openshift enviroment. 

- 006-ActiveMQArtemisSecurity.yaml
- 008-KeycloakClient.yaml

## Install the operators

oc create -f 001-Operator.yaml

## Build the resouces

oc create -f .

## Build the Init Contianer

oc start-build amq-init



## It is always failing to delete the project - run this:

oc get namespace artemis-keycloak-example -o json > tmp_ns.json

- Remove the line with "kubernetes" (under "finalizers"):

oc proxy &
curl -k -H "Content-Type: application/json" -X PUT --data-binary @tmp_ns.json http://127.0.0.1:8001/api/v1/namespaces/artemis-keycloak-example/finalize


# oc get namespace $NS_TO_DELETE -o json | jq '.spec = {"finalizers":[]}' > tmp_ns.json
