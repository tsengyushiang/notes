# Storybook

- [storybook](https://storybook.js.org/docs/get-started/frameworks/react-vite)
- [storybook-test-runner](https://github.com/piratetaco/storybook-test-runner)

## Setup storybook


### Installation

- Generate a new project.

```
npx storybook@latest init
```

- Add storybook to existed project.

```
npx create-react-app my-app
cd my-app
npx sb init
```

### Start storybook and visit

```
yarn storybook
```

> If `Error: spawn xdg-open ENOENT` error, change script to `    "storybook": "storybook dev -p 6006 --ci"`


### Interaction test

```javascript
import { expect, fn, userEvent, within } from '@storybook/test';
export const Test = {
  args: {
    // some props for this story
  },
  play: async ({ args, canvasElement }) => {
    const canvas = within(canvasElement);
    await userEvent.click(canvas.getByRole("button"));
    await expect(args.onClick).toBeCalled();
  }
};

```


## Setup storybook-test-runner


### Installation

```
yarn add @storybook/test-runner -D
npx playwright install
npx playwright install-deps
```

### Add script

`package.json`
```diff
{
  "scripts": {
+    "test-storybook": "test-storybook"
  }
}
```

### Run storybook

```
yarn storybook
```

### Run Tester

```
yarn test-storybook --url http://127.0.0.1:6006
```
