## OpenCV install

- [tutorial reference](https://linuxize.com/post/how-to-install-opencv-on-ubuntu-18-04/)

- Install the necessary packages
  ```
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
  cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules -D BUILD_EXAMPLES=ON .
  ```

- Compiling OpenCV

  Modify the `-j` flag according to your processor. If you do not know the number of cores your processor you can find it by `nproc`. My system has 8 cores, so I am using the `-j8` flag.

  ```
  make -j8
  ```

- Installing OpenCV

  ```
  sudo make install
  ```

- Verifying OpenCV installation

  ```
  pkg-config --modversion opencv
  ```

- Errors

  - opencv Unable to stop the stream: Inappropriate ioctl for device

    1. `sudo apt-get install ffmpeg`
    2. go " configuring OpenCV with CMake "
