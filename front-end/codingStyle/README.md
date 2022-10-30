# Coding style

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
      "lint": "eslint --ignore-path .gitignore \"**/*.+(ts|js|tsx)\"",
  }
  ```
  
## Prettier

- packages

  ```
  yarn add -D prettier
  ```

- add `package.json` script

  ```json
  "scripts": {
      "format": "prettier --ignore-path .gitignore \"**/*.+(ts|js|tsx)\" --write",
  }
  ```

## Husky + Lint-staged

- Husky runs some script before git commit in following case we run prettier and check eslint, if eslint has error commit will not continue.
- Lint-staged filter files for command.
- packages

  ```
  yarn add -D husky lint-staged
  ```

- install husky and will create `.husky`

  ```
  npm set-script prepare "husky install"
  npm run prepare
  ```

- add script to run before commit

  ```
  yarn husky add .husky/pre-commit "yarn lint-staged"
  ```

- add script ot `package.json`

  ```
  "lint-staged": {
    "**/*.{ts,js,jsx,tsx}": [
      "yarn format",
      "yarn lint"
    ]
  },
  ```
