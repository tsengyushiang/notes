
## Login DGX

- Tool : [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) 

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

## Container

- `docker ps` : 列出正在使用的container
- `docker pull <NAME>` : 從[dockerhub](https://hub.docker.com/)下載映像檔
    ```
    docker pull tensorflow/tensorflow:latest-gpu-py3
    docker pull floydhub/pytorch: 1.0.0-gpu.cuda9cudnn7-py3.40
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
- `screen -r <id>` : `id`可從`screen -ls`找到 
- `screen -X -S <id>`: 關閉attached cmd