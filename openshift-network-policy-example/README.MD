# Network Policy Example

- Create two projects:

```sh
oc new-project database-server-project
oc new-project database-client-project
```

## Deploying the Server project

- Go to the project

```sh
oc project database-server-project
```

- If you which, verify the parameters to the MySQL Ephemeral template:
```sh
oc process --parameters -n openshift mysql-ephemeral
```
- Deploy the MySQL Server in project database-server-project

```sh
oc new-app mysql --name mysql-server MYSQL_USER=test MYSQL_PASSWORD=test MYSQL_DATABASE=test -l app=mysql-server
```

- Insert some test data to the database server

```sh
MYSQL_POD=$(oc get pods -o json | jq -r '.items[].metadata.name')

oc cp test-data.sql $MYSQL_POD:/tmp 

oc rsh $MYSQL_POD
```

- Then import it on the pod 
```sh
mysql -u test -D test -ptest < /tmp/test-data.sql
```

## Deploying the Client project

- Go to the client project

```sh
oc project database-client-project
```

- Deploy the MySQL Server in project database-client-project. NOTICE that for this deployment, I don't care about the database itself, I only used this image for the "mysql" client library.

```sh
oc new-app mysql --name mysql-client MYSQL_USER=test MYSQL_PASSWORD=test MYSQL_DATABASE=test -l app=mysql-client
```
- Get the pod name

```sh
MYSQL_CLI_POD=$(oc get pods -o json | jq -r '.items[].metadata.name')
```
- Access the pod and access the mysql-server in the other project:

```sh
oc rsh $MYSQL_CLI_POD

mysql -u test -D test -ptest -h mysql-server.database-server-project.svc.cluster.local
```

To confirm that it is acessing, run the following SQL:

```sql
select * from test;
```

## Configuring the Network Policies

### Dennying access to the server

- Go to the project
```sh
oc project database-server-project
```

- Deny access to the mysql-server
```sh
oc create -f deny-all-policy.yaml 
```

- Test in the client pod (**IT SHOULD FAIL**):
```sh
oc project database-client-project
oc rsh $MYSQL_CLI_POD
mysql -u test -D test -ptest -h mysql-server.database-server-project.svc.cluster.local
```

### Alloying access to the server by a specific network policy

- Annotate the Client project:
```sh
oc label namespace database-client-project network=mysql-network
```

- Create the network policy:
```sh
oc create -f mysql-client-access-policy.yaml -n database-server-project
```

- Test in the client pod (**IT SHOULD WORK**):
```sh
oc project database-client-project
oc rsh $MYSQL_CLI_POD
mysql -u test -D test -ptest -h mysql-server.database-server-project.svc.cluster.local
```
