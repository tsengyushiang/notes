# Vscode

## Setting

- add `.vscode/settings.json` in working directory

## SSH

```
Name: Remote Development
Id: ms-vscode-remote.vscode-remote-extensionpack
Description: An extension pack that lets you open any folder in a container, on a remote machine, or in WSL and take advantage of VS Code's full feature set.
Version: 0.25.0
Publisher: Microsoft
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
```
```
Host env-local
  HostName localhost
  User ubuntu

Host env-remote
  HostName 11.111.11.11
  User ubuntu
  Port 23

Host env-ec2
  HostName domain.com
  User ubuntu
  IdentityFile "C:\Users\${USER_NAME}\.ssh\${PEM_NAME}.pem"
```

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

- commitOrdering

    - `"git-graph.commitOrdering":"date"` (default)

    - `"git-graph.commitOrdering":"topo"`

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

### CodeMetrics

```
Name: CodeMetrics
Id: kisstkondoros.vscode-codemetrics
Description: Computes complexity in TypeScript / JavaScript files.
Version: 1.26.1
Publisher: Kiss Tamás
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=kisstkondoros.vscode-codemetrics
```

### File Dependency Graph

```
Name: Dependency Cruiser Extension
Id: juanallo.vscode-dependency-cruiser
Description: Visual Studio Code Extension to build dependency graphs using dependency-cruiser. Visualize module dependencies from any file
Version: 0.0.1
Publisher: juanallo
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=juanallo.vscode-dependency-cruiser
```
- Right click file to get dependency graph.

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

```json
{
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.codeActionsOnSave": {
    "source.fixAll": true
    },
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true
}
```

```bash
mkdir .vscode
curl https://raw.githubusercontent.com/tsengyushiang/notes/master/vscode/settings.json --output ./.vscode/settings.json
echo .vscode >> .gitignore
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

## Documents

### Markdown Preview Mermaid Support
```
Name: Markdown Preview Mermaid Support
Id: bierner.markdown-mermaid
Description: Adds Mermaid diagram and flowchart support to VS Code's builtin markdown preview
Version: 1.17.3
Publisher: Matt Bierner
VS Marketplace Link: https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid
```
