# ModalBox

```
import { useEffect } from "react";
import { createPortal } from "react-dom";

const ModalBox = ({ children }) => {
  const container = document.createElement("div");
  useEffect(() => {
    document.body.appendChild(container);
    return () => {
      document.body.removeChild(container);
    };
  });

  return createPortal(children, container);
};

export default ModalBox;
```