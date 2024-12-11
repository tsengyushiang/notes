# Package Manager

## Yarn

- Start on local network `yarn start --host 0.0.0.0`
- Check vulnerability by `yarn audit` and upgrade related packages to fix them. If the official package hasn't been updated, we can fix it ourselves.
  
```diff
{
  "devDependencies": {
  },
+ "resolutions": {
+   "nanoid": "^5.0.9"
+ }
}
```

## NVM

- Install form [nvm github](https://github.com/nvm-sh/nvm)

- Commands :
  - `nvm ls`
  - `nvm install <node version>`
  - `nvm use <node version>`
  - `nvm alias default <node version>`

- Refernce : [tutorial](https://www.casper.tw/development/2022/01/10/install-nvm/)

## Script

### Open Browser
```json
{
  "scripts": {
    "open-browser-nix": "open http://localhost:3000/home",
    "open-browser-windows": "start http://localhost:3000/home",
    "open-browser": "yarn open-browser-nix || yarn open-browser-windows",
    "dev": "yarn open-browser && next dev",
}
```

### Init Submodules and packages

```json
{
  "scripts": {
    "setup": "git submodule init && git submodule update && yarn",
}
```
