# Vscode

## Git Graph

- package

    ```
    Name: Git Graph
    Id: mhutchie.git-graph
    Description: View a Git Graph of your repository, and perform Git actions from the graph.
    Version: 1.30.0
    Publisher: mhutchie
    VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph
    ```

## Prettier

- package

    ```
    Name: Prettier - Code formatter
    Id: esbenp.prettier-vscode
    Description: Code formatter using prettier
    Version: 9.9.0
    Publisher: Prettier
    VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode
    ```

- `.vscode/settings.json`

    ```
    {
        "editor.defaultFormatter": "esbenp.prettier-vscode", // 依專案中的 .prettierrc 設定檔格式化
        "editor.codeActionsOnSave": {
        "source.fixAll": true
        },
        "editor.formatOnSave": true, // 存檔時自動排版
        "editor.formatOnPaste": true // 貼上時自動排版
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
        "semi": true
    }
    ```
