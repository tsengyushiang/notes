# Packages

- Helper
  - [lodash](https://lodash.com/)
  - [js-cookie](https://github.com/js-cookie/js-cookie)
  - [immer](https://github.com/immerjs/immer)
  - [DOMPurify](https://github.com/cure53/DOMPurify)

- React
  - [PDF Loader : react-pdf](https://github.com/diegomura/react-pdf)
  - [Viewport Focus Detect : react-intersection-observer](https://github.com/researchgate/react-intersection-observer)
  - [Drag and Drop : react-beautiful-dnd](https://github.com/atlassian/react-beautiful-dnd): [example](https://codesandbox.io/s/zh2wy)
  - [Web Code Editor : react-ace](https://github.com/securingsincity/react-ace/tree/master)
  - [Graph Editor : react-flow](https://github.com/wbkd/react-flow)

- Others
  - [animejs](https://animejs.com/)
  - [dat.gui](https://github.com/dataarts/dat.gui)
  - [file-saver](https://github.com/eligrey/FileSaver.js)
  - [Resoucre Monitor : stats.js](https://github.com/mrdoob/stats.js/)
  - [Code Compare Editor: ace-editor](https://github.com/ace-diff/ace-diff)

## Examples

* file-saver

```
import { saveAs } from 'file-saver';
const blob = new Blob( [ JSON.stringify( json ) ], { type: "application/json" } );
saveAs( blob, "media.json" );
```

* DOMPurify

```
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