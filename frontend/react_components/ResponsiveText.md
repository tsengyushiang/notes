```javascript
import { useRef, useEffect } from "react";
import styled from "styled-components";

const SVG = styled.svg`
  width: 100%;
  height: 100%;
`;

export const Text = styled.text`
  fill: rgba(100, 100, 100, 0.5);
`;

const ResponsiveText = ({ text }) => {
  const svgRef = useRef(null);
  const textRef = useRef(null);

  useEffect(() => {
    const svg = svgRef.current;
    const textNode = textRef.current;
    const { x, y, width, height } = textNode.getBBox();
    svg.setAttribute("viewBox", `${x} ${y} ${width} ${height}`);
  }, [text]);

  return (
    <SVG ref={svgRef}>
      <Text ref={textRef}>{text}</Text>
    </SVG>
  );
};

export default ResponsiveText;
```
