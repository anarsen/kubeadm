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

## Access Cluster

```sh
export KUBECONFIG=$(pwd)/admin.conf
kubectl get pods --all-namespaces
```
