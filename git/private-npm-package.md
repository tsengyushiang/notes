# Private NPM Package


## Setup develop project

- Create a react app.

```
npx create-react-app package-dev
yarn add styled-components
```

- Develop components in `src/components` and export from `components/index.js`.

```javascript
import Button  from "./Button";

export { Button };
```

- Install `@babel/preset-env`(JSX Compiler), `@bable/preset-react`(ES5 parser) and other plugins such as styled-components.

```
yarn add -D @babel/cli @babel/preset-env @babel/preset-react cross-env babel-plugin-styled-components babel-preset-minify
``` 

- Add compile script in `package.json`.

```json
"scripts": {
  ...
  "compile": "rm -rf dist && cross-env NODE_ENV=production babel src/components --out-dir dist --copy-files"
}
```

- Add babel setting `babel.config.js`.

```javascript
module.exports = function (api) {
  api.cache(true);

  const presets = ["@babel/preset-env", "@babel/preset-react", "minify"];

  const plugins = [["styled-components"]];

  return {
    presets,
    plugins,
  };
};
```

- Config publish setting in `package.json` :

    - Babel will compile files to `dist`.
    - `registry: ...@tsengyushiang` is your github username.
    - `name: @tsengyushiang/react-ui` must match username and repository on github.
    - Update version `"version": "0.1.1"` if old version number is used.

```json
{   
    "name": "@tsengyushiang/react-ui",
    "version": "0.1.1",
    ...
    "main": "dist/index.js",
    "private": false,
    "files": [
      "dist",
      "README.md"
    ],
    "publishConfig": {
      "registry": "https://npm.pkg.github.com/@tsengyushiang"
    }
}
```

- finally, push your code to github.

## Config Github CI/CD

- Enable CI/CD write permission
    - Go `https://github.com/${username}/${repo_name}/settings/actions`
    - In `Workflow permissions` section, use `Read and Write permissions`

- Add script `.github\workflows`

```
name: Publish package to GitHub Packages
on:
  push:
    branches:
      - master
jobs:
  publish-package:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '16.x'
          registry-url: 'https://npm.pkg.github.com'
      - run: npm install
      - run: npm run compile
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Install package in other project


- Add a `.npmrc` file and replace following info with yours.

```
//npm.pkg.github.com/:_authToken=${TOKEN}
${USER_NAME}:registry=https://npm.pkg.github.com
```

- Install package with environment variables

```
TOKEN=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 USER_NAME=@tsengyushiang npm install  @tsengyushiang/react-ui@0.1.0
```