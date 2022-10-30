# Packages

- [lodash](https://lodash.com/)
- [animejs](https://animejs.com/)
- [dat.gui](https://github.com/dataarts/dat.gui)
- [file-saver](https://github.com/eligrey/FileSaver.js)
    ```
    import { saveAs } from 'file-saver';
    const blob = new Blob( [ JSON.stringify( json ) ], { type: "application/json" } );
    saveAs( blob, "media.json" );
    ```
- [stats.js](https://github.com/mrdoob/stats.js/)
- [react-beautiful-dnd
](https://github.com/atlassian/react-beautiful-dnd)

## Yarn

- start with local network to debug on mobile : `yarn start --host 0.0.0.0`