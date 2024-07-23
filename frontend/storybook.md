# Storybook

- [storybook](https://storybook.js.org/docs/get-started/frameworks/react-vite)
- [storybook-test-runner](https://github.com/piratetaco/storybook-test-runner)
- [msw-storybook-addon](https://storybook.js.org/addons/msw-storybook-addon)

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

> If `Error: spawn xdg-open ENOENT` error, change script to `storybook dev -p 6006 --ci`


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
### RWD Story

- Defines RWD breakpoints in `.storybook/preview.ts`.

```typescript
const customViewports = {
  Desktop: {
    name: "Desktop",
    styles: {
      width: "1280px",
      height: "720px",
    },
  },
  Mobile: {
    name: "Mobile",
    styles: {
      width: "768px",
      height: "720px",
    },
  },
};

const preview: Preview = {
  parameters: {
    viewport: {
      viewports: customViewports,
    },
  },
};
```

- Specify `defaultViewport` in story.

```typescript
export const Desktop: Story = {
  args,
  parameters: {
    viewport: {
      defaultViewport: "Desktop", // or "Mobile"
    },
  },
};
```
### Decorator for react-router-dom

```javascript
import { MemoryRouter } from "react-router-dom";

const meta = {
  title: "Components/Router",
  component: Router,
  decorators: [
    (Story) => (
      <MemoryRouter initialEntries={["/"]}>
        <Story />
      </MemoryRouter>
    ),
  ],
}
```
## Setup Mock Service Worker

### Installation

- Run commands to add packages.

```
yarn add msw msw-storybook-addon -D
npx msw init public/
```

- Initialize in `./storybook/preview.js`

```javascript
import { initialize, mswLoader } from 'msw-storybook-addon'

// Initialize MSW
initialize()

const preview = {
  parameters: {
    // your other code...
  },
  // Provide the MSW addon loader globally
  loaders: [mswLoader],
}

export default preview
```

### Mock Api in stories

```javascript
import { http, HttpResponse } from 'msw'

export const Demo = {
  args: {
    // others props for components
  },
  parameters: {
    msw: {
      handlers: [
        http.get(`${HOST}/use`, () => {
          return HttpResponse.json({
            foo: 'foo',
          })
        }),
      ],
    },
  },
}
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
