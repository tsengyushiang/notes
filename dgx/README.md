## Login

- Tool : [MobaXterm](https://mobaxterm.mobatek.net/download-home-edition.html) 

- `Session/SSH` :
    - `Remote host`
    - `Specfy username`
    - `password`, 直接輸入即可,console不會顯示。
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
    - `-e NVIDIA_VISIBLE_DEVICES=2,3`：要使用哪張顯卡
    - `-dt tensorflow/tensorflow:latest-gpu-py3` : 要裝的pull的映像檔

- `nvidia-docker start <NAME>` : 打開container
- `docker stop <NAME>` : 關掉container
- `docker exec -it <NAME> bash` : 進入環境
- `exit` : 退出環境
- `docker cp <from> <to>` :將檔案/資料夾傳入傳出container
    - `<container-name>:/<path in container>` : `openpose-M10815098:/openpose`
    - `<host path>` : `/home/dgx_user1/Desktop`
- `docker container rm <container id>` : 用`docker container ls -a`找到要移除的`<container id>`,記得先關掉


## Edit file with vim

- `apt-get update`
- `apt-get install vim`

- 結束編輯`:x + Enter`
- 切換到插入模式 : `i` , `Esc`結束

## Openpose_train

- `docker pull exsidius/openpose`

- `nvidia-docker run --name openpose-train-volume -v /home/dgx_user1/Desktop/openpose-tarin-M10815098:/root -e NVIDIA_VISIBLE_DEVICES=0,1,2,3 -dt exsidius/openpose`

- `nvidia-docker start openpose-train-volume`
- `docker exec -it openpose-train-volume bash`

- 下載[openpose_caffe_train](https://github.com/CMU-Perceptual-Computing-Lab/openpose_caffe_train)
    - 重新命名 : `mv Makefile.config.example Makefile.config`
    - 安裝 : `make all -j{num_cores} && make pycaffe -j{num_cores}`,可用`nproc`查`{num_cores}`
    - `hdf5.h` : 
        - `apt install libhdf5-dev`
        - `find / -name hdf5.h`
            ```
            /usr/include/opencv2/flann/hdf5.h
            /usr/include/hdf5/serial/hdf5.h
            ```
        - 修改 `Makefile.config`
            ```
            INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
            LIBRARY_DIRS := $(PYTHON_LIB) /usr/lib/x86_64-linux-gnu/hdf5/serial
            ```
    - `numpy/arrayobject.h`:
        - `apt-get install python-numpy`
    - ~~`lmdb.h`~~ :
        - `apt-get install liblmdb-dev`
    - ~~`leveldb/db.h`~~
        ```
        git clone --recurse-submodules https://github.com/google/leveldb.git
        mkdir -p build && cd build
        cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
        make
        cd ..
        cp -r include/leveldb /usr/local/include/
        ```
    - ~~`'accumulate' is not a member of 'std'` add header`#include <numeric>` to `src/caffe/openpose/layers/oPDataLayer.cpp` and `oPVideoLayer.cpp` as following~~
        ```
        #include <numeric>
        namespace caffe
        {
        ```
    - ~~`cannot find -l{name}`, 像是`/usr/bin/ld: cannot find -lsnappy`~~
        - `apt-cache search libsnappy`找到
            ```
            libsnappy-dev - fast compression/decompression library (development files)
            libsnappy1v5 - fast compression/decompression library
            libsnappy-java - Snappy for Java, a fast compressor/decompresser
            libsnappy-jni - Snappy for Java, a fast compressor/decompresser (JNI library)
            ```
        - 安裝 `apt-get install libsnappy-dev`
    - ~~`/usr/bin/ld: cannot find -lopencv_contrib`~~
        - `pkg-config --modversion opencv`

    - [~~其他caffe常見錯誤~~](https://github.com/BVLC/caffe/wiki/Commonly-encountered-build-issues) 


- 下載 [openpose_train](https://github.com/CMU-Perceptual-Computing-Lab/openpose_train/blob/master/training/README.md)

- LMDB : 
    - `openpose_train-master`中執行 `cd training && bash a_downloadAndUpzipLmdbs.sh`. 檢查 `dataset/` 中有多個` dataset/lmdb_X`檔名的檔案
    - `apt-get install wget`
        - windows下使用`git bash`,下載[wget zip](https://eternallybored.org/misc/wget/)將`wget.exe`移到`C:\Program Files\Git\mingw64\bin\`即可使用
    - download scripts folder: `cd training`
    - COCO : `bash a_lmdbGetBody.sh`
    - Foot / Face / Hand / Dome: `bash a_lmdbGetFace.sh; bash a_lmdbGetFoot.sh; bash a_lmdbGetHands.sh; bash a_lmdbGetDome.sh`
    - MPII:`bash a_lmdbGetMpii.sh`

- 下載 [cocoapi](https://github.com/gineshidalgo99/cocoapi) 放到`openpose_train-master/dataset/COCO/cocoapi`

- 到`/training`修改`d_setLayers.py.example`
    - `mv d_setLayers.py.example d_setLayers.py`
    - 修改參數
        ```
        sCaffeFolder =  '/root/openpose_caffe_train-master'
        
        sAddFoot = 1
        sAddMpii = 1
        sAddFace = 1
        sAddHands = 1
        sAddDome = 1

        sProbabilityOnlyBackground = 0.02

        sSuperModel = 0
        ```
    - `python d_setLayers.py`
        - `apt-get install python-skimage`
        - `apt-get install python-pip`
        - `pip install --upgrade pip`
        - `python -m pip install protobuf`

- 下載 [pretrained VGG-19 model](https://gist.github.com/ksimonyan/3785162f95cd2d5fee77), 放到 `dataset/vgg/` 命名為 `dataset/vgg/VGG_ILSVRC_19_layers.caffemodel` 和 `dataset/vgg/vgg_deploy.prototxt`

- 到 `training_results/pose/` 執行 `bash train_pose.sh 0,1,2,3`,0-3表示使用GPUs