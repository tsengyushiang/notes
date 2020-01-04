## C++ environment setting

- C++ compiler  
  `sudo apt-get install g++ build-essential`

* C++ compile with editor VScode  
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

* Run `.out` file : give execute permission
  `chmod +x ./a.out` and run program by typing `a.out`

## Coding style

- [tutorial](https://www.codepool.biz/vscode-format-c-code-windows-linux.html)

- install vscode plugin `clang-format`

- update packages  
  `sudo apt-get update`
- find package  
  `sudo apt-cache search clang-format` :

```
arcanist-clang-format-linter - clang-format linter for Arcanist
clang-format - Tool to format C/C++/Obj-C code
clang-format-3.9 - Tool to format C/C++/Obj-C code
clang-format-4.0 - Tool to format C/C++/Obj-C code
clang-format-5.0 - Tool to format C/C++/Obj-C code
clang-format-6.0 - Tool to format C/C++/Obj-C code
clang-format-7 - Tool to format C/C++/Obj-C code
clang-format-8 - Tool to format C/C++/Obj-C code
```

- install any version  
  `sudo apt-get install clang-format-4.0`

- find clang-format-4.0  
   `whereis clang-format-4.0`
- create a symlink  
   `sudo ln -s /usr/bin/clang-format-4.0 /usr/bin/clang-format`

- if not work properly add following setting in vscode `setting.json`
  ```
     "[cpp]": {
        "editor.formatOnSave": true
     }
  ```
