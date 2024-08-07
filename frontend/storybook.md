# Storybook

- [storybook](https://storybook.js.org/docs/get-started/frameworks/react-vite)
- [storybook-test-runner](https://github.com/storybookjs/test-runner)
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
    // if element should wait for api, use "await canvas.findByText("button", undefined, { timeout: 5e3 });" to get the button.
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
### Arguments Mutation

- [reference](https://storybook.js.org/docs/writing-stories/args#setting-args-from-within-a-story)

```javascript
import { useArgs } from "@storybook/preview-api";

export const Page: Story = {
  args: {
    currentPage: 5,
    onChange: fn(),
  },
  render: (args) => {
    const [_, updateArgs] = useArgs();

    function onChange(_: any, page: number) {
      args.onChange(_, page);
      updateArgs({ currentPage: page });
    }

    return <Pagination {...args} onChange={onChange} />;
  },
};
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
        http.get(`${HOST}/use`, async ({ request }) => {
          const payload = await request.json();
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
npx playwright install --with-deps
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

- With running storybook
  
```
yarn test-storybook --url http://127.0.0.1:6006
```

- Start storybook and test with one command:

  - Installation

  ```
  yarn add -D concurrently http-server wait-on
  ```

  - Add script

  `package.json`
  ```diff
  {
    "scripts": {
  +    "test-storybook:ci": "concurrently -k -s first -n \"SB,TEST\" -c \"magenta,blue\" \"yarn build-storybook --quiet && npx http-server storybook-static --port 6006 --silent\" \"wait-on tcp:6006 && yarn test-storybook\""
    }
  }
  ```

### Coverage Report
  
- Installation
  
```
yarn add -D @storybook/addon-coverage
```

- Change script

`package.json`
```diff
{
  "scripts": {
    "test-storybook": "test-storybook"
+   "test-storybook:coverage": "test-storybook --coverage && npx nyc report --reporter=lcov -t coverage/storybook --report-dir coverage/storybook"
  }
}
```

- Convert report to lcov

```
npx nyc report --reporter=lcov -t coverage/storybook --report-dir coverage/storybook
```
