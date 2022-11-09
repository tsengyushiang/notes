# Coding Style

* [files changed](https://github.com/tsengyushiang/next.js/pull/3/files)
* Eslint : check coding style.
* Prettier : format code
* Husky : run command when git commit.
* Lint-staged : run command with specific files.

##  Eslint

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
        "trailingComma": "all",
        "tabWidth": 2,
        "semi": true,
        "importOrder": ["^components/(.*)$", "^[./]"],
        "importOrderSeparation": true,
        "importOrderSortSpecifiers": true
    }
    ```

## Husky + Lint-staged

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
