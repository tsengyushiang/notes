
## Command

- 管理開發環境
    - 列出現有環境 `conda env list`
    - 建立新環境並安裝套件 `conda create -n my_env_name pkg_name1 pkg_name2`
        - `opencv-openpose` :`conda create -n opencv-openpose python=3.8 opencv=4`
    - 進入新環境 `conda activate my_env_name`
    - 離開環境 `conda deactivate`
    - 刪除環境 `conda env remove -n my_env_name`
    - 儲存/載入環境
        - 儲存環境 `conda env export > environment.yaml`
        - 依據環境檔創建環境 `conda env create -f environment.yaml`


- 管理套件

    - 列出已安裝套件 `conda list`
    - 安裝套件 `conda install pkg_name1 pkg_name2`
    - 安裝套件指定版本 `conda install pkg_name=version_number`
    - 找尋套件 `conda search pkg_name`
    - 移除套件 `conda remove pkg_name`
    - 更新套件 `conda update pkg_name`
    - 更新所有套件 `conda update -all`
    - 清除安裝後下載的原始檔 `conda clean -tp`

- 在`GitBash`中啟用

    - `eval "$(conda shell.bash hook)"`

## Tutorial

- [Install on ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-anaconda-on-ubuntu-18-04-quickstart)

## Refernece

- [tutorial](https://medium.com/@raymonduchen/anaconda%E7%9A%84%E5%AE%89%E8%A3%9D%E8%88%87%E4%BD%BF%E7%94%A8-86d77c231417)
