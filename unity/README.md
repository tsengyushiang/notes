
## Unity

- Simulator camera system

    - camera.projection matrix

        - go `Project Settings/Project/Player/Other Settings/Rendering`
        - disable `Auto Graphics API for Windows`
        - add `OpenGLCore`

        - Get camera VP matrix 
        ```
        Matrix4x4 projectionMatrix = GL.GetGPUProjectionMatrix(camera.projectionMatrix, true);
        // Debug.Log(projectionMatrix.Equals(camera.projectionMatrix)); // return ture;
        cam.world2screenMat = projectionMatrix * cameras.worldToCameraMatrix;
        ```       