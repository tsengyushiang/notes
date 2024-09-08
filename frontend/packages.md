## Packages

### Helper
  - [lodash](https://lodash.com/)
  - [js-cookie](https://github.com/js-cookie/js-cookie)
  - [immer](https://github.com/immerjs/immer)
  - [DOMPurify](https://github.com/cure53/DOMPurify)
  - [source-map-explorer](https://github.com/danvk/source-map-explorer#readme)

### React
  - [PDF Loader : react-pdf](https://github.com/diegomura/react-pdf)
  - [Viewport Focus Detect : react-intersection-observer](https://github.com/researchgate/react-intersection-observer)
  - [Drag and Drop : react-beautiful-dnd](https://github.com/atlassian/react-beautiful-dnd): [example](https://codesandbox.io/s/zh2wy)
  - [Web Code Editor : react-ace](https://github.com/securingsincity/react-ace/tree/master)
  - [Graph Editor : react-flow](https://github.com/wbkd/react-flow)

### Others
  - [Timeline : animejs](https://animejs.com/)
  - [Debug GUI : dat.gui](https://github.com/dataarts/dat.gui)
  - [Download File : file-saver](https://github.com/eligrey/FileSaver.js)
  - [Image Affine Transform : homography](https://github.com/Eric-Canas/Homography.js)
  - [Resoucre Monitor : stats.js](https://github.com/mrdoob/stats.js/)
  - [Code Compare Editor: ace-editor](https://github.com/ace-diff/ace-diff)
  - [Unused File Scanner: unimported](https://github.com/smeijer/unimported#example)
  - [country-calling-code: country code mapping table](https://github.com/joonhocho/country-calling-code)
  - [dom-to-svg: convert a given HTML DOM node into an accessible SVG "screenshot".](https://www.npmjs.com/package/dom-to-svg)
  - [svg2pdf.js: a javascript-only SVG to PDF conversion](https://github.com/yWorks/svg2pdf.js)
  - [ELK's layout algorithms for JavaScript](https://github.com/kieler/elkjs)

## Examples

### Download File : file-saver

```javascript
import { saveAs } from 'file-saver';
const blob = new Blob( [ JSON.stringify( json ) ], { type: "application/json" } );
saveAs( blob, "media.json" );
```

### DOMPurify

```javascript
import DOMPurify from 'dompurify'

const App = () => {
  const data = `lorem <b onmouseover="alert('mouseover');">ipsum</b>`
  const sanitizedData = {
    __html: DOMPurify.sanitize(data)
  }

  return (
    <div
      dangerouslySetInnerHTML={sanitizedData}
    />
  );
}

export default App;
```

### PDF Loader : react-pdf

```javascript
import { pdfjs } from "react-pdf";
pdfjs.GlobalWorkerOptions.workerSrc = `//cdnjs.cloudflare.com/ajax/libs/pdf.js/${pdfjs.version}/pdf.worker.min.js`;

export const getDocDataURL = async (doc) => {
  try {
    const data = await doc.getData();
    const blob = new Blob([data], { type: "application/pdf" });
    const pdfDataUrl = URL.createObjectURL(blob);
    return pdfDataUrl;
  } catch (err) {
    console.log(err);
    return null;
  }
};

export const getDoc = async (url, onProgress, onLoad, onError) => {
  try {
    const loadingTask = pdfjs.getDocument({ url });
    if (onProgress)
      loadingTask.onProgress = ({ loaded, total }) => {
        const percentage = loaded / total;
        onProgress(percentage);
        if (percentage === 1) {
          loadingTask.onProgress = null;
        }
      };
    const doc = await loadingTask.promise;
    if (onLoad) onLoad(doc);
    return doc;
  } catch (err) {
    console.log(err);
    if (onError) onError(err);
    return null;
  }
};

/* usage
const doc = await getDoc("/sample.pdf"); // PDFDocumentProxy, look pdfjs document for detail.
const dataURL = await getDocDataURL(doc);  // blob:https://kdan-demo-op.dottedsign.com/5c46d654-f02e-4938-97bd-6676451f2c0f

import { Document } from "react-pdf";
<Document file={dataURL} ... />
*/
```
