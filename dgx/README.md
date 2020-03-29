## Login

- Tool : [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) 

- `Session/SSH` :
    - `Remote host`
    - `Specfy username`
    - `password`, 直接輸入即可,console不會顯示。

## Container

- `docker ps` : 列出正在使用的container
- `docker pull <NAME>` : 從[dockerhub](https://hub.docker.com/)下載映像檔
    ```
    docker pull tensorflow/tensorflow:latest-gpu-py3
    docker pull floydhub/pytorch: 1.0.0-gpu.cuda9cudnn7-py3.40
    ```
- `nvidia-smi` : 查看顯卡使用狀況
- `nvidia-docker run --name YOLO -e NVIDIA_VISIBLE_DEVICES=2,3 -dt tensorflow/tensorflow:1.14.0-gpu`: 安裝 docker container
    - `--name YOLO`：container名字
    - `-e NVIDIA_VISIBLE_DEVICES=2,3`：要使用哪張顯卡
    - `-dt tensorflow/tensorflow:latest-gpu-py3` : 要裝的pull的映像檔

- `nvidia-docker start <NAME>` : 打開container
- `docker stop <NAME>` : 關掉container
- `docker exec -it <NAME> bash` : 進入環境
- `exit` : 退出環境
- `docker cp <from> <to>` :將檔案/資料夾傳入傳出container
    - `<container-name>:/<path in container>` : `openpose-M10815098:/openpose`
    - `<host path>` : `/home/dgx_user1/Desktop`

## openpose

- `docker pull cwaffles/openpose`

- `nvidia-docker run --name openpose -e NVIDIA_VISIBLE_DEVICES=2,3 -dt cwaffles/openpose
`
- `nvidia-docker start openpose-M10815098`
- `docker exec -it openpose-M10815098 bash`