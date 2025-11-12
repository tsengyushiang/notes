# GitOps

## k3s

### Option1: offical k3s

- [Document](https://docs.k3s.io/quick-start)
```bash
curl -sfL https://get.k3s.io | sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

### Option2: colima

- [Document](https://github.com/abiosoft/colima)
```bash
colima stop
colima start --runtime containerd --kubernetes -p k3s
export KUBECONFIG=~/.kube/config
```

### Installation


## Argo CD

- [Document](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)

### Installation

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Configuring Git repository and target cluster

- [Document](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/)
- Create `application.yaml`

```yml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-argo-application
  namespace: argocd
spec:
  project: default

  source:
    repoURL: https://gitlab.com/nanuchi/argocd-app-config.git
    targetRevision: HEAD
    path: dev
  destination:
    server: https://kubernetes.default.svc
    namespace: myapp

  syncPolicy:
    syncOptions:
      - CreateNamespace=true
```

- Apply to k3s

```bash
kubectl apply -f application.yaml
```


### Login UI

- Get the password for the default user `admin`. The password has the format `<password>%`

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

- Expose the Argo CD server port and visit https://localhost:8080 in your browser:

```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
```