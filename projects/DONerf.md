## DONerf

### Reference

- [DONerf](https://github.com/facebookresearch/DONERF)

### Docker 

```
docker run -ti --runtime=nvidia --name DONerf -v /raid/dgx_user1/st-nerf:/root -p 2222:22 -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=1,2 -dt pytorch/pytorch:1.7.1-cuda11.0-cudnn8-devel

docker start DONerf

docker exec -it DONerf bash
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

- [pytorch version](https://pytorch.org/)

```
conda create -n DONerf python=3.8.5
conda activate DONerf

pip3 install torch==1.8.2+cu111 torchvision==0.9.2+cu111 torchaudio===0.8.2 -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html

pip install numpy pandas matplotlib transforms3d opencv-python imageio imageio-ffmpeg configargparse pillow pyrtools ptflops tqdm
```
