# GitHub

## CI/CD

- auto deploy gh-page `.github/workflows/AutoDeployGihubPage.yml`


```
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
          token: ${{ secrets.PAT }}
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

    - Set Personal Access Token to repo secret `PAT`.

        * right top icon > settings >  Developer settings > Personal access tokens (classic)
            - check repo
            - check workflow
            - copy token string

        * repo > settings > Secrets > Actions > New repository secret
        
            - named `PAT`
            - paste token string

## Backup

- Add Personal access tokens at `Settings/Developer/Personal access tokens`
- replace `tsengyushiang`, `1bb635a629d7d803c02af48188df34b710ec0786` and run backup shell:

    ```
    GHUSER=tsengyushiang; 
    curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+is:private" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone
    ```
- [search by something](https://docs.github.com/en/free-pro-team@latest/github/searching-for-information-on-github/searching-for-repositories)
