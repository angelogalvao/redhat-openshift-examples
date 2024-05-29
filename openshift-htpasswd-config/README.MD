# Configure custom OAuth authentication.

1. Create the htpasswd file:
```sh
htpasswd -c -B -b /tmp/htpasswd user password
```

1.1. To add or update an existing file, run like this:
```sh
htpasswd -b /tmp/htpasswd newUser password
```

2. Create a secret from this file:

```sh
oc create secret generic htpasswd-secret --from-file htpasswd=/tmp/htpasswd -n openshift-config
```

3. Create the OAuth resource on the cluster

```sh 
oc replace -f oauth.yaml -n openshift-config
```

4. Give the user admin privilegies

```sh 
oc adm policy add-cluster-role-to-user cluster-admin user
```