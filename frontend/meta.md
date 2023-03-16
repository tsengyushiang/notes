# Meta

## Search Engine Optimization(SEO)

- Open Graph Tag

    - [reference](https://www.tpisoftware.com/tpu/articleDetails/1989)

    ```
    <meta property="og:title" content="title" />
    <meta property="og:image" content="abosolute URL" />
    <meta property="og:description" content="description" />
    ```


## Responsive Web Design(RWD)

* device viewport

    * [reference](./references/meta-viewport.html)
    
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

## Content-Security-Policy(CSP)

- [reference](https://hackmd.io/@Eotones/BkOX6u5kX)
```html
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src 'self' data:;">
```
