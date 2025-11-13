# GitOps

## k3s

### Installation

#### option1: offical k3s

- [Document](https://docs.k3s.io/quick-start)

```bash
curl -sfL https://get.k3s.io | sh -

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

#### option2: colima

- [Document](https://github.com/abiosoft/colima)

```bash
colima stop
colima start --runtime containerd --kubernetes -p k3s
export KUBECONFIG=~/.kube/config
```

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
    repoURL: https://gitlab.com/delta.yushiang.tseng/argocd.git
    targetRevision: HEAD
    path: myapp
  destination:
    server: https://kubernetes.default.svc
    namespace: myapp

  syncPolicy:
    syncOptions:
    - CreateNamespace=true

    automated:
      selfHeal: true
      prune: true
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

## Docker Registry

### Installation

```bash
docker run -d -p 5000:5000 -v /home/user1/storage:/var/lib/registry --name registry registry:2
```

### Push Image to Registry

- Sample `Dockerfile`

```dockerfile
FROM alpine:3.18
ARG MY_ARG="default_value"
RUN echo "Build argument is: ${MY_ARG}"
ENV MY_ARG=${MY_ARG}
CMD ["sh", "-c", "while true; do echo Running with argument: ${MY_ARG}; sleep 5; done"]
```

- Build and push

```bash
docker build -t test .
docker tag test localhost:5000/test
docker push localhost:5000/test
```

## GitLab CI for Building Docker Images

### Register a GitLab Runner

```
docker run -d --name gitlab-runner --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest

docker exec -it gitlab-runner gitlab-runner register --url https://gitlab.com --token copy-from-gitlab-ui
```

### Sample `.gitlab-ci.yml`

```yml
stages:
  - build

build_image:
  stage: build
  image: docker:24.0.2
  services:
    - docker:24.0.2-dind
  variables:
    IMAGE_TAG: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG --build-arg MY_ARG=$CI_COMMIT_SHA -f Dockerfile .
    - docker push $IMAGE_TAG
```

