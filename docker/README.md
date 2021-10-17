
## Login DGX

- Tool : 
    - Windows : [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) 
    - ubuntu : [asbru-cm](https://www.asbru-cm.net/)


- `Session/SSH` :
    - `Remote host`
    - `Specfy username`
    - `password`, 直接輸入即可,console不會顯示。

## WSL

- Install

```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce
```
- start or stop docker

```
sudo service docker start
sudo service docker stop
```
- test container with GPU with version `19.03+`
```
sudo docker run --gpus all nvcr.io/nvidia/k8s/cuda-sample:nbody nbody -gpu -benchmark
```

## Install docker

 - [tutorial](https://medium.com/@grady1006/ubuntu18-04%E5%AE%89%E8%A3%9Ddocker%E5%92%8Cnvidia-docker-%E4%BD%BF%E7%94%A8%E5%A4%96%E6%8E%A5%E9%A1%AF%E5%8D%A1-1e3c404c517d)

 - [offical](https://docs.docker.com/engine/install/ubuntu/)

```
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```    

## Volume(shared folder)

- 在`docker run`指令中加入參數`-v host_folder`:`/container_folder`
    - `host_folder` : 在主機的資料夾
        - Docker for Windows : `C:\Users\tseng\...`
        - Docker Toolbox on Windows : `/c/User/...`
    - `/container_folder` : 在container中的資料夾
    
## Container

- `nvidia-docker run --name YOLO -v /folderOnLocal:/root -p 2222:22 -e NVIDIA_VISIBLE_DEVICES=2,3 -dt ubuntu:16.04`: 安裝 docker container
    - `--name YOLO`：container名字
    - `-v /folderOnLocal:/root`:掛載`/folderOnLocal`到container的`/root`
    - `-e NVIDIA_VISIBLE_DEVICES=2,3`：要使用哪張顯卡
    - `-p 2222:22`: container對應哪個port
    - `-dt tensorflow/tensorflow:latest-gpu-py3` : 要裝的pull的映像檔
    - [Found no NVIDIA driver on your system](https://github.com/NVIDIA/nvidia-docker/issues/533) : `docker run -ti --runtime=nvidia -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=all ...`
- `docker exec -it <NAME> bash` : 進入環境

- `docker ps` : 列出正在使用的container
- `docker pull <NAME>` : 從[dockerhub](https://hub.docker.com/)下載映像檔
    ```
    docker pull ubuntu:18.04
    ```
- `nvidia-smi` : 查看顯卡使用狀況
- `nvidia-docker start <NAME>` : 打開container
- `docker stop <NAME>` : 關掉container
- `exit` : 退出環境
- `docker cp <from> <to>` :將檔案/資料夾傳入傳出container
    - `<container-name>:/<path in container>` : `openpose-M10815098:/openpose`
    - `<host path>` : `/home/dgx_user1/Desktop`
- `docker container rm <container id>` : 用`docker container ls -a`找到要移除的`<container id>`,記得先關掉
- `docker system prune`,刪除下列物件
    - all stopped containers
    -  all networks not used by at least one container
    - all dangling images
    - all dangling build cache

## Container  with GUI

- [Docker image with OpenCV with X11 forwarding for GUI](https://marcosnietoblog.wordpress.com/2017/04/30/docker-image-with-opencv-with-x11-forwarding-for-gui/)
    ```
    xhost +
    sudo docker run --name openpose -ti --net=host --ipc=host --gpus all -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -dt exsidius/openpose
    ```

## Edit file 

- Vim in bash
    - `apt-get update`
    - `apt-get install vim`
    - 結束編輯`:x + Enter`
    - 切換到插入模式 : `i` , `Esc`結束

- Jupyter notebook in browser

    - Install
        ```
        apt update
        apt install python3-pip -y
        pip3 --version
        pip3 install --upgrade pip
        pip3 install jupyter
        ```
    - Run : 
        - 確認port在建立container時有做設定`-p 2222:22` 
        - 以對應的port`22`開啟 `jupyter notebook --no-browser --port 22 --ip 0.0.0.0 --allow-root`
        ```
        [I 09:41:10.756 NotebookApp] Serving notebooks from local directory: /root
        [I 09:41:10.756 NotebookApp] Jupyter Notebook 6.4.4 is running at:
        [I 09:41:10.756 NotebookApp] http://1bdd0c753134:22/?token=28c2bad4109495d25e347dda4b9ed1adab9700cbee94a8ef
        [I 09:41:10.756 NotebookApp]  or http://127.0.0.1:22/?token=28c2bad4109495d25e347dda4b9ed1adab9700cbee94a8ef
        [I 09:41:10.756 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
        [C 09:41:10.762 NotebookApp]

            To access the notebook, open this file in a browser:
                file:///root/.local/share/jupyter/runtime/nbserver-4331-open.html
            Or copy and paste one of these URLs:
                http://1bdd0c753134:22/?token=28c2bad4109495d25e347dda4b9ed1adab9700cbee94a8ef
            or http://127.0.0.1:22/?token=28c2bad4109495d25e347dda4b9ed1adab9700cbee94a8ef

        ```
        - 使用browser開啟port`2222`的網頁 `140.118.175.94:2222`
        - 登入頁使用上方token `28c2bad4109495d25e347dda4b9ed1adab9700cbee94a8ef`

## Run process in the background

- `apt-get install screen`
- `screen` : 建立新的cmd
- 將目前process放到background執行,在screen建立的cmd中按`ctrl+a`+`d`(detach)
- `screen -ls`: 查詢正在執行的process
- `screen -rd <id>` : `id`可從`screen -ls`找到 
- `screen -X -S <id>`: 關閉attached cmd

## File Transmit

 - `scp <src>  <dst>`
    - `<src>`, `<dst>`可為為路徑 : `username@IP:path`
    - 若路徑為 `.../folder/`,加參數`-r`

## Dockerfile
- [tutorial](https://ithelp.ithome.com.tw/articles/10191016)
- `Docekrfile`
    - sample : 
        ```
        FROM centos:7
        MAINTAINER jack

        RUN yum install -y wget

        RUN cd /

        ADD jdk-8u152-linux-x64.tar.gz /

        RUN wget http://apache.stu.edu.tw/tomcat/tomcat-7/v7.0.82/bin/apache-tomcat-7.0.82.tar.gz
        RUN tar zxvf apache-tomcat-7.0.82.tar.gz

        ENV JAVA_HOME=/jdk1.8.0_152
        ENV PATH=$PATH:/jdk1.8.0_152/bin
        CMD ["/apache-tomcat-7.0.82/bin/catalina.sh", "run"]
        ```
    - `FROM`: 使用到的 Docker Image 名稱
    - `MAINTAINER` : 作者,也可以給 E-mail的資訊
    - `RUN`: Linux 指令
    - `ADD`: 跑`docker build `時把 Local 的檔案複製到 Image 裡，如果是 tar.gz 檔複製進去 Image 時會順便自動解壓縮。
    - `ENV`:用來設定環境變數
    - `CMD`:在指行`docker run`的指令時會直接呼叫開啟 Tomcat Service
- `image`
    - `cd`到`dockerfile`同層開啟terminal
    - `docker build -t <dock> . --no-cache`

## Docker Hub

- `docker export` 將容器存成本機檔案

    `docker export <conatinerName> -o <filename>.tar`

- `docker import` 將容器匯入為`image`

    - `docker import <filename>.tar`,匯入不命名的`image`

        ```
        C:\Users\tseng>docker import ocr.tar
        sha256:f85e453a4a760c1cfc4401c0ddea9b1532fcb926d54a03299c46dc723baedd6d

        C:\Users\tseng>docker images -a
        REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
        <none>              <none>              f85e453a4a76        7 minutes ago       2.63GB
        ubuntu              16.04               005d2078bdfa        3 weeks ago         125MB
        ```
    - `cat <filename>.tar | sudo docker import - <image name>`,匯入命名的`image`(`windows`中使用需要`gitbash`)

- 將`image`上傳到dockerhub
    ```
    docker tag <tag> tsengyushiang/<reponame>
    docker push tsengyushiang/<reponame>
    ```
