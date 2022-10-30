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

```
const Button = styled.button`
  background: transparent;
  border-radius: 3px;
  border: 2px solid palevioletred;
  color: palevioletred;
  margin: 0.5em 1em;
  padding: 0.25em 1em;

  ${props => props.primary && css`
    background: palevioletred;
    color: white;
  `}
`;

const Container = styled.div`
  text-align: center;
`
//pseudo-elements
const InputColor = styled.input.attrs({ 
  type: 'color',
})`
    -webkit-appearance: none;
    border: none;

    &:-webkit-color-swatch-wrapper {
      padding: 0;
    }

    &:-webkit-color-swatch {
      border: none;
    }
  }
`

render(
  <Container>
    <InputColor/>
    <Button>Normal Button</Button>
    <Button primary>Primary Button</Button>
  </Container>
);
```