## WebGLPannel

```javascript
import React, { useEffect, useRef } from "react";

const getMatrixFromScaleAndTranslate = (scale, translate) => {
  return [
    [scale, 0.0, translate[0]],
    [0.0, scale, translate[1]],
  ];
};

const applyTransform = (matrix, points) => {
  const pointsArray = [
    [points[0], points[1]],
    [points[2], points[3]],
    [points[4], points[5]],
    [points[6], points[7]],
  ];

  const transformedPoints = [];
  for (let i = 0; i < pointsArray.length; i++) {
    const x = pointsArray[i][0];
    const y = pointsArray[i][1];

    const transformedX = matrix[0][0] * x + matrix[0][1] * y + matrix[0][2];
    const transformedY = matrix[1][0] * x + matrix[1][1] * y + matrix[1][2];

    transformedPoints.push(transformedX, transformedY);
  }

  return transformedPoints;
};

const shaders = {
  vertexShader: `
    attribute vec2 a_position;
    varying vec2 v_texCoord;
    void main() {
      gl_Position = vec4(a_position, 0.0, 1.0);
      v_texCoord = a_position.xy/2.0+0.5;
    }
  `,
  fragmentShader: `
    precision mediump float;
    uniform sampler2D u_texture;
    varying vec2 v_texCoord;
    void main() {
      gl_FragColor = texture2D(u_texture, v_texCoord);
    }
  `,
};

const initGL = (canvas) => {
  const gl = canvas.getContext("webgl", { stencil: true });
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT);

  gl.enable(gl.STENCIL_TEST);

  if (!gl) {
    throw "WebGL is not supported";
  }

  const compileShader = (vertexShaderSource, fragmentShaderSource) => {
    const vertexShader = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertexShader, vertexShaderSource);
    gl.compileShader(vertexShader);

    // Check for vertex shader compilation errors
    if (!gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)) {
      console.error(
        "Vertex shader compilation error:",
        gl.getShaderInfoLog(vertexShader),
      );
      return;
    }

    const fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragmentShader, fragmentShaderSource);
    gl.compileShader(fragmentShader);

    // Check for fragment shader compilation errors
    if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) {
      console.error(
        "Fragment shader compilation error:",
        gl.getShaderInfoLog(fragmentShader),
      );
      return;
    }

    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    // Check for program linking errors
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
      console.error("Program linking error:", gl.getProgramInfoLog(program));
      return;
    }

    return program;
  };

  const positionBuffer = gl.createBuffer();
  const positions = [-1, 1, -1, -1, 1, 1, 1, -1];
  const drawRectangle = (positionAttributeLocation, matrix) => {
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    gl.bufferData(
      gl.ARRAY_BUFFER,
      new Float32Array(applyTransform(matrix, positions)),
      gl.STATIC_DRAW,
    );
    gl.enableVertexAttribArray(positionAttributeLocation);
    gl.vertexAttribPointer(positionAttributeLocation, 2, gl.FLOAT, false, 0, 0);

    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  };

  const renderStencilBuffer = (render) => {
    gl.stencilFunc(gl.ALWAYS, 1, 0xff);
    gl.stencilOp(gl.KEEP, gl.KEEP, gl.REPLACE);

    render();

    gl.stencilFunc(gl.EQUAL, 0, 0xff);
    gl.stencilOp(gl.KEEP, gl.KEEP, gl.KEEP);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  };

  const loadTexture = (imageURL, u_texture) => {
    return new Promise((resolve) => {
      const texture = gl.createTexture();
      const image = new Image();
      image.src = imageURL;
      image.onload = () => {
        gl.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, true);
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, texture);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
        gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
        gl.texImage2D(
          gl.TEXTURE_2D,
          0,
          gl.RGBA,
          gl.RGBA,
          gl.UNSIGNED_BYTE,
          image,
        );
        gl.uniform1i(u_texture, 0);
        resolve();
      };
    });
  };

  return {
    gl,
    helpers: {
      drawRectangle,
      compileShader,
      renderStencilBuffer,
      loadTexture,
    },
  };
};

const WebGLPannel = ({ imageURL }) => {
  const canvasRef = useRef(null);

  useEffect(() => {
    try {
      const canvas = canvasRef.current;
      const { gl, helpers } = initGL(canvas);

      const program = helpers.compileShader(
        shaders.vertexShader,
        shaders.fragmentShader,
      );

      const positionAttributeLocation = gl.getAttribLocation(
        program,
        "a_position",
      );
      const u_texture = gl.getUniformLocation(program, "u_texture");

      helpers.renderStencilBuffer(() => {
        helpers.drawRectangle(
          positionAttributeLocation,
          getMatrixFromScaleAndTranslate(0.5, [0.1, 0.3]),
        );
        helpers.drawRectangle(
          positionAttributeLocation,
          getMatrixFromScaleAndTranslate(0.1, [-0.5, -0.3]),
        );
      });

      gl.useProgram(program);
      helpers
        .loadTexture(imageURL, u_texture)
        .then(() =>
          helpers.drawRectangle(
            positionAttributeLocation,
            getMatrixFromScaleAndTranslate(1.0, [0, 0]),
          ),
        );
    } catch (e) {
      console.error(e);
    }
  }, [imageURL]);

  return <canvas ref={canvasRef} />;
};

export default WebGLPannel;

```

## Notes

- enable `preserveDrawingBuffer` for `toDataURL`

```
const gl = canvas.getContext("webgl", { preserveDrawingBuffer: true });
// some render code
const dataURL = canvas.toDataURL();
```


## Reference

- [Stencil buffer](https://webglfundamentals.org/webgl/lessons/webgl-qna-how-to-use-the-stencil-buffer.html)
- [Texture](https://codesandbox.io/s/8psig)
