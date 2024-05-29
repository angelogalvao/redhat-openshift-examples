
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