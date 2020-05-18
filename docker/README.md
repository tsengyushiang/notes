
## Login DGX

- Tool : 
    - Windows : [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) 
    - ubuntu : [asbru-cm](https://www.asbru-cm.net/)


- `Session/SSH` :
    - `Remote host`
    - `Specfy username`
    - `password`, 直接輸入即可,console不會顯示。

## Install docker

   - [tutorial](https://medium.com/@grady1006/ubuntu18-04%E5%AE%89%E8%A3%9Ddocker%E5%92%8Cnvidia-docker-%E4%BD%BF%E7%94%A8%E5%A4%96%E6%8E%A5%E9%A1%AF%E5%8D%A1-1e3c404c517d)

## Volume(shared folder)

- 在`docker run`指令中加入參數`-v host_folder`:`/container_folder`
    - `host_folder` : 在主機的資料夾
    - `/container_folder` : 在container中的資料夾

## Docker for windows

- `... run -v ...` : 使用volume前要先到`setting/Resources/FILE SHARING`指定根目之後用相對路徑即可`
    - 設定 `C:\Users\tseng\Desktop\dockerhub`
    - 指令使用 `-v /data:/root` 即可綁定 `C:\Users\tseng\Desktop\dockerhub\ocr`
- `docker run --name ocr -v /ocr:/root -it ubuntu:16.04 bash`

## Container

- `docker ps` : 列出正在使用的container
- `docker pull <NAME>` : 從[dockerhub](https://hub.docker.com/)下載映像檔
    ```
    docker pull ubuntu:16.04
    ```
- `nvidia-smi` : 查看顯卡使用狀況
- `nvidia-docker run --name YOLO --mount source=openpose-train,target=/root -e NVIDIA_VISIBLE_DEVICES=2,3 -dt tensorflow/tensorflow:1.14.0-gpu`: 安裝 docker container
    - `--name YOLO`：container名字
    - `--mount source=openpose-train,target=/root`:掛載volume`openpose-train`到container的`/root`
    - `-e NVIDIA_VISIBLE_DEVICES=2,3`：要使用哪張顯卡,也可使用使用`--gpus all`
    - `-dt tensorflow/tensorflow:latest-gpu-py3` : 要裝的pull的映像檔

- `nvidia-docker start <NAME>` : 打開container
- `docker stop <NAME>` : 關掉container
- `docker exec -it <NAME> bash` : 進入環境
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

## Edit file with vim

- `apt-get update`
- `apt-get install vim`

- 結束編輯`:x + Enter`
- 切換到插入模式 : `i` , `Esc`結束

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

- 上傳到dockerhub
    ```
    docker tag docker101tutorial tsengyushiang/docker/docker101tutorial
    docker push docker101tutorial tsengyushiang/docker/docker101tutorial
    ```