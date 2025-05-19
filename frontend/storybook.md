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

### Global Decorators

- [reference](https://github.com/storybookjs/storybook/discussions/17766)
- Rename `preview.ts` to `preview.tsx` and add following content.

```javascript

const loginCookiesDecorator = (Story) => {
  document.cookie = "authToken=mock_token; path=/; SameSite=None; Secure";
  // clear cookie
  // document.cookie = "authToken=; path=/; SameSite=None; Secure";
  return <Story />;
};

const localStorageResetDecorator = (Story) => {
  window.localStorage.clear();
  return <Story />;
};

const TimeFeezeDecorator = (Story: any) => {
  Date.now = () => new Date("2024-08-10T09:27:45.000Z").getTime();
  return <Story />;
};

export const decorators = [localStorageResetDecorator, TimeFeezeDecorator, loginCookiesDecorator];
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

const mockPost = http.post(`${HOST}/post/api/:id`, async ({ request, params }) => {
  const id = params.id;
  const payload = await request.json();
  return HttpResponse.json({
    foo: "foo",
  });
});

const mockGet = http.get(`${HOST}/get/api`, async ({ request, cookies }) => {
  if (!cookies.authToken) {
    return HttpResponse.json("auth failed", {
      status: 400,
    });
  }
  const url = new URL(request.url);
  const param = url.searchParams.get("id");
  return HttpResponse.json({
    foo: param,
  });
});

export const Demo = {
  args: {
    // others props for components
  },
  parameters: {
    msw: {
      handlers: [mockPost, mockGet],
    },
  },
};
```

### Mock Websocket in stories

> Only available in the work-in-progress version `msw@next`.

- [reference](https://github.com/mswjs/msw/discussions/2010)

```javascript
import { ws } from 'msw'

const websocketHandler = (() => {
  const chat = ws.link("ws://localhost:3000");
  return chat.on("connection", ({ client }) => {
    client.send("hello client");
    client.addEventListener("message", (event) => {
      console.log(event); //message from client
    });
    client.addEventListener("close", () => console.log("cleanup"));
  });
})();

export const Demo = {
  args: {
    // others props for components
  },
  parameters: {
    msw: {
      handlers: [websocketHandler],
    },
  },
};
```

### Mock in Production

```javascript
import { HttpHandler } from "msw";
import { setupWorker } from "msw/browser";

const handlers: Array<HttpHandler> = [];

const worker = setupWorker(...handlers);

worker
  .start({
    serviceWorker: {
      url: `/${baseURL}/mockServiceWorker.js`,
    },
  })
  .then(() => {
    const root = ReactDOM.createRoot(
      document.getElementById("root") as HTMLElement,
    );
    root.render(<App />);
  });
```

### Mock in Server Side (Nextjs 15)

`./mock/server`
```javascript
import { setupServer } from "msw/node";
const handlers = [];
export const server = setupServer(...handlers);
```

`instrumentations.js`
```javascript
export async function register() {
  if (process.env.NEXT_RUNTIME === "nodejs") {
    const { server } = await import("./mock/server");
    server.listen();
  }
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
+    "test-storybook": "test-storybook --testTimeout=60000"
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

- Define the coverage threshold by creating a `.nycrc` file with the following content:

```
{
  "exclude": ["src/exclude/**"],
  "all": true,
  "check-coverage": true,
  "branches": 80,
  "functions": 80,
  "lines": 80,
  "statements": 80
}
```
