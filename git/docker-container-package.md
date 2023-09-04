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
COPY --from=builder /app/.next/static ./app/.next/static

# Link package to github repo
ARG user
ARG repo
LABEL org.opencontainers.image.source https://github.com/${user}/${repo}

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

- Get your `${PAT}` from [https://github.com/settings/tokens](https://github.com/settings/tokens)

```bash
docker login --username ${username} --password ${PAT} ghcr.io
```

### Build image

```bash
docker build . --build-arg user=${username} --build-arg repo=${reponame} -t ghcr.io/${username}/${reponame}:${version} --no-cache
```

### Push image

```bash
docker push ghcr.io/${username}/${reponame}
```

### Test Image

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
