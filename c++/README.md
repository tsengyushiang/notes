## C++  environment setting

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