# Monorepo

## Yarn workspace

- Add packages folder configs to `package.json`.

```json
{
  "private": true,
  "workspaces": {
    "packages": [
      "packages/*"
    ],
    "nohoist": []
  },
}
```

- Create package folder

```
mkdir packages/core
```

- Config `pacakge.json` of workspace

```json
{
  "name": "@my-workspace/core",
  "version": "1.0.0"
}
```

- Add sample function to ensure it works

`index.js`
```javascript
function foo() {
  console.log("hello workspace");
}

export default foo;
```

`index.d.ts`
```typescript
declare function foo(): void;
export default foo
```

- Install worksapce pacakge in main project

```
yarn -W add @my-workspace/core@1.0.0
```

```json
{
  "dependencies": {
+    "@my-workspace/core": "1.0.0"
  }
}
```

- Import package in apps.

```javascript
import foo from "@my-workspace/core"

foo()
```

## Nx

To start a development environment using Docker, run:

```sh
sudo docker run -it --rm -w /app -v ./:/app -p 3000:3000 node:20 bash
```

To create a new Nx workspace with Next.js using Yarn as the package manager, run:

```sh
npx create-nx-workspace@latest --preset=next --packageManager=yarn
```

To generate a new shared component library in your Nx workspace, run:

```sh
nx g @nx/react:lib libs/ui
```

To support multiple entry points for the library, add the following settings (e.g., `import { useHooks } from '@test/ui/hooks';`)

`./libs/ui/package.json`
```diff
{
  "exports": {
+   "./hooks": {
+     "development": "./src/hooks.ts",
+     "types": "./dist/hooks.d.ts",
+     "import": "./dist/hooks.js",
+     "default": "./dist/hooks.js"
+   }
  }
}
```

`libs/ui/vite.config.ts`
```diff
export default defineConfig(() => ({
    lib: {
      // Could also be a dictionary or array of multiple entry points.
-     entry: 'src/index.ts',
+     entry: ['src/index.ts', 'src/hooks.ts'],
    },
    rollupOptions: {
+     output: {
+       entryFileNames: () => `[name].js`,
+     },
    },
  },
}));

```



To generate an individual storybook project for components, run:

```sh
nx g @nx/react:application apps/docs
nx add @nx/storybook
nx g @nx/storybook:configuration @test/docs
```


