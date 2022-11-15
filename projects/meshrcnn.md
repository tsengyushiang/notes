# Mesh R-CNN

### Reference

- [paper](https://arxiv.org/pdf/1906.02739.pdf)
- [code](https://github.com/facebookresearch/meshrcnn)

### Installation with dockerfile 

- use `nvidia-smi` check nvidia drive [support cuda](https://docs.nvidia.com/deploy/cuda-compatibility/index.html#binary-compatibility__table-toolkit-driver)
- search [detectron2 pre-build](https://detectron2.readthedocs.io/tutorials/install.html) file which support your cuda version

- [Detectron2](https://github.com/facebookresearch/detectron2/tree/master/docker)

```
conda create -n meshrcnn python=3.6
conda install pytorch=1.4.0 torchvision cudatoolkit=10.0 -c pytorch
pip install git+https://github.com/philferriere/cocoapi.git#subdirectory=PythonAPI

python -m pip install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu100/torch1.4/index.html

conda install -c conda-forge -c fvcore fvcore
```
 
