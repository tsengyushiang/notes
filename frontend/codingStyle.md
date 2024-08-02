# Coding Style

* [Eslint : check coding style.](#Eslint)
* [Prettier : format code](#Prettier)
* [Husky : run command when git commit.](#huskylint-staged)
* [Lint-staged : run command with specific files.](#huskylint-staged)
* [Dependency-cruiser : check architecture with rule and export graph.](#Dependency-cruiser)
* [jsinspect : Detect copy-pasted and structurally similar code.](#jsinspect)
* [Others](#Others)
  * [Node version](#node--npm-version)
  * [Nextjs import alias](#import-alias-for-nextjs)

## Eslint

- packages

  ```
  yarn add -D @babel/core @babel/eslint-parser eslint-config-prettier eslint-plugin-jest eslint-plugin-prettier
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
    "rules": {
      "react/prop-types": 0,
      "no-console": 0,
      "require-yield": 0, // for generator function
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
### Eslint plugins

- [eslint-plugin-simple-import-sort](https://github.com/lydell/eslint-plugin-simple-import-sort)

  - Installation
  
  ```
  yarn add -D eslint-plugin-simple-import-sort
  ```
  
  - Setup config
  
  ```diff
    "eslintConfig": {
  +   "plugins": [
  +     "simple-import-sort"
  +   ],
  +   "rules": {
  +     "simple-import-sort/imports": "error",
  +     "simple-import-sort/exports": "error"
  +   }
    },
  ```
  
## Prettier

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

## Husky+Lint-staged

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
## Dependency-cruiser

- [Dependency-cruiser document](https://github.com/sverweij/dependency-cruiser)

### Setup

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

### Export

```bash
npx depcruise ${target file/folder} --exclude node_modules --config .dependency-cruiser.json --output-type dot | dot -T svg > dependency-graph.svg
```

- Export markdown graph

```bash
npx depcruise ${target file/folder} --exclude node_modules --no-config --output-type plugin:dependency-cruiser/mermaid-reporter-plugin > mermaid.md
```
- High-Level Review

Use `--collapse` to ignore the implementation details of each file, so the result will only show the relationships between the children of `src` with the following command:

```bash
npx depcruise ${target file/folder} --exclude node_modules --no-config --collapse "^src/[^/]+" --output-type plugin:dependency-cruiser/mermaid-reporter-plugin > mermaid.md
```

### Validation

```
npx depcruise --validate .dependency-cruiser.json ${target file/folder}
```

### Issues

- [zsh: command not found: dot](https://github.com/sverweij/dependency-cruiser/issues/570#issuecomment-1042436703)

  - Mac can use `brew install graphviz` to install and re-run above command.
  - Run with docker `npx depcruise ${target file/folder} --exclude node_modules --no-config --output-type dot | docker run --rm -i nshine/dot dot -T svg > dependency-graph.svg`

- `ERROR: Extracting dependencies ran afoul of... pManifest.workspaces.map is not a function`

  - Defines yarn workspace in `package.json` may break route. 


## jsinspect

- [jsinspect document](https://github.com/danielstjules/jsinspect)

## Others

### Node & Npm version

- specify npm and node version in `package.json`
```json
"engines" : { 
  "npm" : ">=8.0.0 <9.0.0",
  "node" : ">=16.0.0 <17.0.0"
},
```

### Import Alias For Next.js

- Then import components with `import * from "@/components/.."` instead of `"../../components"`.

`jsconfig.json`

```json
{
 "compilerOptions": {
  "baseUrl": ".",
  "paths": {
    "@/components/*": ["components/*"],
  }
 }
}
```

- Additional settings for `jest`

`package.json`

```json
{
 "jest": {
  "moduleNameMapper": {
   "^@/(.*)$": "<rootDir>/$1"
  }
 }
}
```
