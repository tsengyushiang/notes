## ST-Nerf

### Reference

- [ST-Nerf](https://github.com/DarlingHang/st-nerf)

### Docker 

```
docker run -ti --runtime=nvidia --name st-nerf2 -v /raid/dgx_user1/st-nerf:/root -p 2222:22 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=1,2 -dt pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

docker start st-nerf-cuda1

docker exec -it st-nerf-cuda1 bash
```

### Anaconda

```
apt update
apt-get install wget
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
bash Anaconda3–4.4.0-Linux-x86_64.sh
export PATH='~/anaconda3/bin:$PATH'
source ~/.bashrc
conda update conda

dgx_user1@DGX-Station:/raid/dgx_user1/st-nerf$ conda info

     active environment : None
       user config file : /home/dgx_user1/.condarc
 populated config files :
          conda version : 4.10.3
    ...
```

### Conda Env

```
conda create -n st-nerf python=3.8.5
conda activate st-nerf    
conda install pytorch==1.7.1 torchvision==0.8.2 torchaudio==0.7.2 cudatoolkit=11.0 -c pytorch
conda install imageio matplotlib
pip install yacs kornia robpy

pip install open3d
apt update
apt-get install ffmpeg libsm6 libxext6  -y

pip install pyrender
apt-get install freeglut3-dev

pip install robopy
pip install PyOpenGL-accelerate

apt-get install vtk6
pip install mayavi

pip install imageio_ffmpeg
```
