# Packages

- [lodash](https://lodash.com/)
- [animejs](https://animejs.com/)
- [dat.gui](https://github.com/dataarts/dat.gui)
- [file-saver](https://github.com/eligrey/FileSaver.js)
- [stats.js](https://github.com/mrdoob/stats.js/)
- [react-beautiful-dnd
](https://github.com/atlassian/react-beautiful-dnd)
- [react-pdf](https://github.com/diegomura/react-pdf)
- [react-intersection-observer](https://github.com/researchgate/react-intersection-observer)
- [DOMPurify](https://github.com/cure53/DOMPurify)


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

## Yarn

- start with local network to debug on mobile : `yarn start --host 0.0.0.0`
