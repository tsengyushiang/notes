# Openpose-Depth Training

- [Openpose-Depth-Training github](https://github.com/fantasystarwd/Openpose-Depth-CaffeTraining)

- 下載 `Dockerfile`(/docker/standalone/gpu/Dockerfile)
    ```
    FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

    RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            git \
            wget \
            libatlas-base-dev \
            libboost-all-dev \
            libgflags-dev \
            libgoogle-glog-dev \
            libhdf5-serial-dev \
            libleveldb-dev \
            liblmdb-dev \
            libopencv-dev \
            libprotobuf-dev \
            libsnappy-dev \
            protobuf-compiler \
            python-dev \
            python-numpy \
            python-pip \
            python-scipy && \
        rm -rf /var/lib/apt/lists/*

    ENV CAFFE_ROOT=/opt/caffe
    WORKDIR $CAFFE_ROOT

    # FIXME: clone a specific git tag and use ARG instead of ENV once DockerHub supports this.
    ENV CLONE_TAG=master

    RUN git clone -b ${CLONE_TAG} --depth 1 https://github.com/fantasystarwd/Openpose-Depth-CaffeTraining.git . && \
        for req in $(cat python/requirements.txt) pydot; do pip install $req; done && \
        mkdir build && cd build && \
        cmake -DUSE_CUDNN=1 .. && \
        make -j"$(nproc)"

    ENV PYCAFFE_ROOT $CAFFE_ROOT/python
    ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
    ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
    RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig

    WORKDIR /workspace
    ```
- 把`Dockerfile`轉成image
    - `cd`到`Dockerfile`的目錄
    - `docker build -t openpose-depth . --no-cache`
    - 檢查image已下載 : `docker images`有顯示`openpose-depth`

- 安裝conatiner
    - `docker run --name openpose-depth-M108 -v /raid/dgx_user1/openpose-depth:/root -e NVIDIA_VISIBLE_DEVICES=2,3 -dt openpose-depth`

- 下載[dataset](https://drive.google.com/file/d/1XixBJBTWIex28TW0RR0vRZm6cqMYuYCL/view)放到`/opt/caffe/data/OpenposeDepth/data.mdb`

- 開始training :
    - 移到`caffe`目錄 : `cd `
    - `./build/tools/caffe train --solver=models/Openpose-Depth/pose_solver.prototxt`

- train完的models會在`models/Openpose-Depth/Result/
    `