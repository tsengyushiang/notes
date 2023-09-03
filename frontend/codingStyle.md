# Coding Style

* [Eslint : check coding style.](#Eslint)
* [Prettier : format code](#Prettier)
* [Husky : run command when git commit.](#Husky&Lint-staged)
* [Lint-staged : run command with specific files.](#Husky&Lint-staged)
* [Dependency-cruiser : check architecture with rule and export graph.](#Dependency-cruiser)
* [jsinspect : Detect copy-pasted and structurally similar code.](#jsinspect)
* [Others](#Others)
  * Node version
  * Nextjs import alias

# Eslint

- packages

  ```
  yarn add -D @babel/core @babel/eslint-parser babel-plugin-styled-components eslint-config-prettier eslint-plugin-jest eslint-plugin-prettier
  ```

- `.eslintrc` or `.eslintrc.json` (choose one) 

  ```json
  {
    "env": {
      "browser": true,
      "commonjs": true,
      "es6": true,
      "node": true,
      "jest": true
    },
    "extends": [
      "eslint:recommended",
      "plugin:react/recommended",
      "plugin:react/jsx-runtime",
      "plugin:prettier/recommended"
    ],
    "globals": {
      "React": "writable"
    },
    "parser": "@babel/eslint-parser",
    "parserOptions": {
      "ecmaVersion": 2021,
      "ecmaFeatures": {
        "jsx": true,
        "arrowFunctions": true
      },
      "sourceType": "module"
    },
    "settings": {
      "react": {
        "version": "detect"
      }
    },
    "plugins": [
      "react",
      "jest",
      "prettier"
    ],
    "rules": { // 若專案有加入其他規則請在 README 裡告知為何使用
      "react/prop-types": 0,
      "no-console": 0,
      "require-yield": 0, // 給 sagas 的設定
      "prettier/prettier": ["error", {"jsxSingleQuote": false}]
    }
  }
  ```

- `.eslintignore`

  ```
  **/node_modules/**
  **/public/**
  **/__mocks__/**
  **/.next
  **/next-env.d.ts
  **/next.config.js
  **/_app.js
  **/_document.js
  ```

- `.babelrc`

  ```json
  {
    "presets": [
      [
        "next/babel",
        {
          "preset-env": {
            "useBuiltIns": "usage",
            "corejs": 3
          }
        }
      ]
    ],
    "plugins": [["styled-components", { "ssr": true, "preprocess": false }]]
  }
  ```

- add `package.json` script

  ```json
  "scripts": {
      "eslint": "eslint \"./**/*.+(ts|js|tsx)\" --fix",
  }
  ```
- run eslint checking

  ```bash
  // warning is ok
  yarn eslint

  // all warning should be resolved 
  yarn eslint --max-warnings=0
  ```
  
# Prettier

- packages

  ```
  yarn add -D prettier @trivago/prettier-plugin-sort-imports
  ```

- add `package.json` script

  ```json
  "scripts": {
      "format": "prettier \"./**/*.+(ts|js|tsx)\" --write",
  }
  ```

- `.prettierignore`

    ```
    **/.next
    **/public
    **/static
    **/node_modules
    **/dist
    **/package.json
    **/yarn.lock
    **/package-lock.json
    **/.eslintrc
    **/tsconfig.json
    ```

- `.prettierrc`

    ```
    {
        "trailingComma": "all",
        "tabWidth": 2,
        "semi": true,
        "importOrder": ["^[./]"],
        "importOrderSeparation": true,
        "importOrderSortSpecifiers": true
    }
    ```

# Husky&Lint-staged

- Husky runs some script before git commit in following case we run prettier and check eslint, if eslint has error commit will not continue.
- Lint-staged filter files for command.
- packages

  ```
  yarn add -D husky lint-staged
  ```

- install husky and will create `.husky` and add script

  ```
  yarn husky install
  yarn husky add .husky/pre-commit "yarn lint-staged"
  ```

- add above "lint-staged" script ot `package.json`

  ```
  "lint-staged": {
    "**/*.{ts,js,jsx,tsx}": [
      "yarn format",
      "yarn lint"
    ]
  },
  ```
# Dependency-cruiser

- [Dependency-cruiser document](https://github.com/sverweij/dependency-cruiser)

## Setup

- Install package `yarn add -D dependency-cruiser`

- Add rule config `.dependency-cruiser.json`, [find or rule example in documents](https://github.com/sverweij/dependency-cruiser/blob/develop/doc/rules-tutorial.md)

```json
{
  "forbidden": [
    {
      "name": "Bad Import",
      "comment": "Import container from component folder make components more complex.",
      "severity": "error",
      "from": { "path": "^components" },
      "to": {
        "path": "^containers"
      }
    }
  ]
}
```

## Export

```bash
npx depcruise ${target file/folder} --exclude node_modules --config .dependency-cruiser.json --output-type dot | dot -T svg > dependency-graph.svg
```

- Export markdown graph

```bash
npx depcruise ${target file/folder} --exclude node_modules --no-config --output-type plugin:dependency-cruiser/mermaid-reporter-plugin > mermaid.md`
```

## Validation

```
npx depcruise --validate .dependency-cruiser.json ${target file/folder}
```

## Issues

- [zsh: command not found: dot](https://github.com/sverweij/dependency-cruiser/issues/570#issuecomment-1042436703)

  - Mac can use `brew install graphviz` to install and re-run above command.
  - Run with docker `npx depcruise ${target file/folder} --exclude node_modules --no-config --output-type dot | docker run --rm -i nshine/dot dot -T svg > dependency-graph.svg`

# jsinspect

- [jsinspect document](https://github.com/danielstjules/jsinspect)

# Others

## Node & Npm version

- specify npm and node version in `package.json`
```json
"engines" : { 
  "npm" : ">=8.0.0 <9.0.0",
  "node" : ">=16.0.0 <17.0.0"
},
```

## Import Alias For Next.js
  
- `jsconfig.json`

```
{
    "compilerOptions": {
      "baseUrl": ".",
      "paths": {
        "@/components/*": ["components/*"],
      }
    }
  }
```
- Then import components with `import * from "@/components/.."` instead of `"../../components"`.

