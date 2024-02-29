oc create secret docker-registry docker-registry \
    --docker-server docker.io \
    --docker-username USER \
    --docker-password PASSWORD \
    --docker-email=EMAIL

oc secrets link --for=pull default docker-registry

11:20:48.615 [main] DEBUG io.fabric8.kubernetes.client.Config - Found for Kubernetes config at: [/home/angelo/.kube/config].
Error while calling hook:io.dekorate.hook.ImageBuildHook. Message:No httpclient implementations found on the context classloader, please ensure your classpath includes an implementation jar
Aborting execution of hooks:io.dekorate.hook.ImageBuildHook, io.dekorate.hook.ResourcesApplyHook.
io.fabric8.kubernetes.client.KubernetesClientException: No httpclient implementations found on the context classloader, please ensure your classpath includes an implementation jar
	at io.fabric8.kubernetes.client.utils.HttpClientUtils.getHttpClientFactory(HttpClientUtils.java:141)
	at io.fabric8.kubernetes.client.utils.HttpClientUtils.createHttpClient(HttpClientUtils.java:131)
	at io.fabric8.openshift.client.DefaultOpenShiftClient.<init>(DefaultOpenShiftClient.java:50)
