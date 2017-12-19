# Kubernetes

## Guides

* [Kubernetes from scratch](https://kubernetes.io/docs/getting-started-guides/scratch/)
* [Kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

## Other
* [Dashboard without RBAC](https://github.com/kubernetes/dashboard/tree/2b4c05b083d6f06d258d4cbc8b2b1b9583b0bc6f/src/deploy)

## Useful commands
* `kubectl --namespace=kube-system get all`
* `kubectl get pods --all-namespaces`
* `kubectl get deployments --all-namespace`
* `kubectl get services --all-namespace`
* `kubectl --namespace=kube-system get pod kubernetes-dashboard-1252450476-21dzd --output=yaml`
* `kubectl --namespace=kube-system describe deployment kubernetes-dashboard`
* `kubectl --namespace=kube-system logs kube-dns-648298301-3shwp kubedns`
* `kubectl --namespace=kube-system delete services/kube-dns deployment/kube-dns`