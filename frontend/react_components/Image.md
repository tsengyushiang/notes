# Image

- To make image reload with the same URL, add `time` to query string.
- But add `time` make `Image` reload every time it rerender, so wrap it with `React.memo` make performance better.
- If you want to reload it with same URL, destory and rerender it, or you can use `ImageWithLoading` in following code. 

```javascript
import React from "react";
import moment from "moment";

export const ImageWithLoading = ({src,isLoading})=>{
  if(isLoading) return null // return loading-styled component.
  return <Image src={src}/>
}

const Image = ({ src }) => {
  const url = new URL(src);
  if (url.protocol !== "data:") // don't add time to dataURL
    url.searchParams.append("time", moment().unix());
  return <div style={{"background-image": src}}/>;
};

export default React.memo(Image);
```
