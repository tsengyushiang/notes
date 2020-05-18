## Build Desktop App with ReactJs & Electron

- `yarn global add electron`
- `yarn create react-app my-app`
- `yarn add -D electron-builder concurrently wait-on`
- `yarn add cross-env electron-is-dev`
- create entry point file `pulbic/electron.js` with following code

```
const { app, BrowserWindow } = require("electron");
const path = require("path");
const isDev = require("electron-is-dev");

function createWindow() {
  // Create the browser window.
  const win = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true
    }
  });

  // and load the index.html of the app.
  win.loadURL(
    isDev
      ? "http://localhost:3000"
      : `file://${path.join(__dirname, "../build/index.html")}`
  );

  // Open the DevTools.
  //win.webContents.openDevTools();
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// 有些 API 只能在這個事件發生後才能用。
app.whenReady().then(createWindow);

// Quit when all windows are closed.
app.on("window-all-closed", () => {
  // 在 macOS 中，一般會讓應用程式及選單列繼續留著，
  // 除非使用者按了 Cmd + Q 確定終止它們
  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  // 在 macOS 中，一般會在使用者按了 Dock 圖示
  // 且沒有其他視窗開啟的情況下，
  // 重新在應用程式裡建立視窗。
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
```

- replace `"private": true,` in `package.json` to

```
  "main": "public/electron.js",
  "description": "description",
  "author": "yushiang",
  "build": {
    "appId": "video.labeler"
  },
  "homepage": "./",
```

-replace `script` in `package.json` to

```
  "scripts": {
    "react-start": "react-scripts start",
    "react-build": "react-scripts build",
    "react-test": "react-scripts test",
    "react-eject": "react-scripts eject",
    "electron-build": "electron-builder",
    "build": "yarn react-build && yarn electron-build",
    "start": "concurrently \"cross-env BROWSER=none yarn react-start\" \"wait-on http://localhost:3000 && electron .\""
  },
```
- use hashRouter, and replace `href` to `link to`

## Electron-windows-store

- Before running the Electron-Windows-Store CLI, let's make sure we have all the prerequisites in place. You will need:  
  - Windows 10 with at least the Anniversary Update (if your Windows has been updated before 2018, you're good).
  - Windows 10 SDK (remeber path `C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64` need to input when build )
  - Node 8 or above (to check, run node -v)  
- To install this command line tool, get it directly from npm:
  ```
  npm install -g electron-windows-store
  ```
- Then, configure your PowerShell:
  ```
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
  ```
- To turn an Electron app into an AppX package, run:

  ```
  electron-windows-store `
    --input-directory dist\win-unpakced `
    --output-directory electron-windows-store `
    --package-version 1.0.0.0 `
    --package-name myelectronapp
  ```

  - cannot use `-` in `--package-name`

- double click to use `.appx` in `\electron-windows-store`
  - Obtain the Certificate that signed the App :
    - Right click on APPX file
    - Click Properties
    - Click Digital Signatures
    - Select Signature from the list
    - Click Details
    - Click View Certificate
    - Click Install Certificate
    - use opt `Local Machine` and `Trusted Root Certification Authorities`
## Publish to windows store
  - 必須建立icons,放於`.\Resources\`
    - Square 256x256 in .icns formate named `icon.icns`
    - Square 44x44 Logo named `SampleAppx.44x44.png`
    - Square 50x50 Logo named `SampleAppx.50x50.png`
    - Square150x150Logo named `Square150x150Logo.png`
    - Wide310x150Logo named `Wide310x150Logo.png` 

  - 登入[Microsoft partner](https://partner.microsoft.com/zh-tw/dashboard/products/9PGKRQ3BJQ98/submissions/1152921505689435130/packages)
    ```
    account :
      XXXXX@gmail.com
    password:
      XXXX
    ```
  - 用帳號內的設定(id,publisher...)重包 .appx
    ```
    electron-windows-store --input-directory dist/win-unpacked --output-directory electron-windows-store-build --package-version 1.0.1.0 --package-name hiSafeV3 --identity-name 38729NTUSTCGAL.hiSafeV3 --publisher-display-name NTUSTCGAL -a .\Resources\
    ```    
    - 目前版本號 : `--package-version 1.0.X.0` 
    - microsoft../產品管理/管理應用程式名稱 : `--package-name hiSafeV3`  
    - microsoft../產品管理/產品身分識別 : `--identity-name 38729NTUSTCGAL.hiSafeV3`
    - microsoft../產品管理/產品身分識別 : `--publisher-display-name NTUSTCGAL` 
    - icon資料夾 : `-a .\Resources\` 
   
  - 若是第一次build .appx, 可從`microsoft../產品管理/產品身分識別`找到`CN=???`
  - 已build過 .appx , 到系統中刪除以下檔案，再重新執行打包指令
    - `C:\Users\${username}\.electron-windows-store`   
    - `C:\Users\${username}\AppData\Roaming\electron-windows-store`
  - 結果會像是: 
    ```
    You need at least Node 4.x to run this script
      ? Did you download and install the Desktop App Converter? It is *not* required to run this tool.  No
      ? You need to install a development certificate in order to run your app. Would you like us to create one?  Yes
      Welcome to the Electron-Windows-Store tool!

      This tool will assist you with turning your Electron app into
      a swanky Windows Store app.

      We need to know some settings. We will ask you only once and store
      your answers in your profile folder in a .electron-windows-store
      file.

      ? Please enter your publisher identity:  CN=4EBFD6CC-159D-4063-A792-5D4C4A630614
      ? Please enter the location of your Windows Kit's bin folder:  C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362
      .0\x64    
    ```
## Error

- Cannot compute electron version from installed node modules - none of the possible electron modules are installed.
  - run `electron -v` in the terminal --> `v7.1.8` (example)
  - go to `package.json` and under "devDependencies" insert `"electron": "<your version>"` e.g. `"electron": "7.1.8"`

## API

- path isse when using extra file such as `dll`.

  - `package.json`

    ```
    "build": {
        "appId": "hiSafeV3",
        "extraResources": [
          "dll"
        ]
      },
    ```

  - `public/index.html`

    ```
    const path = require("path");

    //use to run int env - dev.
    const devPath = path.join(process.cwd(), "/");
    //use to run in env - prod.
    const buildPath = path.join(__dirname, "../../");

    const dllPath = buildPath;
    let abspath = dllPath + path;
    ```

  - `src/index.js`

    ```
    const path32 = "dll/32bit/aaeonEAPI.dll";
    const path64 = "dll/64bit/aaeonEAPI.dll";
    ```

## Reference

- https://www.youtube.com/watch?v=Cdu2O6o2DCg
- https://github.com/felixrieseberg/electron-windows-store
- https://www.bookstack.cn/read/electronjs-v7.0-zh/tutorial-windows-store-guide.md
