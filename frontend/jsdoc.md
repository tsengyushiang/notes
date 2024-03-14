# Jsdoc

## Introduction

### Setup

- Install pacakge [jsdoc](https://github.com/jsdoc/jsdoc)

```
yarn add -D jsdoc
```

- Add script into `package.json`

```json
"scripts": {
    "build:doc": "yarn run jsdoc -c jsdoc.json -R ./README.md"
},
```

- Add build config `jsdoc.json`

```json
{
  "opts": {
    "destination": "../static/doc/" // target to save build result
  },
  "source": {
    "include": "./src/" // where is your scripts
  },
  "templates": {
    "default": {
      "outputSourceFiles": false // disable build styles
    }
  }
}

```

### Plugins

- [clean-jsdoc-theme](https://github.com/ankitskvmdam/clean-jsdoc-theme)
- [jsdoc-to-markdown](https://github.com/jsdoc2md/jsdoc-to-markdown)


## Syntax


### Enum & Namespace

```javascript
/**
 * A namespace.
 * @namespace Constants
 */

/**
 * Enum for CONSTANTS values.
 * @readonly
 * @enum {string}
 * @memberof Constants
 */
const KEYS = {
  KEY: "VALUE",
};
```
> Use inilne export `export const KEYS...` will break jsdoc, use `export { KEYS };` instead.

### Class

```javascript
/** @class */
class Demo {
  /**
   * This member is utilized in {@link Demo#foo}.
   * @type {object}
   * @property {Constants.KEYS} name
   */
  boo = {
    name: "hello world",
  };
  /**
   * This method will use value of {@link Demo#boo} as param.
   * @param {Object} options
   * @param {Constants.KEYS} options.name - some description of this param
   * @return {string}
   * @example
   * const demo = new Demo()
   * demo.foo('name');
   */
  foo({ name }) {
    return `print ${name}`;
  }
}
```