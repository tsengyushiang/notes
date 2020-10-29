## Joint Texture and Geometry Optimization for RGB-D Reconstruction

### Reference

- [paper](https://yanqingan.github.io/docs/cvpr20_joint.pdf)
- [code](https://github.com/fdp0525/JointTG)

### docker installation instuction 

- `docker run -it --name JointTG -v C:\user\where\to\share:/root ubuntu:16.04`
    
- setup environment

[install opencv3.4](../../ubuntu/opencv)

```
apt-get update

apt-get install libboost-all-dev
wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz
tar -zxvf boost_1_65_1.tar.gz
cd boost_1_65_1
./bootstrap.sh –with-libraries=all
./b2 install 
./b2 cxxflags=-fPIC cflags=-fPIC --c++11

apt-get install libflann-dev
wget https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz
tar -xf 1.9.1.tar.gz
cd flann-1.9.1/
mkdir build
cd build
cmake ..
make
make install

apt install libomp-dev
```

- clone code and set lib path

```
git clone https://github.com/fdp0525/JointTG.git
export LD_LIBRARY_PATH=~/JointTG-master/lib:/usr/local/lib/:$LD_LIBRARY_PATH
rm ./lib/libJointTexGeo.so.1.0.0 libJointTexGeo.so.1

```

- Run code, result will be stored in `./bin`

```
cd JointTG/bin
./JointTG ./bricks/images/ ./bricks/bricks-fusion.ply ./bricks/traj.log
```

