# Vercel

## Prerequisites

- [Node](https://nodejs.org/en/), [Nextjs app](https://nextjs.org/docs/getting-started)

```
$ npx -v
6.14.13

$ npx create-next-app@latest
```

## Deploy with CLI

- Install Vercel Locally

    ```
    $ npm i -g vercel
    $ vercel -v
    Vercel CLI 28.10.1
    28.10.1
    ```

- Token

    - go [vercel tokens page](https://vercel.com/account/tokens) to create a token `EsI73PNCtxqT72GtUTZgtydf`, denotes as `$VERCEL_TOKEN` in following commands.

- Create Vercel Project

    ```
    vercel pull --yes --token=$VERCEL_TOKEN
    ```

- Deploy

    - preview environment
    
        ```
        vercel deploy --token=$VERCEL_TOKEN
        ```
        
    - production environment
    
        ```
        vercel deploy --prod --token=$VERCEL_TOKEN
        ```

## GitLab CI/CD

1. Add Vercel Token to CI/CD variables

    - visit `https://gitlab.com/${user}/${project}/-/settings/ci_cd`

        - add vercel token with key `$VERCEL_TOKEN` and unchecked `protect variable`

2.  Add script `.gitlab-ci.yml` to main branch

    ```
    default:
      image: node:16.16.0

    deploy_preview:
      stage: deploy
      only:
        - preparing
      script:
        - npm install --global vercel
        - vercel pull --yes --environment=preview --token=$VERCEL_TOKEN
        - vercel build --token=$VERCEL_TOKEN
        - vercel deploy --prebuilt --token=$VERCEL_TOKEN

    deploy_production:
      stage: deploy
      only:
        - main
      script:
        - npm install --global vercel
        - vercel pull --yes --environment=production --token=$VERCEL_TOKEN
        - vercel build --prod --token=$VERCEL_TOKEN
        - vercel deploy --prebuilt --prod --token=$VERCEL_TOKEN
    ```

## Github CICD

1. Create token at [Vercel Perconal Account Setting page](https://vercel.com/account/tokens)

3. Add PAT at `Repo > settings > Secrets > Actions > New repository secret`
      - Add token from step 1. as `VERCEL_TOEKN`.
      - If you can't find the setting page, try https://github.com/${username}/${reponame}/settings/secrets/actions.

3. add CI/CD script `.github/workflows/vercel.yml` to `main` branch

```
name: vercel

on:
  push:
    branches: [ preparing ]

jobs:
  build:

    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [16.x]
        
    steps:
    - uses: actions/checkout@v3
    - run: |
          npm install --global vercel
          vercel pull --yes --environment=preview --token=${{ secrets.VERCEL_TOEKN }}
          vercel deploy --token=${{ secrets.VERCEL_TOEKN }}
```

4. push your code to branch `preparing` and check vercel dashborad.

# Reference

- [youtube tutorial](https://www.youtube.com/watch?v=4DbNUJ-9_U4)
- [GitLab CD](https://vercel.com/guides/how-can-i-use-gitlab-pipelines-with-vercel#configuring-gitlab-ci/cd-for-vercel)
