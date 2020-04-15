## Nvidia driver

- 查看驅動程式狀態
   - 安裝`ubuntu-drivers-common`
      ```
      sudo apt update
      sudo apt install ubuntu-drivers-common
      ubuntu-drivers devices
      ```
   - 結果中挑選recommend的做安裝，此範例為`nvidia-driver-430` : 
      ```
      == /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
      modalias : pci:v000010DEd00001288sv0000174Bsd0000326Bbc03sc00i00
      vendor   : NVIDIA Corporation
      model    : GK208B [GeForce GT 720]
      driver   : nvidia-driver-410 - third-party free
      driver   : nvidia-driver-418 - third-party free
      driver   : nvidia-340 - distro non-free
      driver   : nvidia-driver-430 - third-party free recommended
      driver   : nvidia-driver-390 - third-party free
      driver   : nvidia-driver-415 - third-party free
      driver   : xserver-xorg-video-nouveau - distro free builtin
      ```
- 安裝驅動後`reboot`，用`lsmod|grep nvidia`確認安裝完成
   ```
   sudo apt install nvidia-driver-430 
   sudo reboot

   lsmod|grep nvidia
   
   //output will like:

   nvidia_uvm            798720  0
   nvidia_drm             45056  3
   nvidia_modeset       1093632  7 nvidia_drm
   nvidia              18194432  258 nvidia_uvm,nvidia_modeset
   drm_kms_helper        172032  1 nvidia_drm
   drm                   401408  6 drm_kms_helper,nvidia_drm
   ipmi_msghandler        53248  2 ipmi_devintf,nvidianvidia_uvm            798720  0
   nvidia_drm             45056  3
   nvidia_modeset       1093632  7 nvidia_drm
   nvidia              18194432  258 nvidia_uvm,nvidia_modeset
   drm_kms_helper        172032  1 nvidia_drm
   drm                   401408  6 drm_kms_helper,nvidia_drm
   ipmi_msghandler        53248  2 ipmi_devintf,nvidia
   ```

## CUDA

- 到[官網](https://developer.nvidia.com/cuda-downloads)選擇系統，複製下方command進行安裝
![Alt text](/cuda.png)
   ```
   wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
   sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
   wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
   sudo dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb
   sudo apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub
   sudo apt-get update
   sudo apt-get -y install cuda
   ```
- 安裝完後`reboot`，編譯範例程式確認安裝成功
   ```
   sudo reboot

   cd /usr/local/cuda-10.1/samples/1_Utilities/deviceQuery
   sudo make
   ./deviceQuery 

   //output will like:

   ./deviceQuery Starting...

   CUDA Device Query (Runtime API) version (CUDART static linking)

   Detected 1 CUDA Capable device(s)

   Device 0: "GeForce GT 720"
   CUDA Driver Version / Runtime Version          10.1 / 10.1
   CUDA Capability Major/Minor version number:    3.5
   Total amount of global memory:                 1996 MBytes (2093416448 bytes)
   ( 1) Multiprocessors, (192) CUDA Cores/MP:     192 CUDA Cores
   GPU Max Clock rate:                            797 MHz (0.80 GHz)
   Memory Clock rate:                             900 Mhz
   Memory Bus Width:                              64-bit
   L2 Cache Size:                                 524288 bytes
   Maximum Texture Dimension Size (x,y,z)         1D=(65536), 2D=(65536, 65536), 3D=(4096, 4096, 4096)
   Maximum Layered 1D Texture Size, (num) layers  1D=(16384), 2048 layers
   Maximum Layered 2D Texture Size, (num) layers  2D=(16384, 16384), 2048 layers
   Total amount of constant memory:               65536 bytes
   Total amount of shared memory per block:       49152 bytes
   Total number of registers available per block: 65536
   Warp size:                                     32
   Maximum number of threads per multiprocessor:  2048
   Maximum number of threads per block:           1024
   Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
   Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
   Maximum memory pitch:                          2147483647 bytes
   Texture alignment:                             512 bytes
   Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
   Run time limit on kernels:                     Yes
   Integrated GPU sharing Host Memory:            No
   Support host page-locked memory mapping:       Yes
   Alignment requirement for Surfaces:            Yes
   Device has ECC support:                        Disabled
   Device supports Unified Addressing (UVA):      Yes
   Device supports Compute Preemption:            No
   Supports Cooperative Kernel Launch:            No
   Supports MultiDevice Co-op Kernel Launch:      No
   Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
   Compute Mode:
      < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

   deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.1, CUDA Runtime Version = 10.1, NumDevs = 1
   Result = PASS
   ```

## Reference

   - [nvidia 環境安裝](https://gitpress.io/@chchang/install-nvidia-driver-cuda-pgstrom-in-ubuntu-1804)
