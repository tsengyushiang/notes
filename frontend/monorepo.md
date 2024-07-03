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