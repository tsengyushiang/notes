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
