# Detectron2

### Reference

- [Detectron2](https://github.com/facebookresearch/detectron2)
- [tutorial video](https://www.youtube.com/watch?v=Pb3opEFP94U)

### Win10 setup 

```
conda create -n detectron python=3.8
conda activate detectron

conda install pytorch torchvision torchaudio cudatoolkit=11.0 -c pytorch
pip install cython

D:

git clone https://github.com/facebookresearch/detectron2.git

cd detectron2
pip install -e .
pip install opencv-python
```

### Error

- `ImportError: DLL load failed while importing win32file: 找不到指定的程序。`
    ```
    conda install pywin32
    ```

## Demo code

```
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2.data import MetadataCatalog
from detectron2.utils.visualizer import ColorMode, Visualizer
from detectron2 import model_zoo

import detectron2
from detectron2.projects import point_rend

import cv2
import numpy as np

class Detector:

    def __init__(self,model_type):
        self.cfg = get_cfg()

        #Load model config and pretrained model
        if model_type=="mask_rcnn":
            self.cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))
            self.cfg.MODEL.WEIGHTS=model_zoo.get_checkpoint_url("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
        elif model_type=="pointrend":
            point_rend.add_pointrend_config(self.cfg)

            # find yaml where you clone detecton2 from git
            self.cfg.merge_from_file(r"D:\projects\detectron2\projects\PointRend\configs\InstanceSegmentation\pointrend_rcnn_R_50_FPN_3x_coco.yaml")
            # copy from right clik PretrainedModels/InstanceSegmentation/COCO/download hyperlink : model
            self.cfg.MODEL.WEIGHTS = "detectron2://PointRend/InstanceSegmentation/pointrend_rcnn_R_50_FPN_3x_coco/164955410/model_final_edd263.pkl"

        self.cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST=0.7
        self.cfg.MODEL.DEVICE="cpu" #cpu or cuda       

        self.predictor = DefaultPredictor(self.cfg)
    
    def cropper(self,img, mask_array,class_array,class_dict,mask=[]):
        num_instances = mask_array.shape[0]
        mask_array = np.moveaxis(mask_array, 0, -1)
        output = np.zeros_like(img)
        for i in range(num_instances):            
            if class_dict[class_array[i]] in mask:
                output = np.where(mask_array[:, :, i:(i+1)] == True, 255, output)
        return output

    def onImage(self,imagePath):
        image=cv2.imread(imagePath)
        predictions = self.predictor(image)

        catalog = MetadataCatalog.get(self.cfg.DATASETS.TRAIN[0])
        vis = Visualizer(image[:,:,::-1],metadata=catalog,scale=1.2)

        output =vis.draw_instance_predictions(predictions["instances"].to("cpu"))
        labeledImg = output.get_image()[:, :, ::-1]

        print('possible class :',catalog.thing_classes)
        mask = self.cropper(
            image,
            predictions["instances"].pred_masks.numpy(),
            predictions["instances"].pred_classes.numpy(),
            catalog.thing_classes,
            ["person"]
        )

        cv2.namedWindow("Result", cv2.WINDOW_NORMAL)    # Create window with freedom of dimensions
        cv2.imshow("Result",mask)
        cv2.waitKey(0)


dectector = Detector(model_type="pointrend")

dectector.onImage(r"C:\Users\yushiang\Downloads\pedestrian.jpg")
```