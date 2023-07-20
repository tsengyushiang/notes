# Vanilla Js

## Object

### object to JSON string 

```javascript
JSON.stringify(jsObj, null, 4);
```

### undefined

```javascript
undefined && true // undefined
undefined && false // undefined
!!undefined // false
!undefined // true
Boolean(undefined) // false
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

## Debug

- log color in console
```javascript
const css = `background: rgba(${zeroTo255R},${zeroTo255G},${zeroTo255B},${1.0});`
console.log('%c color', css)
```

## Events Helpers

### Document

- Triggering `onBlur` in JavaScript is useful when implementing the `fouc-within` CSS style

```javascript
const focusedElement = document.activeElement;
if (focusedElement) {
    focusedElement.blur();
}
```

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

export function isTextareaOverflow(element) {
  return element.scrollHeight > element.clientHeight;
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

### Canvas

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

### Media

- Recoder camera, screen helpers:

```javascript
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
      const stream = await starter();
      if (stream && video) {
        setStreamToVideoElement(stream, video);
      }
      if (stream) {
        const close = () => stream.getTracks().forEach((track) => track.stop());

        const record = (onRecordDone) => {
          const encoderOptions = { mimeType: "video/webm; codecs=vp9" };
          const mediaRecorder = new MediaRecorder(stream, encoderOptions);

          const handleDataAvailable = (event) => {
            if (event.data.size > 0) {
              const blob = new Blob([event.data], {
                type: "video/webm",
              });
              const url = URL.createObjectURL(blob);
              onRecordDone(url);
            } else {
              console.warn("stream data not available");
              onRecordDone();
            }
          };

          mediaRecorder.ondataavailable = handleDataAvailable;
          mediaRecorder.start();
          return () => mediaRecorder.stop();
        };

        return { close, record };
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

