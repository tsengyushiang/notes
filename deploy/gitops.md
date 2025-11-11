# GitOps

## k3s

- [Reference](https://docs.k3s.io/quick-start)

### Installation

```bash
curl -sfL https://get.k3s.io | sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

## Argo CD

- [Reference](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)

### Installation

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
