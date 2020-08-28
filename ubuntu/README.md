## WSL(windows subsystem linux)

- 系統管理員執行`powershell`, 執行以下指令後重新開機
```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

wsl --set-default-version 2
```
- 檢查版本`4.19.121+`,若比此版本低到windows開發者channel進行更新
   `wsl cat /proc/version`

- 到microsoft store安裝`ubuntu`
   - [Ubuntu 16.04 LTS](https://www.microsoft.com/zh-tw/p/ubuntu-1604-lts/9pjn388hp8c9?rtc=1#activetab=pivot:overviewtab)
   - [Ubuntu 18.04 LTS](https://www.microsoft.com/zh-tw/p/ubuntu-1804-lts/9n9tngvndl3q?rtc=1&activetab=pivot:overviewtab)
   - [Ubuntu 20.04 LTS](https://www.microsoft.com/zh-tw/p/ubuntu-2004-lts/9n6svws3rx71?rtc=1&activetab=pivot:overviewtab)

- 安裝[cuda on WSL](https://developer.nvidia.com/cuda/wsl)

- 參考 : [WSL安裝](https://docs.microsoft.com/zh-tw/windows/wsl/install-win10), [CUDA安裝](https://docs.nvidia.com/cuda/wsl-user-guide/index.html)

## Install ubuntu

* [tutorial1](https://blog.xuite.net/yh96301/blog/341994889-%E5%AE%89%E8%A3%9DUbuntu+18.04) ,  [tutorial2](https://www.itread01.com/content/1546486745.html)

*  Download .ISO from [ubuntu-tw.org](http://www.ubuntu-tw.org/modules/tinyd0/)

* make install disk with [Rufus](https://rufus.ie/)

* distribute departures 

   | 掛載點  |  分區 |  空間大小(MB) | 作用 |
   | ------------- | ------------- | ------------- | ------------- |
   | /  | 主分割槽  |10GB ~ 15GB |  儲存系統檔案 |
   | swap  | 邏輯分割槽  |實體記憶體的2倍 | 虛擬記憶體 |
   | /boot  |邏輯分割槽  | 200M | 系統啟動 |
   | /home  | 邏輯分割槽  | 所有剩下 | home目錄 |

* 安裝開機程式於`/boot` 


## Applications

 * Google chrome 
   ```
   wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
   sudo dpkg -i google-chrome-stable_current_amd64.deb
   ```

* media player(.mp4)  
` sudo apt-get install ubuntu-restricted-extras
`

## System Command

* add file  
` touch  <fileName>`
* search file 
`find <dir> -name <fileName>`

## System Error 

* Ubuntu 18.04 LTS _Bionic Beaver_ - Release amd64 (20180426)' in the drive
   '/media/cdrom/' and press [Enter] 
   
   use  command `software-properties-gtk` to open window and *disable installable from CD-ROM/DVD* 
   
