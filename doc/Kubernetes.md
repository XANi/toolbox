# Kubernetes

## Guides

* [Kubernetes from scratch](https://kubernetes.io/docs/getting-started-guides/scratch/)
* [Kubernetes the hard way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

## Gotchas

* kube-apiserver cert should have apiserver API IP in altnames, else some things fail

## Other
* [Dashboard without RBAC](https://github.com/kubernetes/dashboard/tree/2b4c05b083d6f06d258d4cbc8b2b1b9583b0bc6f/src/deploy)

### Dashboard cert

    kubectl create secret -n kubernetes-dashboard generic kubernetes-dashboard-certs --from-file=/etc/pki/puppet/kube-dashboard.pem -o yaml --dry-run=client |perl -pi -e 's/kube-dashboard.pem:/tls.crt:/' | kubectl apply -f -


          containers:
        - name: kubernetes-dashboard
          image: 'kubernetesui/dashboard:v2.0.0-rc2'
          args:
            - '--auto-generate-certificates'
            - '--namespace=kubernetes-dashboard'
            - '--token-ttl=0'
            - '--tls-cert-file=/tls.crt'
            - '--tls-key-file=/tls.crt'

tls-cert/key is ones that need adding


## Useful commands
* `kubectl --namespace=kube-system get all`
* `kubectl get pods --all-namespaces`
* `kubectl get deployments --all-namespace`
* `kubectl get services --all-namespace`
* `kubectl --namespace=kube-system get pod kubernetes-dashboard-1252450476-21dzd --output=yaml`
* `kubectl --namespace=kube-system describe deployment kubernetes-dashboard`
* `kubectl --namespace=kube-system logs kube-dns-648298301-3shwp kubedns`
* `kubectl --namespace=kube-system delete services/kube-dns deployment/kube-dns`
* `kubectl get pvc --all-namespaces` - persistent volume claims
* `kubectl get storageclass` - storage classes it uses
* `kubectl rollout restart -n kubernetes-dashboard deployment kubernetes-dashboard` - rolling restart

## encode secret as env

    kubectl get secret --namespace test s3-backup -o json | jq --raw-output '.data | to_entries | .[] | "\(.key)=\(.value | @base64d)"'

get secret `s3-backup` from namespace `test` and output it in env form

    KEY=value


## getting admin token

* `kubectl get serviceaccounts --namespace=kube-system admin-user -o yaml`
* `kubectl describe secret admin-user-token-g2p89 --namespace kube-system`
* `kubectl get secret --namespace=kube-system admin-user-token-g2p89 -o yaml`
* `kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^admin-user-token-/{print $1}') | awk '$1=="token:"{print $2}'` - dashboard token


## Namespace

* `kubectl config set-context --current --namespace=qubebot` - change namespace in the current context


## DNS rewrite

in coredns config:

        rewrite stop {
            name suffix .ops.example.com  .cluster.local answer auto
        }
        kubernetes cluster.local in-addr.arpa ip6.arpa {
          pods insecure
          fallthrough in-addr.arpa ip6.arpa
        }


it MUST rewrite in both directions else funny stuff happens

## restarting/downtiming node

    kubectl drain --ignore-daemonsets --delete-emptydir-data kube1
    kubectl uncordon kube1


## RBAC

  * https://kubernetes.io/docs/reference/access-authn-authz/rbac/
  * https://kubernetes.io/docs/reference/access-authn-authz/authentication/
