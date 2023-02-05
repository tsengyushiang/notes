# Styled-components

- [official quick start](https://styled-components.com/)
- [document](https://styled-components.com/docs)

## Setup 

- install packages

    ```
    npm install --save styled-components
    npm install --save-dev babel-plugin-styled-components
    ```

- add `.babelrc`

    ```
    {
    "presets": ["next/babel"],
    "plugins": [["styled-components", { "ssr": true, "displayName": true }]]
    }
    ```

## Usage

- Extended Styled Components
   
    - [reference](https://betterprogramming.pub/7-ways-to-inherit-styles-using-styled-components-69debaad97e3)

```
import { Icon } from "../../../../styles/Icon";
export const IconMusic = styled(Icon)``;
```

- with arguments

```
import styled, { css } from "styled-components";

const Button = styled.button`
  border-radius: 3px;
  
  ${props => props.primary && css`
    background: palevioletred;
    color: white;
  `}
`;
```

- element with attribute

```
const InputColor = styled.input.attrs({ 
  type: 'color',
})`
  border-radius: 3px;
`;
```

- usage in `.js`

```
render(
  <Container>
    <InputColor/>
    <Button>Normal Button</Button>
    <Button primary>Primary Button</Button>
  </Container>
);
```

- keyframes

```
import styled, { css, keyframes } from "styled-components";

const sizeChangingAnimation = keyframes`
  0% { transform: scale(1.0);}
  50% { transform: scale(0.7);}
  100% { transform: scale(1.0);}
`;
export const IconMusic = styled.div`
  ${(props) =>
    props.isPlaying &&
    css`
      animation: ${sizeChangingAnimation} 1s infinite;
    `}
`;
```

## Server side rendering Styled-Components with NextJS

- [official doc](https://nextjs.org/docs/advanced-features/custom-document), [reference](https://medium.com/swlh/server-side-rendering-styled-components-with-nextjs-1db1353e915e)

- disable JavaScript on the browser (e.g in Chrome: Settings / Site settings / JavaScript / Blocked) to check setting works

- `/pages/_document.js`

  ```
  import Document, { Head, Html, Main, NextScript } from "next/document";
    import { ServerStyleSheet } from "styled-components";

    export default class MyDocument extends Document {
      static async getInitialProps(ctx) {
        const sheet = new ServerStyleSheet();
        const originalRenderPage = ctx.renderPage;

        try {
          ctx.renderPage = () =>
            originalRenderPage({
              enhanceApp: (App) => (props) =>
                sheet.collectStyles(<App {...props} />),
            });

          const initialProps = await Document.getInitialProps(ctx);
          return {
            ...initialProps,
            styles: (
              <>
                {initialProps.styles}
                {sheet.getStyleElement()}
              </>
            ),
          };
        } finally {
          sheet.seal();
        }
      }

      render() {
        return (
          <Html>
            <Head />
            <body style={{ margin: "0px" }}>
              <Main />
              <NextScript />
            </body>
          </Html>
        );
      }
    }
  ```