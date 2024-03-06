# Red Hat support for Spring Boot on Openshift - Deploy using Tekton Pipelines

## Enviroment 

- Openshift Container Platform 4.14
- Red Hat support for Spring Boot 2.7
- Java 11 

## Some informations about this tutorial

- You need to install the Pipeline Operator on OpenShift

## Pipeline pre-configuration

- Create a ConfigMap with the maven settings file, setting.xml, that will be used by the Maven test:

```
oc create configmap maven-settings --from-file=src/main/tekton/settings.xml
```

## Deploying the pipeline

* To deploy the application just run the following command:

```shell
oc apply -f src/main/tekton/pipeline.yaml
```

## Run the pipeline

* To deploy the application just run the following command:

```shell
oc apply -f src/main/tekton/pipeline-run.yaml
```