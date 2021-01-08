# Javascript

- packages:

    - [lodash](https://lodash.com/)
    - [animejs](https://animejs.com/)

- Vanilla Js:

    - Object :

        - merge object to another, usefull when inherent getter

            ```
            public get targetInfo(): RaycastInfo
            {
                return {
                    type: RaycastType.SHOWMODAL | RaycastType.MOVE,
                    id: EObjectType.MODEL,
                    url: this.openLink,
                    ...super[ 'targetInfo' ]
                }
            }
            ```
        
        - beatify JSON : `JSON.stringify(jsObj, null, 4);`

    - [Request](https://developer.mozilla.org/zh-TW/docs/Web/API/Fetch_API/Using_Fetch)

        ```
        fetch('http://example.com/movies.json').then(function(response) {
            return response.json();
        }).then(function(myJson) {
            console.log(myJson);
        });
        ```

    - bitwise tag :
        ```
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

# Yarn

- start with local network to debug on mobile : `yarn start --host 0.0.0.0`

# JS/TS config

- import path 
    ```
    "compilerOptions": {
        "baseUrl": "./src"
    }
    ```