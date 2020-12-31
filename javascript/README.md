# Javascript

- packages:

    - [lodash](https://lodash.com/)

# THREE.JS

- [WebGL Hardware limitation](https://webglreport.com/)
- [Tips](https://discoverthreejs.com/tips-and-tricks/)
- `WebGLRenderer.logarithmicDepthBuffer` and `camera.near/far` may cause weird depthTest.
- Max TextureSize on mobile : 4096*4096
- when using `transparent` and `renderOrder` to clip something, they're parent must be the same
- sovle z-fighting by polygon offset
    ```
    const material = new THREE.Material({
        polygonOffset: true,
        polygonOffsetFactor: 1.0,
        polygonOffsetUnits: 4.0
    })
    ```

# JS/TS config

- import path 
    ```
    "compilerOptions": {
        "baseUrl": "./src"
    }
    ```