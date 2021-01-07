# Javascript

- packages:

    - [lodash](https://lodash.com/)
    - [animejs](https://animejs.com/)

- Vanilla Js:

    - Object :

        - merge object to another, usefull when inherent getter

            ```
            public get targetInfo(): RaycastInfo
            {
                return {
                    type: RaycastType.SHOWMODAL | RaycastType.MOVE,
                    id: EObjectType.MODEL,
                    url: this.openLink,
                    ...super[ 'targetInfo' ]
                }
            }
            ```
        
        - beatify JSON : `JSON.stringify(jsObj, null, 4);`

    - [Request](https://developer.mozilla.org/zh-TW/docs/Web/API/Fetch_API/Using_Fetch)

        ```
        fetch('http://example.com/movies.json').then(function(response) {
            return response.json();
        }).then(function(myJson) {
            console.log(myJson);
        });
        ```

    - bitwise tag :
        ```
        export class Property
        {
            static SHOWMODAL = 0b0001;
            static EDIT = 0b0010;
            static checkProperty( value: number, type: number )
            {
                return ( value & type ) === type
            }
        }
        ```

# [Three.js](https://threejs.org/)

- [WebGL Hardware limitation](https://webglreport.com/), [Tips](https://discoverthreejs.com/tips-and-tricks/)

- Render(scene,renderer,camera)
    - [depthTest](https://www.itread01.com/articles/1476667276.html)
        - `WebGLRenderer.logarithmicDepthBuffer` and `camera.near/far` may cause weird depthTest.
        - when using `transparent` and `renderOrder` to clip something

- Material :
    - Max TextureSize : 4096*4096
    - sovle z-fighting by polygon offset
        ```
        const material = new THREE.Material({
            polygonOffset: true,
            polygonOffsetFactor: 1.0,
            polygonOffsetUnits: 4.0
        })
        ```
- Object :
    - Billboard : `Obejct3D.onAfterRender/.onBeforeRender` is usefull, function is called with the following parameters: renderer, scene, camera, geometry, material, group.

- Interact :

    - Raycaster : face normal
        ```
        private intersect2rot4( intersect: THREE.Intersection ): THREE.Matrix4
        {
            if ( intersect )
            {
                const n = intersect.face.normal.clone();
                intersect.object.updateMatrixWorld( true )
                n.transformDirection( intersect.object.matrixWorld );
                const mat4 = new THREE.Matrix4().lookAt( n, new THREE.Vector3( 0, 0, 0 ), this.camera.up );
                return mat4;
            }
        }
        ```

# Yarn

- start with local network to debug on mobile : `yarn start --host 0.0.0.0`

# JS/TS config

- import path 
    ```
    "compilerOptions": {
        "baseUrl": "./src"
    }
    ```

# React 16.8 Hook

- variable to update components
    -  `useContext` cross components
    -  `useState` in component