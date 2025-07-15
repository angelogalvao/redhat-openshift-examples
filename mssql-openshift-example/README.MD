# Install MS SQL on Openshift

- This guide is based in the  Microsoft own tutorial: https://learn.microsoft.com/en-us/azure/openshift/tutorial-create-cluster

- Create the Secret to hold the SA password:

```
oc create secret generic mssql --from-literal=MSSQL_SA_PASSWORD="passwd@123"
```

- Create the PVC por the data persistence

```
oc apply -f mssql-data-pvc.yaml
```

- Create the service :

```
oc apply -f mssql-svc.yaml
```
