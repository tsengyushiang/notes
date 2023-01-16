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
  "jest": "24.9.0",
}
```

- Run `yarn test` for unit testing.

## Syntax

### Import Packages

  ```javascript
  import "@testing-library/jest-dom";
  import * as React from "react";
  import { render, fireEvent } from "@testing-library/react";
  ```

### Write Test

  ```javascript
  describe("Task Descript", () => {
    test("test1", () => {
      // testing code here...
      // const { container, getByText } = render(
      //   <Button onClick={mockFunction}/>,
      // );
    });

    test("test2", () => {
     // testing code here...
    });
  });
  ```
  
### Mock Function
    
```javascript

const mockCallBack = jest.fn();
expect(mockCallBack).toHaveBeenCalledTimes(1);

```

### Testing


- Check onBlur

  ```javascript
  const onBlur = jest.fn();
  const { container } = render(
    <div onBlur={onBlur}/>,
  );
  container.firstChild.focus();
  container.firstChild.blur();
  expect(onBlur).toHaveBeenCalledTimes(1);
  ```

- Check onClick

  ```javascript
  const onClick = jest.fn();
  const { container } = render(
    <Button onClick={onClick}/>,
  );
  fireEvent.click(container.firstChild);
  expect(mockCallBack).toHaveBeenCalledTimes(1);
  ```
  
- Chekc Value : 
  
  - `expect(container.firstChild.textContent).toEqual("✓");`
  
  - `expect(container.firstChild.textContent).not.toEqual("✓");`

- Check Attribute : `expect(getByText(TEXT)).toHaveAttribute("href", link);`

- Check Visible : `expect(getByText(TEXT)).toBeVisible();`

## Errors

- `warning: An update to Icon inside a test was not wrapped in act(...).`

  ```javascript
  import { waitFor } from "@testing-library/react";

  test("test1", async () => {
    // render component...
    await waitFor(() => {
      // trigger events
      // expect something
    });
  })
  ```

- `TypeError: MutationObserver is not a constructor ... await waitFor(()=>...`

  - Install pacakge `jest-environment-jsdom-sixteen`

    `yarn add -D jest-environment-jsdom-sixteen`

  - Change script `package.json`

    ```json
    "scripts": {
      ...
      "test": "jest --env=jest-environment-jsdom-sixteen"
    },
    ```

## Advaned

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
