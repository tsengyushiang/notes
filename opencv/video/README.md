## Opencv Videos

- Batch resize

    - source code 

        ```
        import os,json
        import cv2
        import numpy as np

        def resizeVideo(w, h, folder):
            targetfolder = folder+'_'+str(w)+'x'+str(h)
            for root, subdirs, files in os.walk(folder):
                for file in files:
                    cap = cv2.VideoCapture(root+'/'+file)
                    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
                    out = cv2.VideoWriter(targetfolder+'/'+file, fourcc, 30, (w, h))
                    print(targetfolder+'/'+file)
                    while True:
                        ret, frame = cap.read()
                        if ret == True:
                            b = cv2.resize(frame, (w, h), fx=0, fy=0,
                                        interpolation=cv2.INTER_CUBIC)
                            out.write(b)
                        else:
                            break

                    cap.release()
                    out.release()
                    cv2.destroyAllWindows()
        ```
    - usage
        `resizeVideo(1920, 1080, "./videos")`

- Convert to Image Sequence

    - source code 
        ```
        import os,json
        import cv2
        import numpy as np

        def video2imageSequence(videoPath,imageFolder,jsonf):
            if (not os.path.isdir(imageFolder)):
                os.mkdir(imageFolder)
            jsonData=[]        
            cap = cv2.VideoCapture(videoPath)
            index = 0
            while True:
                ret, frame = cap.read()
                if ret == True:
                cv2.imwrite(imageFolder + str(index)+'.jpg', frame)
                jsonData.append({
                    "image": str(index)+'.jpg',
                    "time": cap.get(cv2.CAP_PROP_POS_MSEC)
                    })
                index+=1
                else:
                    break

            with open(jsonf, 'w+') as f:
                f.seek(0)
                json.dump(jsonData, f)
                f.truncate()    
        ```
    - usage
    
        ```
        video2imageSequence('C:/Users/tseng/Desktop/testing/imageSequence/Animation-HD.mp4',\
        'C:/Users/tseng/Desktop/testing/imageSequence/images/',\
        'C:/Users/tseng/Desktop/testing/imageSequence/Animation-HD.time.json'\
        )
        ```