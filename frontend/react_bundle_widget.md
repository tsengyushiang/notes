# React Bundle Widget

- [Reference](https://github.com/facebook/create-react-app/issues/3365#issuecomment-376546407)

## Setup develop project

- Create a react app.

```
npx create-react-app widget
```

- Create a `webpack.config.js`

```javascript
const path = require("path")
const UglifyJsPlugin = require("uglifyjs-webpack-plugin")
const glob = require("glob")

module.exports = {
  entry: {
    "bundle.js": glob.sync("build/static/?(js|css)/main.*.?(js|css)").map(f => path.resolve(__dirname, f)),
  },
  output: {
    filename: "build/static/js/bundle.min.js",
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
    ],
  },
  plugins: [new UglifyJsPlugin()],
}
```

- Update build command in `package.json`

```diff
-    "build": "react-scripts build",
+    "build": "npm run build:react && npm run build:bundle", 
+    "build:react": "react-scripts build", 
+    "build:bundle": "webpack --config webpack.config.js", 
```

- Install pacakges

```
yarn add -D uglifyjs-webpack-plugin webpack-cli
```

- Build javascript

```
yarn run build
```

## Test

- Add HTML in `./dist/build/static/js/index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Sandbox</title>
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="src/styles.css" />
  </head>

  <body>
    <h1>HTML/CSS/JS Scratch Template</h1>
    <div id="root"></div>
    <script src="http://localhost:8080/dist/build/static/js/bundle.min.js"></script>
  </body>
</html>
```

- Host static files with nginx

```
docker run --rm -it -v ./dist/build/static/js:/usr/share/nginx/html:ro -p 8080:80 nginx
```

- Visits http://localhost:8080/ to verify.