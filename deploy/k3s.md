# K3s

## Qucik Start with colima

```
colima start --kubernetes --cpu 4 --memory 32 -p k3s
 
% colima list
PROFILE    STATUS     ARCH       CPUS    MEMORY    DISK      RUNTIME       ADDRESS
default    Running    aarch64    4       32GiB     100GiB    docker+k3s
```
> Use `--k3s-arg "--write-kubeconfig-mode=644"` to overwrite the default arguments and ensure Traefik is enabled.

> Use the `--network-address` and `--network-mode bridged` flags for bridge networks. For external connectivity, update the DNS via Colima:`
colima ssh -- sudo sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf`

> To view the VM configuration, run: `cat ~/.colima/${profile}/colima.yaml`.

## Sample Application

### Load Custom Image 

- Option 1: Use local cache via YAML configuration.

```yml
containers:
  - name: frontend
    image: frontend:latest
    imagePullPolicy: IfNotPresent
```

- Option 2: Use a local registry for image distribution.

```bash
docker run -d -p 5000:5000 --restart always --name registry registry
docker tag frontend:latest localhost:5000/frontend:latest
docker push localhost:5000/frontend:latest
```

```yml
containers:
  - name: frontend
    image: localhost:5000/frontend:latest
```
### Manifests

- Define Manifests: create a file named `demo.yaml` with the following resources:

```yml
---
apiVersion: v1
kind: Namespace
metadata:
  name: demo
---

apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend
          image: nginx

---
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: demo
spec:
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 80

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx
  namespace: demo
spec:
  rules:
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: frontend-service
                port:
                  number: 80
```

### Execute Deployment

```
/Users/yushiang.tseng/Desktop
% kubectl apply -f ./demo.yaml

namespace/demo created
deployment.apps/frontend created
service/frontend-service created
ingress.networking.k8s.io/ingress created
```

### Cleanup

```
kubectl delete -f ./demo.yaml
```

## Agent

### Agent Configuration

- Update TLS SAN & Restart

Identify the IP address and restart Colima with the `--tls-san` flag to allow external API access.

```bash
% colima list
PROFILE      STATUS     ARCH       CPUS    MEMORY    DISK      RUNTIME       ADDRESS
default      Stopped    aarch64    4       32GiB     100GiB                  
k3s          Running    aarch64    4       32GiB     100GiB    docker+k3s    192.168.1.24

colima stop -p k3s
colima start -p k3s --k3s-arg "--tls-san=192.168.1.24"
```

- Extract Credentials & Port

SSH into the instance to retrieve the cluster token and verify the API port.

```bash
colima ssh -p k3s

lima@colima-k3s:/$ cat /var/lib/rancher/k3s/server/node-token
K10db701baf4cc01280128a29aeaa26d85a6b9759ac7078ce194229ef6f3128ca40::server:8aff78f94df2cce86df02b3f821b4ab7

lima@colima-k3s-agent:/$ cat /etc/systemd/system/k3s.service
...
server \
   '--write-kubeconfig-mode' \
   '644' \
   '--tls-san=192.168.1.24' \
   '--docker' \
   '--advertise-address' \
   '192.168.1.24' \
   '--flannel-iface' \
   'col0' \
   '--https-listen-port' \
   '62988' \
```

- Verify Connection

Test the API health endpoint using the updated IP and port.

```bash
lima@colima-k3s:/$ curl -k https://192.168.1.24:62988/livez
```

### Configure Agent VM

- Provision Instance

Start a new Colima instance with bridged networking.

```bash
colima start -p k3s-agent \
  --cpu 4 --memory 32 \
  --network-address \
  --network-mode bridged 
```

- Join Cluster

SSH into the agent and execute the K3s installation script to connect to the server.

```bash
colima ssh -p k3s-agent
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.1.24:62988 K3S_TOKEN=K10db701baf4cc01280128a29aeaa26d85a6b9759ac7078ce194229ef6f3128ca40::server:8aff78f94df2cce86df02b3f821b4ab7 sh -s - agent
```

### Verify Agent Connectivity

- Confirm Node Status

Verify that the agent has successfully joined the cluster.

```bash
lima@colima-k3s:/$ kubectl get nodes
NAME               STATUS   ROLES                  AGE   VERSION
colima-k3s         Ready    control-plane,master   12d   v1.33.4+k3s1
colima-k3s-agent   Ready    <none>                 76s   v1.34.4+k3s1
```

- Locate Pods by Node

Filter pods to confirm they are scheduled on the specific agent node.

```
lima@colima-k3s:/$ kubectl get pod -A -o wide | grep "colima-k3s-agent"
NAMESPACE       NAME        READY   STATUS             IP             NODE
demo            some-pod    0/1     ImagePullBackOff   192.168.5.3    colima-k3s-agent
```
> `ImagePullBackOff` occurs because `localhost:5000` is unreachable from the agent. Ensure the agent has access to a shared registry or a local copy of the image.

### Agent Reset Guide

- Clear Password on Agent: `sudo rm /etc/rancher/node/password`
- Remove Node from Server: `kubectl delete node colima-k3s-agent`
 
## Rancher

### Run with Docker

- Execute the following command to run the Rancher container:

```
docker run -d --restart=unless-stopped --name rancher -p 80:80 -p 443:443 --privileged rancher/rancher
```

- Once the container is running, access the Rancher UI by navigating to `https://localhost` in your web browser. 

- Retrieve the initial administrator password by running the following command:

```
docker logs -f rancher 2>&1 | grep "Bootstrap Password:"
```

- Follow the on-screen prompts to set a new password for the `admin` account.

- Import your K3s cluster: In the Rancher UI, navigate to **Import Existing** > **Generic** and provide a cluster name.

- Register the cluster: Copy the registration command provided by the UI and run it in your terminal. For example:

```
curl --insecure -sfL https://10.139.83.229/v3/import/fgfdc27wwtlq6gqk5b7wwtrdkr9m4zx7w2dvhrq5tg2zg4xw5mm6f6_c-bglj2.yaml | kubectl apply -f -
```

- If your K3s cluster cannot reach Rancher:

    - Remove the existing registration: Clear the failed agent components by deleting the namespace:

    ```
    kubectl delete namespace cattle-system
    ```

    - Navigate to **Global Settings > server-url** in the Rancher UI and update it to an IP address accessible by the K3s cluster.
