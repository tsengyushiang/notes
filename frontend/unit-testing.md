# Unit Testing

## Setup

- Install from `package.json` settings then run `yarn`.

```json
{
  "scripts": {
    "test": "jest"
  },
  "devDependencies": {
    "@testing-library/jest-dom": "^5.8.0",
    "@testing-library/react": "^10.0.4",
    "@testing-library/user-event": "^14.4.3",
    "babel-jest": "^29.7.0",
    "jest": "^29.5.0",
    "jest-environment-jsdom": "^29.6.3",
  }
  "jest": {
    "testEnvironment": "jsdom",
    "transform": {
     "^.+\\.(js|jsx|ts|tsx)$": ["babel-jest", { "presets": ["next/babel"] }]
    }
  }
}
```

- Generate coverage report
    
```json
{
  "scripts": {
    "test-coverage": "jest --coverage",
  },
  "jest": {
    "collectCoverage": true,
    "collectCoverageFrom": [
      "**/*.js",
      "!**/styled.js"
    ],
    "coverageThreshold": {
    "global": {
        "statements": 100,
        "branches": 100,
        "functions": 100,
        "lines": 100
      }
    }
  }
}
```
  
- Run `yarn test` and find report at `/coverage/Icov-report/index.html`.

- Get report for single test, run `yarn test ${component}.test.js --coverage` and report will be logged in console.

## Quick start

### Test for UI

```javascript
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const setup = (jsx) => {
  return {
    user: userEvent.setup(),
    ...render(jsx),
    screen,
  };
};

describe("Testing <Foo/>", () => {
  test("should do something.", async () => {
    const { screen, user } = setup(<Foo />);
    screen.logTestingPlaygroundURL(); // this will help you get query syntex
    const foo = screen.getByText("foo");
    await user.click(foo);
    expect(screen.getByText("bar")).toBeInTheDocument();
  });
});
```

### Test for Redux-saga

```javascript
import { channel, runSaga } from "redux-saga";
import { ACTION_SUC } from "./constants/action";
import { foo } from "./redux/saga/foo";
import * as fooAPI from "./apis/foo";

jest.mock("./apis/foo", () => ({
  test: jest.fn(),
}));

const state = {};
const runSagaHelper = async (foo, payload) => {
  const mockChannel = channel();
  const dispatched = [];
  const saga = await runSaga(
    {
      channel: mockChannel,
      getState: () => state,
      dispatch: (action) => dispatched.push(action),
    },
    foo,
    payload,
  );

  mockChannel.put({ type: "YIELD_TAKE" });

  const response = await saga.toPromise();

  return { dispatched, response };
};

describe("Redux-saga foo/test", () => {
  test("should put ACTION_SUC when success", async () => {
    const payload = { payload: "payload" };
    const apiResponse = { data: "response" };
    fooAPI.test.mockImplementation(() => Promise.resolve(apiResponse));
    const { dispatched, response } = runSagaHelper(foo, payload);
    const [putSuccess] = dispatched;
    expect(fooAPI.test).toHaveBeenCalledWith(payload);
    expect(putSuccess).toEqual({
      type: ACTION_SUC,
      payload: apiResponse,
    });
    expect(response).toEqual(true);
  });
});
```

## Tips

### Multiple test cases

```javascript
test.each([
  ["error message 1", 1],
  ["error message 2", 2],
  ["error message 3", 3],
])(
  "should show %s when input is %s.",
  async (errorMessage, input) => {
    // test you code here.
  }
);
```

### Mock 

- Window

```javascript
describe('window.location', () => {
  const { location } = window;

  beforeAll(() => {
    delete window.location;
    window.location = { reload: jest.fn() };
  });

  afterAll(() => {
    window.location = location;
  });

  it('calls reload', () => {
    window.location.reload();
    expect(window.location.reload).toHaveBeenCalled();
  });
});
```

- Function
    
```javascript
const mockCallBack = jest.fn();

// mock console.log
const error = jest.spyOn(console, "error").mockImplementation(() => {});
```

- Component

```javascript
jest.mock("../../components/Icon", () => ({ type }) => type); // Parse type from Icon to text
```

```javascript
// If test component is <Icon type="cancel"/>
// Then we can get element like following code
const cancel = screen.getByText(/cancel/i);
```

- Package

  - mock in `__test__`
  
  ```javascript
  // __test__/components/test.js
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

  - mock in `__mocks__` and use in `__test__` without second parameter.

  ```javascript
  // __mocks__/react-i18next.js
  const i18n = jest.createMockFromModule("react-i18next");

  i18n.useTranslation = () => {
    return {
      t: (t) => t,
      i18n: {
        changeLanguage: () => new Promise(() => {}),
      },
    };
  };

  module.exports = i18n;
  ```
  ```javascript
  // __test__/components/test.js
  jest.mock("react-i18next");
  ```
- Redux hooks

  - add a `helper/redux.js`
  
  ```javascript
  import { useDispatch, useSelector } from "react-redux";

  export const mockReduxBeforeAll = () => {
    beforeEach(() => {
      useDispatch.mockClear();
      useSelector.mockClear();
    });
  };

  export const mockRedux = (mockState) => {
    const dispatchMock = jest.fn();
    useDispatch.mockReturnValue(dispatchMock);

    useSelector.mockImplementation((callback) => {
      return callback(mockState);
    });

    return dispatchMock;
  };
  ```
  
   - Use above `MockProvider` as a wrapper of your component in test script and give an `initialState`.

  ```javascript
  import { mockReduxBeforeAll, mockRedux } from "../../../helpers/redux";
  jest.mock("react-redux");

  describe("test description", () => {
    mockReduxBeforeAll();

    test("test.", async () => {
      const dispatchMock = mockRedux(initialState);

      // fire some user events

      expect(dispatchMock).toHaveBeenCalledWith(expectedResult);
    });
  });
  ```

### Query Element

- Find suggested query in browser with URL from `screen.logTestingPlaygroundURL();`

- Find a element not present in DOM with `queryBy` instead of `getBy`

```javascript
expect(screen.queryByText(/text/i)).not.toBeInTheDocument(); // find by text
expect(screen.queryByDisplayValue("123")).not.toBeInTheDocument(); // find by text for <Input/>
expect(document.querySelector("#reminderOptions_off")).not.toBeInTheDocument(); // find by element Id
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
  
  - Find non-character `key` in [source code](https://github.com/testing-library/user-event/blob/main/src/keyboard/keyMap.ts)
  - Use [key combination](https://testing-library.com/docs/user-event/keyboard/)

  ```javascript
  const input = screen.getByPlaceholderText(/password/i)
  // const input = screen.getByDisplayValue('123') 

  input.focus();
  await user.keyboard("123456"); //type
  await user.keyboard("{Control>}A{Delete}{/Control}8a867"); //type delete all and type
  ```

### Assertion

- Element

```javascript
const target = screen.getByRole(...)

// Attribute
expect(target).toHaveAttribute("href", link);

// Value
expect(target).toHaveValue(text);

// Visible
expect(target).toBeVisible();
expect(target).toBeInTheDocument();

// isFocused
expect(document.activeElement).toBe(target);
```

- Callback arguments

```javascript
const mockCallBack = jest.fn();

// check exactly equal
expect(mockCallBack).toHaveBeenCalledWith({ key : value });

// check at least some properties
expect(mockCallBack).toHaveBeenCalledWith(expect.objectContaining({ key : value }));
```

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
