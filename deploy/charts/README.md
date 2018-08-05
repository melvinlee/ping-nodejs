# Quickstart

## Template

The most important piece of the puzzle is the templates/ directory. This is where Helm finds the YAML definitions for your Services, Deployments and other Kubernetes objects.

We can do a dry-run of a helm install and enable debug to inspect the generated definitions:

```sh
$ helm install --dry-run --debug ./ping

[debug] Created tunnel using local port: '59082'
[debug] SERVER: "127.0.0.1:59082"

NAME:   ordered-ocelot
REVISION: 1
RELEASED: Fri Aug  3 13:52:21 2018
CHART: ping-0.2.0
USER-SUPPLIED VALUES:
{}

COMPUTED VALUES:
affinity: {}
backendbar:
  image:
    pullPolicy: IfNotPresent
    repository: melvinlee/micro-backend-bar
    tag: v1
  name: backendbar
  resources:
    limits:
      cpu: 150m
    requests:
      cpu: 100m
  service:
    port: 80
    type: ClusterIP
.....
```

If a user of your chart wanted to change the default configuration, they could provide overrides directly on the command-line:

```sh
helm install --dry-run --debug ./ping --set service.internalPort=8080
```

For more advanced configuration, a user can specify a YAML file containing overrides with the --values option.

