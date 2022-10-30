# D-Nerf

### Reference

- [D-Nerf](https://github.com/albertpumarola/D-NeRF)

### Docker 

```
docker run -ti --runtime=nvidia --name DNerf -v /raid/dgx2_user3/DSNerf:/root -p 2222:22 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=1 -dt pytorch/pytorch:1.9.0-cuda10.2-cudnn7-devel

docker start DNerf

docker exec -it DNerf bash

```

### Anaconda

```
apt update -y
apt-get install wget -y
wget https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh
bash ./Anaconda3–4.4.0-Linux-x86_64.sh
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

### Anaconda

```
apt-get install libglib2.0-0
apt-get install freeglut3-dev

git clone https://github.com/albertpumarola/D-NeRF.git
cd D-NeRF
conda create -n dnerf python=3.6
conda activate dnerf
pip install -r requirements.txt
cd torchsearchsorted
pip install .
cd ..
```
### Jupyter notebook
```
pip install jupyter
jupyter notebook --ip 0.0.0.0 --port=22 --allow-root

http://140.118.175.96:2222/
```
