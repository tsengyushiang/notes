# K3s

### Start with colima

```
colima start --kubernetes --cpu 4 --memory 32
 
% colima list
PROFILE    STATUS     ARCH       CPUS    MEMORY    DISK      RUNTIME       ADDRESS
default    Running    aarch64    4       32GiB     100GiB    docker+k3s
```

### Load Image 

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
```

```yml
containers:
  - name: frontend
    image: localhost:5000/frontend:latest
```

## Rancher

### Run with Docker

- Execute the following command to run the Rancher container:

```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 --privileged rancher/rancher
```

- Once the container is running, access the Rancher UI by navigating to `https://localhost` in your web browser. 

- Retrieve the initial administrator password by running the following command:

```
docker logs -f <container-id> | grep "Bootstrap Password:"
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
