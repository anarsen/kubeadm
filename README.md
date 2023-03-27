# Kubernetes Bare Metal

## Provision Control Plane

```sh
ansible-playbook \
    -i inventory/test/hosts.yaml \
    kube_control_plane \
    --tags control_plane \
    ansible/kube.yaml
```

## Provision Workers

```sh
ansible-playbook \
    -i inventory/test/hosts.yaml \
    kube_workers \
    --tags workers \
    ansible/kube.yaml
```

## Deploy Kubernetes Components


This deploys

- Calico (Pod network add-on)
- Metrics server
- NGINX ingress controller
- Prometheus
- Loki
- Mimir
- Grafana
- Goldpinger

```sh
cd environments/test
terraform init
terraform apply
```

## Authentication

This repo includes a [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/), which is configured for the test cluster.
It will authenticate users through OIDC.

### Prerequisites

For the OIDC flow to work, you will need to have [kubelogin](https://github.com/int128/kubelogin) installed.
Summarizing the installation instructions here:

```
# Homebrew (macOS and Linux)
brew install int128/kubelogin/kubelogin

# Krew (macOS, Linux, Windows and ARM)
kubectl krew install oidc-login

# Chocolatey (Windows)
choco install kubelogin
```

### Access Cluster

```sh
export KUBECONFIG=$(pwd)/environments/test/kube.conf"

kubectl get nodes
kubectl get pods --all-namespaces
```

Enjoy!
