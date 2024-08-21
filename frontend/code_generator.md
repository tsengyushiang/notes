# Code Generator

- [plopjs/plop](https://github.com/plopjs/plop?tab=readme-ov-file)


## Setup

### Installation

```
yarn add -D plop
```

Add script in `package.json`

```diff
{
  "scripts": {
+    "gen":"plop"
  },
}
```

### Configurations

Add plop config file `plopfile.mjs`

```javascript
export default function (plop) {
  plop.setGenerator("basics", {
    description: "this is a skeleton plopfile",
    prompts: [
      {
        type: "input",
        name: "name",
        message: "Input filename",
      },
      {
        type: "list",
        name: "method",
        message: "Choose a default method.",
        choices: ["GET", "POST", "PUT", "DELETE"],
      },
    ],
    actions: [
      {
        type: "add",
        path: "src/apis/{{boo name}}.ts",
        templateFile: "./templates/api.template.hbs",
      },
    ],
  });

  plop.setHelper("foo", (str) => str.toUpperCase());
  plop.setHelper("boo", (str) => `${str}.boo`);
  plop.setHelper("mutiArgs", (...args) => args.join('-'));
}

```

Add template files `/templates/api.template.hbs`

```
const foo = () => console.log("{{mutiArgs name method}}", "{{foo name}}", "{{boo name}}", "{{name}}");
```

## Run generator


Run `yarn gen` and input filename `test`.

```bash
root@78a8699225b5:/app# yarn gen
yarn run v1.22.22
$ plop
? Input filename test
✔  ++ /src/apis/test.boo.ts
Done in 2.86s.
```

Check file `src/apis/test.boo.ts` is generated.

```typescript
const foo = () => console.log("TEST", "test.boo", "test");
```
