## OpenCV install

- [tutorial reference](https://linuxize.com/post/how-to-install-opencv-on-ubuntu-18-04/)

- Install the necessary packages
  ```
  sudo apt-get update
  sudo apt install build-essential cmake git pkg-config libgtk-3-dev
  sudo apt install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev
  sudo apt install libjpeg-dev libpng-dev libtiff-dev gfortran openexr libatlas-base-dev
  sudo apt install python3-dev python3-numpy libtbb2 libtbb-dev libdc1394-22-dev
  ```
- Cloning the OpenCV source code

  ```
  mkdir ~/opencv_build && cd ~/opencv_build
  git clone https://github.com/opencv/opencv.git
  git clone https://github.com/opencv/opencv_contrib.git
  ```

  install specific version `cd` to `opencv` and `opencv_contrib`directories and run `git checkout <opencv-version>`, such as `git checkout 3.4.1` and check git version/branch by `git show`

- configuring OpenCV with CMake

  create a temporary build directory

  ```
  cd ~/opencv_build/opencv
  mkdir build && cd build
  ```

  Set up the OpenCV build with CMake:

  ```
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules -D BUILD_EXAMPLES=ON -D BUILD_opencv_python3=yes ..
  ```

  - if get err:`does not appear to contain cmakelists.txt` , replace Last word `.` with `..` or `absolute path`
  - check `ffmepg` is `yes`,otherwise
    ```
    sudo apt-get install ffmpeg
    apt-get install libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev
    ```

- Compiling OpenCV

  Modify the `-j` flag according to your processor. If you do not know the number of cores your processor you can find it by `nproc`. My system has 8 cores, so I am using the `-j8` flag.

  ```
  make -j8
  ```

  if get err:`Makefile:160: recipe for target 'all' failed make: ***` run without argument `-j8`

- Installing OpenCV

  ```
  sudo make install
  ```

- Verifying OpenCV installation

  ```
  pkg-config --modversion opencv
  ```

- Run with CMakeLists.txt

  - CMakeLists.txt build executable `main`

  ```
  cmake_minimum_required(VERSION 2.8)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
  project( main )
  find_package( OpenCV 3.4.1 REQUIRED )
  add_executable( main main.cpp )
  target_link_libraries( main ${OpenCV_LIBS} )
  ```

  - command

  ```
  cmake .
  make
  ./main
  ```

- Build .so(dynamic library) and use in python

  - CMakeLists.txt :

  ```
  cmake_minimum_required(VERSION 2.8)
  set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
  project( main )
  find_package( OpenCV 3.4.1 REQUIRED )
  ADD_LIBRARY(_name SHARED lib.cpp)
  target_link_libraries( _name ${OpenCV_LIBS} )
  ```

  - python code :

  ```
  from ctypes import cdll
  import json

  lib = cdll.LoadLibrary('./lib_name.so')
  lib.func(args)
  
  #use 'helloworld'.encode('ascii') instead of 'helloworld' to pass argment in python3, or it will pass only the first letter
  ```

## OpenCL

- install `beignet1.3`, use .deb in folder `/deb`, use following command

```
# remove existed version
sudo apt-get remove beignet
sudo apt purge beignet
sudo apt-get remove beignet-opencl-icd
sudo apt purge beignet-opencl-icd

# install from .deb
sudo dpkg -i beignet-opencl-icd_1.3.0-4_amd64.deb
sudo dpkg -i beignet_1.3.0-4_amd64.deb
```

- use `clinfo` to get available

```
Number of platforms                               1
  Platform Name                                   Intel Gen OCL Driver
  Platform Vendor                                 Intel
  Platform Version                                OpenCL 2.0 beignet 1.3
  Platform Profile                                FULL_PROFILE
  Platform Extensions                             cl_khr_global_int32_base_atomics cl_khr_global_int32_extended_atomics cl_khr_local_int32_base_atomics cl_khr_local_int32_extended_atomics cl_khr_byte_addressable_store cl_khr_3d_image_writes cl_khr_image2d_from_buffer cl_khr_depth_images cl_khr_spir cl_khr_icd cl_intel_accelerator cl_intel_subgroups cl_intel_subgroups_short
  Platform Extensions function suffix             Intel

  Platform Name                                   Intel Gen OCL Driver
Number of devices                                 1
  Device Name                                     Intel(R) HD Graphics Broxton 0
  Device Vendor                                   Intel
  Device Vendor ID                                0x8086
  Device Version                                  OpenCL 2.0 beignet 1.3
  Driver Version                                  1.3
  Device OpenCL C Version                         OpenCL C 2.0 beignet 1.3
  Device Type                                     GPU
  Device Profile                                  FULL_PROFILE
  Max compute units                               18
  Max clock frequency                             1000MHz
  Device Partition                                (core)
    Max number of sub-devices                     1
    Supported partition types                     None, None, None
  Max work item dimensions                        3
  Max work item sizes                             512x512x512
  Max work group size                             512
  Preferred work group size multiple              16
  Preferred / native vector sizes
    char                                                16 / 8
    short                                                8 / 8
    int                                                  4 / 4
    long                                                 2 / 2
    half                                                 0 / 8        (cl_khr_fp16)
    float                                                4 / 4
    double                                               0 / 2        (n/a)
  Half-precision Floating-point support           (cl_khr_fp16)
    Denormals                                     No
    Infinity and NANs                             Yes
    Round to nearest                              Yes
    Round to zero                                 No
    Round to infinity                             No
    IEEE754-2008 fused multiply-add               No
    Support is emulated in software               No
    Correctly-rounded divide and sqrt operations  No
  Single-precision Floating-point support         (core)
    Denormals                                     No
    Infinity and NANs                             Yes
    Round to nearest                              Yes
    Round to zero                                 No
    Round to infinity                             No
    IEEE754-2008 fused multiply-add               No
    Support is emulated in software               No
    Correctly-rounded divide and sqrt operations  No
  Double-precision Floating-point support         (n/a)
  Address bits                                    64, Little-Endian
  Global memory size                              1987051520 (1.851GiB)
  Error Correction support                        No
  Max memory allocation                           1490026496 (1.388GiB)
  Unified memory for Host and Device              Yes
  Shared Virtual Memory (SVM) capabilities        (core)
    Coarse-grained buffer sharing                 Yes
    Fine-grained buffer sharing                   No
    Fine-grained system sharing                   No
    Atomics                                       No
  Minimum alignment for any data type             128 bytes
  Alignment of base address                       1024 bits (128 bytes)
  Preferred alignment for atomics
    SVM                                           0 bytes
    Global                                        0 bytes
    Local                                         0 bytes
  Max size for global variable                    65536 (64KiB)
  Preferred total size of global vars             65536 (64KiB)
  Global Memory cache type                        Read/Write
  Global Memory cache size                        8192
  Global Memory cache line                        64 bytes
  Image support                                   Yes
    Max number of samplers per kernel             16
    Max size for 1D images from buffer            65536 pixels
    Max 1D or 2D image array size                 2048 images
    Base address alignment for 2D image buffers   4096 bytes
    Pitch alignment for 2D image buffers          1 bytes
    Max 2D image size                             8192x8192 pixels
    Max 3D image size                             8192x8192x2048 pixels
    Max number of read image args                 128
    Max number of write image args                8
    Max number of read/write image args           8
  Max number of pipe args                         16
  Max active pipe reservations                    1
  Max pipe packet size                            1024
  Local memory type                               Global
  Local memory size                               65536 (64KiB)
  Max constant buffer size                        134217728 (128MiB)
  Max number of constant args                     8
  Max size of kernel argument                     1024
  Queue properties (on host)
    Out-of-order execution                        No
    Profiling                                     Yes
  Queue properties (on device)
    Out-of-order execution                        Yes
    Profiling                                     Yes
    Preferred size                                16384 (16KiB)
    Max size                                      262144 (256KiB)
  Max queues on device                            1
  Max events on device                            1024
  Prefer user sync for interop                    Yes
  Profiling timer resolution                      80ns
  Execution capabilities
    Run OpenCL kernels                            Yes
    Run native kernels                            Yes
    SPIR versions                                 1.2
  printf() buffer size                            1048576 (1024KiB)
  Built-in kernels                                __cl_copy_region_align4;__cl_copy_region_align16;__cl_cpy_region_unalign_same_offset;__cl_copy_region_unalign_dst_offset;__cl_copy_region_unalign_src_offset;__cl_copy_buffer_rect;__cl_copy_image_1d_to_1d;__cl_copy_image_2d_to_2d;__cl_copy_image_3d_to_2d;__cl_copy_image_2d_to_3d;__cl_copy_image_3d_to_3d;__cl_copy_image_2d_to_buffer;__cl_copy_image_3d_to_buffer;__cl_copy_buffer_to_image_2d;__cl_copy_buffer_to_image_3d;__cl_fill_region_unalign;__cl_fill_region_align2;__cl_fill_region_align4;__cl_fill_region_align8_2;__cl_fill_region_align8_4;__cl_fill_region_align8_8;__cl_fill_region_align8_16;__cl_fill_region_align128;__cl_fill_image_1d;__cl_fill_image_1d_array;__cl_fill_image_2d;__cl_fill_image_2d_array;__cl_fill_image_3d;
  Device Available                                Yes
  Compiler Available                              Yes
  Linker Available                                Yes
  Device Extensions                               cl_khr_global_int32_base_atomics cl_khr_global_int32_extended_atomics cl_khr_local_int32_base_atomics cl_khr_local_int32_extended_atomics cl_khr_byte_addressable_store cl_khr_3d_image_writes cl_khr_image2d_from_buffer cl_khr_depth_images cl_khr_spir cl_khr_icd cl_intel_accelerator cl_intel_subgroups cl_intel_subgroups_short cl_khr_fp16

NULL platform behavior
  clGetPlatformInfo(NULL, CL_PLATFORM_NAME, ...)  Intel Gen OCL Driver
  clGetDeviceIDs(NULL, CL_DEVICE_TYPE_ALL, ...)   Success [Intel]
  clCreateContext(NULL, ...) [default]            Success [Intel]
  clCreateContextFromType(NULL, CL_DEVICE_TYPE_CPU)  Success (1)
    Platform Name                                 Intel Gen OCL Driver
    Device Name                                   Intel(R) HD Graphics Broxton 0
  clCreateContextFromType(NULL, CL_DEVICE_TYPE_GPU)  Success (1)
    Platform Name                                 Intel Gen OCL Driver
    Device Name                                   Intel(R) HD Graphics Broxton 0
  clCreateContextFromType(NULL, CL_DEVICE_TYPE_ACCELERATOR)  Success (1)
    Platform Name                                 Intel Gen OCL Driver
    Device Name                                   Intel(R) HD Graphics Broxton 0
  clCreateContextFromType(NULL, CL_DEVICE_TYPE_CUSTOM)  Success (1)
    Platform Name                                 Intel Gen OCL Driver
    Device Name                                   Intel(R) HD Graphics Broxton 0
  clCreateContextFromType(NULL, CL_DEVICE_TYPE_ALL)  Success (1)
    Platform Name                                 Intel Gen OCL Driver
    Device Name                                   Intel(R) HD Graphics Broxton 0

ICD loader properties
  ICD loader Name                                 OpenCL ICD Loader
  ICD loader Vendor                               OCL Icd free software
  ICD loader Version                              2.2.8
  ICD loader Profile                              OpenCL 1.2
	NOTE:	your OpenCL library declares to support OpenCL 1.2,
		but it seems to support up to OpenCL 2.1 too.

```

- run sample code in `/openCL sample code`

```
Platform Name: Intel Gen OCL Driver
 GPU device
Without opencl umat 	 with opencl umat	 with opencl mat 	 without opencl mat for cvtColor(0),Blur(1),Canny(2)
getNumberOfCPUs =4	 getNumThreads = 4
cvtColor = (3.21349 +/-0.567536)false		(0.342036 +/-0.499697)true		(2.22043 +/-0.459774)false		(1.31083 +/-0.338563true
gaussianblur = (79.2918 +/-13.6697)false		(63.0626 +/-9.87501)true		(73.6913 +/-9.98689)false		(70.0938 +/-6.76619)true
Canny = (21.3214 +/-3.09806)false		(10.3678 +/-12.9219)true		(23.1271 +/-2.30336)false		(22.5169 +/-0.605387)true
1 GPU devices are detected.
4
```
