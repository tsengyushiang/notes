## MobilePinchZoomControls

```javascript
import { useEffect, useState, useRef } from "react";
import styled from "styled-components";

const Wrapper = styled.div`
  width: 100%;
  height: 100%;
  overflow: auto;
`;

// NOTE: don't use .attrs((props) => ,  it makes scrollHeight won't update immediately on IOS device.
const ZoomTarget = styled.div`
  transform-origin: 0% 0%;
  transform: scale(${(props) => props.scale});
`;

const attachPinchZoomEvents = (element, setScale) => {
  const { onMove, onEnd, onStart } = (() => {
    let baseScale = 1;
    let currentScale = 1;
    let baseScrollLeft = 0;
    let baseScrollTop = 0;
    let scrollLeftOffsetUnit = 0;
    let scrollTopOffsetUnit = 0;

    const onMove = (scale) => {
      currentScale = Math.max(baseScale * scale, 1.0);
      setScale(currentScale);

      element.scrollTo(
        baseScrollLeft + (currentScale - baseScale) * scrollLeftOffsetUnit,
        baseScrollTop + (currentScale - baseScale) * scrollTopOffsetUnit,
      );
    };

    const onEnd = () => {
      baseScale = currentScale;
    };

    const onStart = (anchorX, anchorY) => {
      baseScrollLeft = element.scrollLeft;
      baseScrollTop = element.scrollTop;

      scrollLeftOffsetUnit =
        ((anchorX / 100) * element.scrollWidth) / baseScale;
      scrollTopOffsetUnit =
        ((anchorY / 100) * element.scrollHeight) / baseScale;
    };

    return { onMove, onEnd, onStart };
  })(setScale);

  let start = {};

  const distance = (event) => {
    return Math.hypot(
      event.touches[0].pageX - event.touches[1].pageX,
      event.touches[0].pageY - event.touches[1].pageY,
    );
  };

  const calcPercentage = (clientX, clientY) => {
    const width = element.scrollWidth;
    const height = element.scrollHeight;

    const clickX =
      clientX - element.getBoundingClientRect().left + element.scrollLeft;
    const clickY =
      clientY - element.getBoundingClientRect().top + element.scrollTop;

    const percentageX = (clickX / width) * 100;
    const percentageY = (clickY / height) * 100;

    return { x: percentageX, y: percentageY };
  };

  const touchStart = (event) => {
    if (event.touches.length === 2) {
      const { x, y } = calcPercentage(
        (event.touches[0].clientX + event.touches[1].clientX) / 2,
        (event.touches[0].clientY + event.touches[1].clientY) / 2,
      );
      onStart(x, y);

      event.preventDefault();

      start.distance = distance(event);
    }
  };

  const touchMove = (event) => {
    if (event.touches.length === 2) {
      event.preventDefault();

      const deltaDistance = distance(event);
      const scale = deltaDistance / start.distance;
      const truncateScale = scale;

      onMove(truncateScale);
    }
  };

  element.addEventListener("touchstart", touchStart);
  element.addEventListener("touchmove", touchMove);
  element.addEventListener("touchend", onEnd);

  return () => {
    element.removeEventListener("touchstart", touchStart);
    element.removeEventListener("touchmove", touchMove);
    element.removeEventListener("touchend", onEnd);
  };
};

const PinchZoomControls = ({ children }) => {
  const wrapperRef = useRef(null);
  const [scale, setScale] = useState(1);

  useEffect(() => {
    const clear = attachPinchZoomEvents(wrapperRef.current, setScale);
    return clear;
  }, []);

  return (
    <Wrapper ref={wrapperRef}>
      <ZoomTarget scale={scale}>{children}</ZoomTarget>
    </Wrapper>
  );
};

export default PinchZoomControls;
```

## Issue

### Children is missing when scale gets bigger.
> Resolved: Add css `transform: translate3d(0px, 0px, 0px)` to children, [reference](https://stackoverflow.com/questions/13666688/webkit-transform-scale-making-items-disappear).
