# Manage Openshift operator using CLI.

- Create the project

```sh
oc new-project operators-managment-example
```

- Search for the Red Hat AMQ operator:

```sh
oc get packagemanifests | grep amq-broker-rhel8
```

- Get the details of the Red Hat AMQ operator:

```sh
oc get packagemanifests amq-broker-rhel8 -o jsonpath="{range .status.channels[*]}Channel: {.name} currentCSV: {.currentCSV}{'\n'}{end}"
```

- Get the catalog source

```sh
oc get packagemanifests amq-broker-rhel8 -o jsonpath={.status.catalogSource}
oc get packagemanifests amq-broker-rhel8 -o jsonpath={.status.catalogSourceNamespace}
```

- Configure the operator-group.yaml and subscription.yaml with the values. 

- Create the resources on the project:
```sh
oc create -f subscription.yaml
```

- If the approval is manual, execute the following:

```sh
oc get installplan
oc patch installplan <installplan-name> --type merge --patch '{"spec":{"approved":true}}'
```
