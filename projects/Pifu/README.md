## Pifu/PifuHD

### Reference

- [Pifu](https://shunsukesaito.github.io/PIFu/)
- [PifuHD](https://shunsukesaito.github.io/PIFuHD/)

### Windows demo installation instuction 

- Install [Anaconda](https://www.anaconda.com/products/individual) and add to PATH
    
- setup environment

    - `conda create —n pifu python`
    - `conda activate pifu`
    - `conda install pytorch torchvision` 
    - `cudatoolkit=10.1 -c pytorch`
    - `conda install pillow`
    - `conda install scikit-image`
    - `conda install tqdm`
    - `conda install -c menpo opencv`

    - `conda install -c conda-forge trimesh`
    - `conda install -c anaconda pyopengl`
    - `conda install -c conda-forge freeglut`
    - `conda install -c conda-forge ffmpeg`

- command line tool Gitbash

    - Download [wget.exe](https://eternallybored.org/misc/wget/) Place it into `Git\mingw64\bin`
    - use conda in Gitbash `eval "$(conda shell.bash hook)`

### Demo(see detail in github page)

- Pifu

    - download prtrained model `sh ./scripts/download_trained_model.sh
    `
    - run demo `sh ./scripts/test.sh`


- PifuHD

    - download prtrained model `sh ./scripts/download_trained_model.sh
    `
    - run demo `sh ./scripts/demo.sh`