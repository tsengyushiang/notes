# Vscode


## Git 

### Graph

```
Name: Git Graph
Id: mhutchie.git-graph
Description: View a Git Graph of your repository, and perform Git actions from the graph.
Version: 1.30.0
Publisher: mhutchie
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph
```

### Changes

```
Name: GitLens — Git supercharged
Id: eamodio.gitlens
Description: Supercharge Git within VS Code — Visualize code authorship at a glance via Git blame annotations and CodeLens, seamlessly navigate and explore Git repositories, gain valuable insights via rich visualizations and powerful comparison commands, and so much more
Version: 13.0.4
Publisher: GitKraken
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens
```

## Coding Style

### Spell Checker

```
Name: Code Spell Checker
Id: streetsidesoftware.code-spell-checker
Description: Spelling checker for source code
Version: 2.11.1
Publisher: Street Side Software
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker
```

### Prettier

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
