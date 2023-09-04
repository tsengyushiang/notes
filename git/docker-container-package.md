# Docker container package

## Prepare Dockerfile

`Dockerfile` for nextjs as example, follows [this nextjs issue](https://github.com/vercel/next.js/discussions/39432#discussioncomment-3664014) to fix in later version.

```dockerfile
# Stage 1: Build the application
FROM node:18-alpine as builder

# Set the working directory
WORKDIR /app

# Set environment variables
ENV NODE_ENV production

# Copy source code
COPY ./ ./

# Install and build
RUN yarn && yarn build

# Stage 2: Create the final image
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next/standalone ./app
COPY --from=builder /app/public ./app/public
COPY --from=builder /app/.next/static ./app/.next/static

# Link package to github repo
ARG repo
LABEL org.opencontainers.image.source https://github.com/${repo}

# Expose port 3000
EXPOSE 3000

# set hostname to localhost
ENV HOSTNAME "0.0.0.0"

# CMD to start the application
CMD ["node", "app/server.js"]
```

`.dockerignore`

```
/node_modules

.env.local
.env.development.local
.env.test.local
.env.production.local
```

`next.config.js`

```javascript
module.exports = {
  output: 'standalone',
}
```

## Deploy from local

### Login

- Get your `${PAT}` from [https://github.com/settings/tokens](https://github.com/settings/tokens) with `write:packages` permission.

```bash
docker login --username ${username} --password ${PAT} ghcr.io
```

### Build image

```bash
docker build . --build-arg repo=${username}/${reponame} -t ghcr.io/${username}/${reponame}:${version} --no-cache
```

### Push image

```bash
docker push ghcr.io/${username}/${reponame}
```

### Test Image

- Logout

```bash
docker logout
```

- Remove existed image.

```bash
> docker images

REPOSITORY                        TAG           IMAGE ID       CREATED             SIZE
ghcr.io/${username}/${reponame}   latest        14740a153484   9 minutes ago       511MB

> docker image rm 1474
```

- Run container

```bash
docker run -d -p 3000:3000 ghcr.io/${username}/${reponame}:${version}
```

## Deploy from Github CI


### Add Write Package Permission PAT To Repo Secrets

- Add your `PAT` at [https://github.com/${username}/${reponame}/settings/secrets/actions]() and named it `WRITE_PACKAGE_TOKEN`.

### Github CI Yml

Add `.github\workflows\container.yml` to deploy image when push a tag.

```yml
name: Publish package to GitHub Packages
on:
  push:
    tags:
      - '*'
jobs:
  publish-package:
    runs-on: ubuntu-latest
    permissions:
      packages: write
    steps:
      - uses: actions/checkout@v3
      - run: |
          docker login --username ${{ github.actor }} --password ${{ secrets.WRITE_PACKAGE_TOKEN }} ghcr.io
          docker build . --build-arg repo=${{ github.repository }} -t ghcr.io/${{ github.repository }}:${{ github.ref_name }} --no-cache
          docker push ghcr.io/${{ github.repository }}:${{ github.ref_name }}
          docker tag ghcr.io/${{ github.repository }}:${{ github.ref_name }} ghcr.io/${{ github.repository }}:latest
          docker push ghcr.io/${{ github.repository }}:latest
```
