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
