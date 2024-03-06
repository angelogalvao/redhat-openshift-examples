# Red Hat support for Spring Boot on Openshift

## Enviroment 

* Openshift Container Platform 4.14
* Red Hat support for Spring Boot 2.7
* Java 11 

## Some informations about this tutorial

* Starting with version 2.7, Red Hat support for Spring Boot doesn't ship with its own version of Spring Boor libraries, but rely on own Spring Boot version;
* The supportability version matrix between Spring Boot and Red Hat build of Spring Boot can be found in this URL: https://access.redhat.com/articles/3348731
* Red Hat uses the new libraries from the project [dekorate.io](dekorate.io) to annotate the code to deploy the application on Openshift Container Platform;
* The new Dekorate library verison 2.11.5.redhat-00017 is on tech preview, so it can have bugs on it. Actually, I was not able to deploy the application using this version. Becaus of that I rely on the community version 4.1.2. Notice that there is a new library in the community version:

```xml
<dependency>
    <groupId>io.dekorate</groupId>
    <artifactId>openshift-annotations</artifactId>
    <version>${dekorate.version}</version>
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

* **IMPORTANT!** The build log can thrown this exception on the logs. **Just ignore it!**
```log
[main] DEBUG io.fabric8.kubernetes.client.Config - Found for Kubernetes config at: [/home/user/.kube/config].
Error while calling hook:io.dekorate.hook.ImageBuildHook. Message:No httpclient implementations found on the context classloader, please ensure your classpath includes an implementation jar
Aborting execution of hooks:io.dekorate.hook.ImageBuildHook, io.dekorate.hook.ResourcesApplyHook.
io.fabric8.kubernetes.client.KubernetesClientException: No httpclient implementations found on the context classloader, please ensure your classpath includes an implementation jar
	at io.fabric8.kubernetes.client.utils.HttpClientUtils.getHttpClientFactory(HttpClientUtils.java:141)
	at io.fabric8.kubernetes.client.utils.HttpClientUtils.createHttpClient(HttpClientUtils.java:131)
	at io.fabric8.openshift.client.DefaultOpenShiftClient.<init>(DefaultOpenShiftClient.java:50)
```