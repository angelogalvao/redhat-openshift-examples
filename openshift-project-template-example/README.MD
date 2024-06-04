# Creating a Project Template from scratch

- Create a template Template resource and edit the template.yaml as expected:

```sh
oc adm create-bootstrap-project-template -o yaml > template.yaml
```

- Create a template from file on OCP cluster:

```sh
oc create -f  template.yaml -n openshift-config
```

- Edit OCP projects resource to use the new template for projects: 

```sh
oc edit projects.config.openshift.io cluster
```

- Add the following config in the spec field:

```yaml
  projectRequestTemplate:
    name: project-request
```

- Create a new project to test if the new template is working:

```sh
oc new-project template-project
```

## Remove the configuration

- Remove the template projectRequestTemplate declaration from projects.config.openshift.io resource:
```sh
oc edit projects.config.openshift.io cluster
```

- Delete the template from OCP:
```sh
oc delete template project-request -n openshift-config
```