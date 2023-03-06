# Commands

- [online play ground](https://labs.play-with-docker.com/)

## Docekrfile

- `Docekrfile`
    ```
    FROM centos:7
    WORKDIR /app
    ADD jdk-8u152-linux-x64.tar.gz /
    RUN yum install -y wget
    ENV JAVA_HOME=/jdk1.8.0_152
    EXPOSE 8080
    CMD ["/apache-tomcat-7.0.82/bin/catalina.sh", "run"]
    ```

    - `FROM <base image>`: base image
    - `WORKDIR` : work path
    - `RUN`: linux commands
    - `ADD <host/files> <conatiner/path>`: move files into container
    - `ENV`: enviroment var
    - `EXPOSE` : which port you want to use, sill need to map host port at runtime.
    - `CMD`: run command when container starts

## Image 

- from Dockerfile

    - `docker build -t <imagename> --no-cache <Dockerfile path>`

- from [dockerhub](https://hub.docker.com/)

    - `docker pull <imagename>`

- build to `.tar`

    - `docker save -o <filename>.tar <imagename>`

- from `.tar`

    - `docker load -i <filename>.tar`

## Container

- `docker ps -a` : log containers
- `docker start <container>` : start container
- `docker stop <container>` : stop container
- `docker exec -it <container> bash` : enter container
- `exit` : leave container, type in container's bash
- `docker cp <from> <to>` : transfer files between host and container
- `docker container rm <container id>` : remove stoped container
- `docker system prune`

## Network

- [reference](./refereneces/docker_network.html)
- communicate between containers
- `docker network ls`: show all networks
- `docker network rm <network name>`: remove network
- `docker network create <network name>` : create network
- `docker network inspect <network name>` : check containers in the network
- `docker network connect <network name> <container name>`: add container to network

## Run

- `docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]`
    - [document](https://docs.docker.com/engine/reference/run/)
    - options :
        - `--name <container name>` : container name
        - `-v <host/filePath>:<container/filePath>` : sync host files in container
        - `-e NVIDIA_VISIBLE_DEVICES=2,3` : enable gpu
        - `-p 2222:22` : open port
        - `-d` : run in background
        - `-it` : run in foreground
        - `--network <network name>` : use network

## Docker-compose

- alternative way of execute multiple `docker run`
- `docker-compose.yml`

    ```
    version: '3'

    services:
        serviceName1:
            build:
                context: ./nodedocker_app
            container_name: nodejsserver
            hostname: nodejsserver
            volumes:
                - <host/filePath>:<container/filePath>
            command: npm start
            networks:
                - example-net

        serviceName2:
            image: nginx
            ports:
                - "80:80"
            networks:
                - example-net

    networks:
        example-net:
            external: true
    ```

    - `build: context: <path/to/dockerfile>`: build image from dockerfile
    - `hostname: <host alias>`: communicate between containers with this name
    - `external`: join a pre-existing network
        - `false`: create new if not found
        - `true`: throw error if not found
 
- `docker-compose -f {where/is/.yml} up -d` : run conatiners
- `docker-compose -f {where/is/.yml} down` : stop conatiners
