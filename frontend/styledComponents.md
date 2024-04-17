# Styled-components

- [official quick start](https://styled-components.com/)
- [document](https://styled-components.com/docs)

## Setup 

- install packages

```
npm install --save styled-components
npm install --save-dev babel-plugin-styled-components
```

- (Deprecated after next12) add `.babelrc`

```
{
"presets": ["next/babel"],
"plugins": [["styled-components", { "ssr": true, "displayName": true }]]
}
```

> According to the [document](https://styled-components.com/docs/advanced#with-swc), use `next.config.js` as the alternative.

`next.config.js`

```javascript
const nextConfig = {
  compiler: {
    styledComponents: true,
  },
}

module.exports = nextConfig
```


## Usage

- Extended Styled Components
   
    - [reference](https://betterprogramming.pub/7-ways-to-inherit-styles-using-styled-components-69debaad97e3)

```javascript
import { Icon } from "../../../../styles/Icon";
export const IconMusic = styled(Icon)``;
```

- with arguments

```javascript
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

```javascript
const InputColor = styled.input.attrs({ 
  type: 'color',
})`
  border-radius: 3px;
`;
```

- usage in `.js`

```javascript
render(
  <Container>
    <InputColor/>
    <Button>Normal Button</Button>
    <Button primary>Primary Button</Button>
  </Container>
);
```

- keyframes

```javascript
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

## Advanced

### Vite

`vite.config.js`
```javascript
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react({
    include: /\.(jsx|tsx)$/,
    babel: {
      plugins: ['styled-components'],
      babelrc: false,
      configFile: false,
    },
  })],
})
```

### Frequently changed styles.

- If styles change frequently use following syntax.

```diff
+ const Component = styled.div.attrs((props) => ({
+  style: {
+    backgroundColor: props.color,
+  },
+ }))`
-  background-color: ${(props) => props.color};
   /* Other static styles here */
`;
```

- This change make component appends a inline-style instead of creating a new class during every update.

```html
<div color="#877d7d" class="styled__Component-sc-16v9z3c-4 jYllQ" style="background-color: rgb(135, 125, 125);"></div>
```

### Server side rendering Styled-Components with NextJS

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

## Examples

### Dropdown Menu

```javascript
import styled from "styled-components";

const Icon = styled.div`
  pointer-events: auto;
`;

const Menu = styled.div`
  display: none;
`;

const Wrapper = styled.div`
  &:focus-within {
    ${Menu} {
      display: flex;
    }
    ${Icon} {
      pointer-events: none;
    }
  }
`;

const DropdownMenu = ({ children }) => (
  <Wrapper>
    <Icon tabIndex={0}>
      // some icon.
    </Icon>

    <Menu tabIndex={1}>
      {children}
    </Menu>
  </Wrapper>
);
```
