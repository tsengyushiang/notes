## File I/O

- Get directories or files

    - source code 

        ```
        # -*- coding: utf-8 -*-
        from os import listdir
        from os.path import join

        def getDirectory(mypath,filter):

            # 取得所有檔案與子目錄名稱
            files = listdir(mypath)
            files_or_dirs = []

            # 以迴圈處理
            for f in files:
                # 產生檔案的絕對路徑
                fullpath = join(mypath, f)
                # 判斷 fullpath 是檔案還是目錄
                if filter(fullpath):
                    files_or_dirs.append(fullpath)
                    
            return files_or_dirs

        ```
    - usage
        ```
        from os.path import isfile, isdir
        folders = getDirectory('./ppt',isdir)
        ```
- Json

    - source code 

        ```
        import json

        def readJson(fileName):
            with open(fileName, 'r') as reader:
                jf = json.loads(reader.read())
            return jf 
        ```

    - usage
    
        ```
        joints = readJson('test.json')
        print(joints)
        ```

