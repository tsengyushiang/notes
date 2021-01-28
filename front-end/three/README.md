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
    - shaderMaterial : calculate normal in shader
        ```
        const shadermat = new THREE.ShaderMaterial(...);

        // enable dFdx,dFdy
        shadermat.extensions.derivatives = true

        // in vertex shader
        pos =  position;

        // in fragment shader
        vec3 normal = normalize(cross(dFdx(pos), dFdy(pos)));
        ```

    - discard pixel instead write it transparent in fragmentShader
        ```
        uniform mediump vec3 chromaKeyColor;
        varying mediump vec3 vertexColor;
        void main{
            if((length(tColor - chromaKeyColor) - 0.5) * 7.0<0.1){
                 discard;
            }else{
                gl_FragColor = vec4(vertexColor,1.0);
            }
        }
        ```
    
- Object :

    - Billboard : `Obejct3D.onAfterRender/.onBeforeRender` is usefull, function is called with the following parameters: renderer, scene, camera, geometry, material, group.

    - local-axis aligned bounding box :
        ```
        this.boxHelper?.parent?.remove( this.boxHelper )
        const quaternion = this.object.quaternion.clone();
        this.object.quaternion.set( 0, 0, 0, 1 );
        this.boxHelper = new THREE.BoxHelper( this.object, 0x0077ff );
        this.object.quaternion.copy( quaternion );
        this.boxHelper.applyMatrix4( this.object.matrixWorld.invert() )
        this.object.add( this.boxHelper )
        ```

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
    - project 3d point to screen coordinate
        ```
        function createVector(x, y, z, camera, width, height) {
            var p = new THREE.Vector3(x, y, z);
            var vector = p.project(camera);

            vector.x = (vector.x + 1) / 2 * width;
            vector.y = -(vector.y - 1) / 2 * height;

            return vector;
        }
        ```
