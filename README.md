
## Applications

 * Google chrome 
 ```
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
```

* media player(.mp4)  
` sudo apt-get install ubuntu-restricted-extras
`
## Coding  environment setting

* C++ compiler  
`sudo apt-get install g++ build-essential
` 
- C++ compile with  editor VScode  
press `ctrl+shift+B` to add `task.json` with following content and run `ctrl+shift+B` to build. 
   ```
   {
      "version": "2.0.0",
      "tasks": [
         {
               "label": "debug",
               "type": "shell",
               "command": "",
               "args": ["g++","-g", "${relativeFile}", "-o","a.exe"]
         },
         {
               "label": "Compile and run",
               "type": "shell",
               "command": "",
               "args": [
                  "g++","-g", "${relativeFile}", "-o","${fileBasenameNoExtension}.out", "&&", "clear" , "&&" , "./${fileBasenameNoExtension}.out"
               ],
               "group": {
                  "kind": "build",
                  "isDefault": true  
               },
               "problemMatcher": {
                  "owner": "cpp",
                  "fileLocation": ["relative", "${workspaceRoot}"],
                  "pattern": {
                     "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
                     "file": 1,
                     "line": 2,
                     "column": 3,
                     "severity": 4,
                     "message": 5
                  }
               }
         },
         
      ]
   }
   ```


## System Command

* add file  
` touch  <fileName>`

## Error 

* Ubuntu 18.04 LTS _Bionic Beaver_ - Release amd64 (20180426)' in the drive
   '/media/cdrom/' and press [Enter] 
   
   use  command `software-properties-gtk` to open window and *disable installable from CD-ROM/DVD* 
   