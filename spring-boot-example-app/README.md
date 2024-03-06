# Red Hat support for Spring Boot on Openshift

## Enviroment 

* Openshift Container Platform 4.14
* Red Hat support for Spring Boot 2.7
* Java 11

## Some informations about this tutorial

* Starting with version 2.7, Red Hat support for Spring Boot doesn't ship with its own version of Spring Boor libraries, but rely on own Spring Boot version;
* The supportability version matrix between Spring Boot and Red Hat build of Spring Boot can be found in this URL: https://access.redhat.com/articles/3348731
* Red Hat uses the new libraries from the project [dekorate.io](dekorate.io) to annotate the code to deploy the application on Openshift Container Platform;
* The new Dekorate library verison 2.11.5.redhat-00017 is on tech preview, so it can have bugs on it. 

```xml
<dependency>
    <groupId>io.dekorate</groupId>
    <artifactId>openshift-spring-starter</artifactId>
    <version>2.11.5.redhat-00017</version>
</dependency>
```

## Openshift pre-configuration

* The dekorate plugin use images that are only available at Docker registry docker.io. Sometimes, Openshift is not able to download the images because docker.io is throttling requests from anonymous users. So, if you are facing that, add the registry credentials to give you an extra breath on the registy:

```bash
oc create secret docker-registry docker-registry \
    --docker-server docker.io \
    --docker-username USER \
    --docker-password PASSWORD \
    --docker-email=EMAIL

oc secrets link --for=pull default docker-registry
```
## Deploying the application

* To deploy the application just run the following command:

```bash
./mvnw clean install -Ddekorate.deploy=true
```