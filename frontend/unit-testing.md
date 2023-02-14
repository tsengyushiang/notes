# Unit Testing

## Setup

### Add Dev Dependencies

- Add package to `package.json` and run `yarn install`.

```json
"scripts": {
  ...
  "test": "jest"
},
"devDependencies": {
  "@testing-library/jest-dom": "^5.8.0",
  "@testing-library/react": "^10.0.4",
  "@testing-library/user-event": "^14.4.3",
  "jest": "26.0.0",
}
```

- Run `yarn test` for unit testing.

## Syntax

### Import Packages

  ```javascript
  import "@testing-library/jest-dom";
  import * as React from "react";
  import { render, fireEvent, screen } from "@testing-library/react";
  import userEvent from "@testing-library/user-event";
  ```

### Write Test

  ```javascript

  function setup(jsx) {
    return {
      user: userEvent.setup(),
      ...render(jsx),
    }
  }
  
  describe("Task Descript", () => {
    test("test1", () => {
      // const {user} = setup(<MyComponent />)
      // screen.logTestingPlaygroundURL(); // this will help you get query syntex
      // const target=screen.getBy...
      // expect(...).toBe...
    });

    test("test2", () => {
     // second testing code here...
    });
  });
  ```
  
### Mock 

- Function
    
```javascript
const mockCallBack = jest.fn();
```

- Component

```javascript
jest.mock("../../components/Icon", () => () => "Icon");
```

```javascript
const icon = screen.getByText(/icon/i); // then get element like this
```

- Package

```javascript
jest.mock("react-i18next", () => ({
  useTranslation: () => {
    return {
      t: (t) => t,
      i18n: {
        changeLanguage: () => new Promise(() => {}),
      },
    };
  },
}));
```

### Fire Events


- onBlur

  ```javascript
  target.focus();
  target.blur();
  ```

- onClick

  ```javascript
  user.click(target);
  ```

- [Type Input](https://testing-library.com/docs/user-event/keyboard/)

  ```javscript
  input.focus();
  await user.keyboard("123456");
  ```

### Assertion

- Element 

  - Attribute : `expect(...).toHaveAttribute("href", link);`
 
  - Visible : `expect(...).toBeVisible();`, `expect(...).toBeInTheDocument()`

- Callback value `expect(func.mock.calls.pop()[0])`

  - String : `expect(...).toEqual("✓");`, `expect(...).not.toEqual("✓");`
  
  - Object : `expect(...).toMatchObject({...});`

## Errors

### `warning: An update to Icon inside a test was not wrapped in act(...).`
  
  - This warning is caused by state update in the component.
  - Issue can be fixed by wrapping update function with act.
  - [Some examples](https://kentcdodds.com/blog/fix-the-not-wrapped-in-act-warning)

### `TypeError: MutationObserver is not a constructor ... await waitFor(()=>...`

  - [upgrate jest to v25.4.0](https://github.com/testing-library/dom-testing-library/issues/477#issuecomment-617652033)

### `target.ownerDocument.createRange is not a function`

  - [upgrate jest to v26.0.0](https://github.com/mui/material-ui/issues/15726#issuecomment-493124813)

### `TypeError: Cannot set property ‘fillStyle’ of null` firing on the Phaser import

- [Reference](https://tnodes.medium.com/setting-up-jest-with-react-and-phaser-422b174ec87e)

- Install package

```
yarn add -D jest-canvas-mock
```

- Add config to `jest.config.js`

  ```javascript
  module.exports = {
    setupFiles: ["jest-canvas-mock"],
  };
  ```

### Static Assets SVG  

- Add `jest.config.js`

  ```javascript
  module.exports = {
    moduleNameMapper: {
      "\\.svg$": "<rootDir>/__mocks__/svg.js",
    },
  };
  ```

- Add `__mocks__/svg.js`

  ```
  export default "div";
  export const ReactComponent = "div";
  ```
