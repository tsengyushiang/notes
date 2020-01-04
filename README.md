## Install ubuntu

* [tutorial1](https://blog.xuite.net/yh96301/blog/341994889-%E5%AE%89%E8%A3%9DUbuntu+18.04) ,  [tutorial2](https://www.itread01.com/content/1546486745.html)

*  Download .ISO from [ubuntu-tw.org](http://www.ubuntu-tw.org/modules/tinyd0/)

* make install disk with [Rufus](https://rufus.ie/)

* distribute departures 

   | 掛載點  |  分區 |  空間大小(MB) |　作用　|　  
   | ------------- | ------------- | ------------- | ------------- | 
   | /  | 主分割槽  |10GB ~ 15GB |  儲存系統檔案|  
   | swap  | 邏輯分割槽  |實體記憶體的2倍 |  虛擬記憶體|  
   | /boot  |邏輯分割槽  | 200M |  系統啟動| 
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

## System Error 

* Ubuntu 18.04 LTS _Bionic Beaver_ - Release amd64 (20180426)' in the drive
   '/media/cdrom/' and press [Enter] 
   
   use  command `software-properties-gtk` to open window and *disable installable from CD-ROM/DVD* 
   