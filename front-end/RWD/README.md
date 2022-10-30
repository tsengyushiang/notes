# Responsive Web Design(RWD)

## CSS

- interaction : 

    - mouse click :
        ```
        // disabel mouse event
        pointer-event : none;

        //default
        pointer-event : auto;
        ```

- layout :

    - flex

- @media Rule :

    - [source](https://www.w3schools.com/cssref/css3_pr_mediaquery.php)

    ```
    /* widht smaller than 400px*/
    body {
        background-color: lightblue;
    }

     /* width between 400px and 800px*/
    @media screen and (min-width: 400px) {
        body {
            background-color: lightgreen;
        }
    }

     /* width bigger than 800px*/
    @media screen and (min-width: 800px) {
        body {
            background-color: lavender;
        }
    }
    ```

- before/after

    ```
    div:before {
        content: "+";
    }
    ```

## HTML settings

* device viewport

    * [reference](./meta-viewport.html)
    
    ```
    // initial size 100%
    <meta name="viewport" content="width=device-width, initial-scale=1" >

    // avoid zoom in/out
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

    // iPhone X
    <meta name="viewport" content="viewport-fit=cover">
    body {
        padding-top: constant(safe-area-inset-top);
        padding-right: constant(safe-area-inset-right);
        padding-bottom: constant(safe-area-inset-bottom);
        padding-left: constant(safe-area-inset-left);
    }
    ```