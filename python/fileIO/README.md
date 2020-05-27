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

        def recusiveGetFile(PATH,ext):
            return [os.path.join(dp, f) for dp, dn, filenames in os.walk(PATH) for f in filenames if os.path.splitext(f)[1] == ext]

        ```
    - usage
        ```
        from os.path import isfile, isdir
        folders = getDirectory('./ppt',isdir)

        files = recusiveGetFile("./",".json")
        ```
- Json

    - source code 

        ```
        import json

        def readJson(fileName):
            with open(fileName, 'r',encoding="utf-8") as reader:
                jf = json.loads(reader.read())
            return jf
        
        def writeJSON(jsonf,jsonData):
            with open(jsonf, 'w+') as f:
                f.seek(0)
                # ascii for chinese 
                json.dump(jsonData, f,ensure_ascii=False)
                f.truncate()

        ```

    - usage
    
        ```
        joints = readJson('test.json')
        print(joints)
        writeJSON('save.json',joints)
        ```

