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