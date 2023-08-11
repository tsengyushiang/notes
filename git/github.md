# GitHub

## Continuous integration (CI)

### Run Script

- Add a ci script `.github/workflows/test.yml`

```yml
name: Test

on:
  pull_request:
    branches:
      - main
      - dev

jobs:
  build:
    name: eslint
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16]

    steps:
      - uses: actions/checkout@v1
      - name: run test
        run: |
          node --version
          yarn install
          yarn lint
```

- [Enforce Checks Before Merging](https://docs.lacework.net/iac/enforce-merge-checks)
  - Go to your GitHub repository.
  - Click the **Settings** tab at the top.
  - Click **Branches** on the left panel to display the branch protection rule page.
  - Under Protect matching branches, select **Require status check to pass before merging**.

### Github page

- add a ci script `.github/workflows/DeployGihubPage.yml`

```yml
name: DeployGihubPage

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
          node-version: [16.x]

    steps:
      - uses: actions/checkout@v3
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
      - run: |
          echo "NEXT_PUBLIC_REPO=${{ github.repository }}" > .env
          npm install
          npm run export
          touch ./out/.nojekyll
          git config --global user.email "github@example.com"
          git config --global user.name "git workflows"
          git add out/ -f
          git commit -m "Deploy gh-pages"          
          #git subtree push --prefix out origin gh-pages
          git subtree split --prefix out -b gh-pages
          git push -f origin gh-pages:gh-pages
          git branch -D gh-pages
```
- make sure your web pages load resocure from `'/${repo-name}/${resources...}'` instead of `'/${resource}'`
  
  - Option1 : add `"homepage":"https://${username}.github.io/${repo name}/",` to `package.json`.
  - Option2 : set `assetPrefix`, `basePath` of `next.config.js` or `webpack.config.js`..

## Backup

- Add Personal access tokens at `Settings/Developer/Personal access tokens`
- replace `tsengyushiang`, `1bb635a629d7d803c02af48188df34b710ec0786` and run backup shell:

    ```
    GHUSER=tsengyushiang; 
    curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+is:private" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone
    ```
- [search by something](https://docs.github.com/en/free-pro-team@latest/github/searching-for-information-on-github/searching-for-repositories)
