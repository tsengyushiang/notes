# Vanilla Js

## Object

### Dictionary Parser

- json

```javascript
JSON.stringify(jsObj, null, 4);
```

- extends values

```javascript

const data = {
    key: "value",
}

const paths = Object.fromEntries(
  Object.entries(data).map(([key, value]) => [key, extends(value)]),
);
```


### undefined

```javascript
undefined && true // undefined
undefined && false // undefined
!!undefined // false
!undefined // true
Boolean(undefined) // false
```

### ObjectURL

- Parser canvas to objectURL.

```javascript
canvas.toBlob((blob) => URL.createObjectURL(blob));
```

- Releases an existing object URL.

```javascript
URL.revokeObjectURL(objectURL);
```

### Array

- search and remove object from array

```javascript
function removeFromArray( array, obj )
{
    const index = array.indexOf( obj )
    if ( index > -1 )
    {
        array.splice( index, 1 );
    }
}
```

## [Request](https://developer.mozilla.org/zh-TW/docs/Web/API/Fetch_API/Using_Fetch)

```javascript
fetch('http://example.com/movies.json').then(function(response) {
    return response.json();
}).then(function(myJson) {
    console.log(myJson);
});
```

## Operator

### Bitwise Tag

```javascript
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

### Spread Operator

```javascript
[...Array(2)].map((_,idx)=>idx) //[0,1]

const arr = ['a','b','c']
[...arr,'d','e'] //['a','b','c','d','e']

{...arr} //{0: 'a', 1: 'b', 2: 'c'}
```

## Redirect

### Current Page

```javascript
function redirect(url) {
    window.location.href = url;   
}
```

### New Tab

```javascript
function openInNewTab(url) {
    const win = window.open(url, '_blank');
    win.focus();
}
```

### HTML in new tab

```javascript
const html = `
  <!DOCTYPE html>
  <html>
    <head>
      <title>My Blob Page</title>
      <script>
        console.log("Hello from the blob!");
      </script>
    </head>
    <body>
      <h1>This is rendered from a Blob</h1>
    </body>
  </html>
`;

const blob = new Blob([html], { type: 'text/html' });
const url = URL.createObjectURL(blob);

// Open in a new tab
window.open(url, '_blank');
```

## Debug

- log color in console
```javascript
const css = `background: rgba(${zeroTo255R},${zeroTo255G},${zeroTo255B},${1.0});`
console.log('%c color', css)
```

## Elements

### Window

- Focus on element with id.

```javascript
window.location.hash = "element_id";
// <div id="element_id"/>
```

### Document

- Triggering `onBlur` in JavaScript is useful when implementing the `fouc-within` CSS style

```javascript
const focusedElement = document.activeElement;
if (focusedElement) {
    focusedElement.blur();
}
```

### Input/Textarea

- judge next character will make element overflow

```javascript
export function isInputOverflow(element, text) {
  const tempSpan = document.createElement("span");
  tempSpan.style.visibility = "hidden";
  tempSpan.style.whiteSpace = "nowrap";
  tempSpan.style.font = window.getComputedStyle(element).font;
  tempSpan.textContent = text;
  document.body.appendChild(tempSpan);

  const isOverflow = tempSpan.offsetWidth > element.offsetWidth;

  document.body.removeChild(tempSpan);

  return isOverflow;
}

// scrollHeight including padding, border and the invisible area, so make sure padding and border is 0px or subtract them.
export function isTextareaOverflow(element) {
  return element.scrollHeight > element.clientHeight;
}
```

### Canvas

- Avoid applying CSS transform to the canvas size, as it may cause blurriness on iOS Safari.

- There are pixel numbers limitation, [test report](https://github.com/jhildenbiddle/canvas-size#test-results).

```javascript
const IOS_SAFARI_MAX_CANVAS_PIXELS = 16777216
const pixel =
      divRef.current.clientWidth *
      divRef.current.clientHeight *
      window.devicePixelRatio *
      window.devicePixelRatio;

const maxScale = Math.sqrt(IOS_SAFARI_MAX_CANVAS_PIXELS / pixel) - 1e-1;
```

- Render content only in mask, and circle brush for cleaning mask. 

```javascript

const drawCircle = (ctx, x, y, radius) => {
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2);
    ctx.fill();
};

const drawLine = (ctx, x1, y1, x2, y2 lineWidth) => {
    ctx.lineWidth = lineWidth;
    ctx.beginPath();
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();

    const radius = lineWidth / 2;
    drawCircle(ctx, x1, y1, radius);
    drawCircle(ctx, x2, y2, radius);
};

const drawMask = (ctx, x, y, isErasing, radius) => {
 ctx.globalCompositeOperation = isErasing
      ? "destination-out"
      : "source-over";
      
  // drawCircle(...) or drawLine(...)

  ctx.globalCompositeOperation = "source-over";
};

const applyMask = (mask, canvas, result) => {
  const ctx = result.getContext("2d");

  ctx.clearRect(0, 0, result.width, result.height);

  ctx.globalCompositeOperation = "source-over";
  ctx.drawImage(mask, 0, 0);

  ctx.globalCompositeOperation = "source-in";
  ctx.drawImage(canvas, 0, 0);

  ctx.globalCompositeOperation = "source-over";
};
```
### Iframe

-  Embed apps in iframe should consider SameSite. ([reference](https://medium.com/%E7%A8%8B%E5%BC%8F%E7%8C%BF%E5%90%83%E9%A6%99%E8%95%89/%E5%86%8D%E6%8E%A2%E5%90%8C%E6%BA%90%E6%94%BF%E7%AD%96-%E8%AB%87-samesite-%E8%A8%AD%E5%AE%9A%E5%B0%8D-cookie-%E7%9A%84%E5%BD%B1%E9%9F%BF%E8%88%87%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A0%85-6195d10d4441))

```javascript

// client-side: set iframe webpage's cookie with js-cookie packages
Cookies.set("access_token", accessToken, {
    sameSite: "None",
    secure: true,
});

// server-side: set parent cookie from iframe webpage.
res.cookie("name", value, {
    samSite: "None",
    secure: true,
});
```

- Make iframe content bigger

```css
iframe {
    width: 200%;
    height: 200%;
    transform: scale(0.5);
    transform-origin: 0 0;
}
```

## Events

### Mouse

- get cursor position

```javascript
function updateMouse(event, mouse: THREE.Vector2) {
    if (event.type.includes('touch')) {
        mouse.x = event.changedTouches[0].clientX;
        mouse.y = event.changedTouches[0].clientY;
    } else {
        mouse.x = event.clientX;
        mouse.y = event.clientY;
    }
}
```

### Touch

- Disable pinch-zoom on mobile.

    - Andriod device
      
    ```html
     <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    />
    ```
    
    - IOS device
      
    ```javascript
    function preventDefault(e) {
        e.preventDefault();
    }
    document.addEventListener("gesturestart", preventDefault);
    document.addEventListener("gesturechange", preventDefault);
    document.addEventListener("gestureend", preventDefault);
    ```
    > Iframe should use the same settings for IOS device, because settings on parent webpage wont block iframe's behavior.

    - Disable pull to refresh on IOS
    ```css
    html {
      overflow: hidden;
    }
    ```
    
### Keyboard

- check number

```javascript
const isNumber = (key) => {
    return /^[0-9]$/i.test(key);
};
```

- `ctrl+c` (only support `https` webpage, failed in `http`)

```javascript
navigator.clipboard.writeText("text to copy")
```

## MediaRecorder

- Stream recoder for canvas

```javascript

const recorder = (() => {
  let mediaRecorder;

  const start = (canvas) => {
    const stream = canvas.captureStream();
    mediaRecorder = new MediaRecorder(stream);
    mediaRecorder.start();
  };

  const stop = () => {
    const recordedBlobs = [];
    const handleDataAvailable = (event) => {
      if (event.data && event.data.size > 0) {
        recordedBlobs.push(event.data);
      }
    };
    return new Promise((resolve) => {
      mediaRecorder.ondataavailable = handleDataAvailable;
      mediaRecorder.onstop = () => {
        resolve(new Blob(recordedBlobs, { type: "video/mp4" }));
      };
    });
  };

  const reset = () => {
    mediaRecorder = null;
  };

  return {
    start,
    stop,
    reset,
  };
})();

```

- Stream recoder for camera, share screen.

```javascript
import { v4 as uuid } from "uuid";

const Recorder = (() => {
  const setStreamToVideoElement = (stream, element) => {
    const { width, height } = stream.getVideoTracks()[0].getSettings();
    element.width = width;
    element.height = height;
    element.autoplay = true;
    element.srcObject = new MediaStream(stream.getTracks());
  };

  const openStream = (starter) => {
    return async (video) => {
      const streamIsCurrentTab = (() => {
        try {
          const id = uuid();
          navigator.mediaDevices.setCaptureHandleConfig({
            handle: id,
            permittedOrigins: ["*"],
          });
          return (stream) => {
            const [track] = stream.getVideoTracks();

            return (
              track.getCaptureHandle &&
              track.getCaptureHandle() &&
              track.getCaptureHandle().handle === id
            );
          };
        } catch (e) {
          console.warn("setCaptureHandleConfig is not supported:", e);
          return () => true;
        }
      })();

      const stream = await starter();
      if (stream && video) {
        setStreamToVideoElement(stream, video);
      }
      if (stream) {
        const close = () => stream.getTracks().forEach((track) => track.stop());

        const record = (onRecordDone) => {
          const supportType = ["video/mp4", "video/webm; codecs=vp9"].find(
            (type) => MediaRecorder.isTypeSupported(type)
          );
          if (!supportType) {
            console.warn("recorder cant found support type.");
            return;
          }

          const encoderOptions = { mimeType: supportType };
          const mediaRecorder = new MediaRecorder(stream, encoderOptions);

          const handleDataAvailable = (event) => {
            if (event.data.size > 0) {
              const blob = new Blob([event.data], {
                type: supportType,
              });
              onRecordDone(blob);
            } else {
              console.warn("stream data not available");
              onRecordDone(null);
            }
          };

          mediaRecorder.ondataavailable = handleDataAvailable;
          mediaRecorder.start();
          return () => mediaRecorder.stop();
        };

        const isCapturingCurrent = () => streamIsCurrentTab(stream);

        return { close, record, isCapturingCurrent };
      }
    };
  };

  const openCamera = openStream(() =>
    navigator.mediaDevices.getUserMedia({
      video: true,
      audio: { deviceId: { ideal: "communications" } },
    })
  );

  const shareScreen = openStream(() =>
    navigator.mediaDevices.getDisplayMedia({
      video: true,
      audio: true,
      preferCurrentTab: true,
    })
  );

  return { openCamera, shareScreen };
})();

export default Recorder;
```
