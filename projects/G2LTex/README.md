## Texture Mapping for 3D Reconstruction with RGB-D Sensor

### Reference

- [paper](https://openaccess.thecvf.com/content_cvpr_2018/papers/Fu_Texture_Mapping_for_CVPR_2018_paper.pdf)
- [code](https://github.com/fdp0525/G2LTex)

### docker installation instuction 

- `docker run -it --name G2LTex -v C:\user\where\to\share:/root ubuntu:16.04`
    
- setup environment

```
apt-get update

apt-get install -y libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine2 libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils python-numpy python-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev wget git libeigen3-dev unzip libcholmod3.0.6

wget http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.13/opencv-2.4.13.zip
unzip opencv-2.4.13.zip
cd opencv-2.4.13
mkdir release
cd release

cmake -G "Unix Makefiles" -DCMAKE_CXX_COMPILER=/usr/bin/g++ CMAKE_C_COMPILER=/usr/bin/gcc -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_TBB=ON -DBUILD_NEW_PYTHON_SUPPORT=ON -DWITH_V4L=ON -DINSTALL_C_EXAMPLES=ON -DINSTALL_PYTHON_EXAMPLES=ON -DBUILD_EXAMPLES=ON -DWITH_QT=ON -DWITH_OPENGL=ON -DBUILD_FAT_JAVA_LIB=ON -DINSTALL_TO_MANGLED_PATHS=ON -DINSTALL_CREATE_DISTRIB=ON -DINSTALL_TESTS=ON -DENABLE_FAST_MATH=ON -DWITH_IMAGEIO=ON -DBUILD_SHARED_LIBS=OFF -DWITH_GSTREAMER=ON ..

make all -j2
make install

apt-get -y install nodejs nodejs-legacy npm
npm i -g gnomon
```

- clone code and set lib path

```
git clone https://github.com/fdp0525/G2LTex.git
export LD_LIBRARY_PATH=/where/you/install/lib:$LD_LIBRARY_PATH
```

- Run code, result will be stored in `./bin`

```
cd G2LTex/bin
./G2LTex ../Data/bloster/textureimages ../Data/bloster/bloster.ply | gnomon
```

