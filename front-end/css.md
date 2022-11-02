# CSS

- interaction : 

    - mouse click :
        ```
        // disabel mouse event
        pointer-event : none;

        //default
        pointer-event : auto;
        ```

- before/after : add something before or after element

    ```
    div:before {
        content: "+";
    }
    ```
## Grid

- fixed size items

    ```css
    .grid-container {
      display: grid;
      grid-template-columns: auto auto auto;    /*display 3column*/
      justify-content:center;                   /*make items close to each others*/
      padding-left:50%;                         /*control grid position*/
    }
    .grid-item {
       /* sort fixed size item with grid*/
      width:100px;
      height:100px;
      word-wrap: break-word /*handle text overflow*/
    }
    ```

## Animations

- isLoading

    ```css
    .isLoading {
      background: linear-gradient(90deg, #a4a4a4 25%, #c4c4c4 50%, #a4a4a4 75%);
      background-size: 400% 100%;
        animation: moveBackground 1.5s ease-in infinite;
    }

    @keyframes moveBackground {
        0% {
            background-position: 0% 0%;
        }
        100% {
            background-position: 100% 0%;
        }
    }
    ```
