# Nginx

- [reference](https://www.youtube.com/watch?v=QMa0Q1Dg2KU)


## Demo Files

```
.
├── docker-compose.yml
├── nodedocker_app
|   ├── app.js
|   └── dockerfile
└── nginx
    ├── default.conf
    └── dockerfile
```

- `docker-compose.yml`
```
version: '3'

services:
    nodejs-app:
        build:
          context: ./nodedocker_app
        hostname: nodejsserver

    nginx:
        build:
          context: ./nginx
        ports:
            - "80:80"

networks:
    default:
        name: nginx-node-demo
        external: false
```

- `nginx/dockerfile` : copy setting to container
```
FROM nginx
COPY ./default.conf /etc/nginx/conf.d/
```
- `nginx/default.conf`: redriect `/` to `nodejsserver:8888` which is defined in `docker-compose.yml`
```
server {
  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_pass http://nodejsserver:8888;
  }
}
```

- `nodedocker_app/app.js`
```
const http = require('http');
const requestListener = function (req, res) {
  res.writeHead(200);
  res.end('Hello, World!');
}
const server = http.createServer(requestListener);
server.listen(8888);
```

- `nodedocker_app/dockerfile`
```
FROM node:14
WORKDIR /usr/src/app
COPY app.js /usr/src/app/
EXPOSE 8888
CMD [ "node", "app.js" ]
```

## Qucik start

```
docker-compose up
```