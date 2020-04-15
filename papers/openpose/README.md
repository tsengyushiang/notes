## Reference

- [openpose](https://github.com/CMU-Perceptual-Computing-Lab/openpose)

- [openpose_train](https://github.com/CMU-Perceptual-Computing-Lab/openpose_train)

- [OpenPose Caffe Training](https://github.com/CMU-Perceptual-Computing-Lab/openpose_caffe_train)

- [OpenPose - Quick Start](https://github.com/CMU-Perceptual-Computing-Lab/openpose/blob/master/doc/quick_start.md)

- [Experimental Models](https://github.com/CMU-Perceptual-Computing-Lab/openpose_train/tree/master/experimental_models#body-25b-model-option-1-maximum-accuracy-less-speed)

## Train

- `docker pull exsidius/openpose`

- `nvidia-docker run --name openpose-train-volume -v /home/dgx_user1/Desktop/openpose-tarin-M10815098:/root -e NVIDIA_VISIBLE_DEVICES=0,1,2,3 -dt exsidius/openpose`

- `nvidia-docker start openpose-train-volume`
- `docker exec -it openpose-train-volume bash`

- 下載[openpose_caffe_train](https://github.com/CMU-Perceptual-Computing-Lab/openpose_caffe_train)
    - 重新命名 : `mv Makefile.config.example Makefile.config`
    - 安裝 : `make all -j{num_cores} && make pycaffe -j{num_cores}`,可用`nproc`查`{num_cores}`
    - 錯誤 :
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
        - 預設的`d_setLayers.py`會得到 model `BODY_25B`
    - `python d_setLayers.py`
        - `apt-get install python-skimage`
        - `apt-get install python-pip`
        - `pip install --upgrade pip`
        - `python -m pip install protobuf`

- 下載 [pretrained VGG-19 model](https://gist.github.com/ksimonyan/3785162f95cd2d5fee77), 放到 `dataset/vgg/` 命名為 `dataset/vgg/VGG_ILSVRC_19_layers.caffemodel` 和 `dataset/vgg/vgg_deploy.prototxt`

- 到 `training_results/pose/` 執行 `bash train_pose.sh 0,1,2,3`,0-3表示使用GPUs
    - 報錯`cudasuccess (2 vs. 0) out of memory`:
        - 修改`d_setLayers.py`中`batch size`
            ```
            if sSuperModel == 2:
                sLearningRateInit /= 2.5
                sBatchSizes = [3]
            else:
                sBatchSizes = [4] # [10], Gines: 21 <--此處原本是10
            ```
    - 修改 `resume_train_pose.sh`中的`--snapshot`路徑resume training
        ```
        #!/usr/bin/env sh
        /root/openpose_caffe_train-master/build/tools/caffe train \
        --solver=pose_solver.prototxt \
        --gpu=$1 --snapshot=model/pose_iter_88000.solverstate \
        2>&1 | tee ./resumed_training_log.txt
        ```
        
## Test BODY_25B

 - [Windows Portable Demo](https://github.com/CMU-Perceptual-Computing-Lab/openpose/releases)
    - 選用`openpose-1.5.1-binaries-win64-gpu-python-flir-3d_recommended.zip`測試`BODY_25B`的model

    - 創新資料夾`\models\pose\body_25b`並放置檔案
        - `pose_deploy.prototxt` 
            - [下載](https://github.com/CMU-Perceptual-Computing-Lab/openpose_train/tree/master/experimental_models/1_25BSuperModel11FullVGG/body_25b),或從`openpose_train\training_result\pose\`複製
        - `pose_iter_100000.caffemodel`並重新命名為`pose_iter_XXXXXX.caffemodel`
            - [下載](posefs1.perception.cs.cmu.edu/OpenPose/models/pose/1_25BSuperModel11FullVGG/body_25b/pose_iter_XXXXXX.caffemodel),或從`openpose_train\training_result\pose\model\`複製
    - `bin\OpenPoseDemo.exe --image_dir examples\media\ --model_pose BODY_25B --net_resolution -1x480`