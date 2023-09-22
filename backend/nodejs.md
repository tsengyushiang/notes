# Nodejs

## Cookies

- `httpOnly`  attribute is used with cookies to restrict access from the client side.

```javascript
ctx.res.cookie("token", token, { httpOnly: true });
```

## Headers

### Access-Control-Allow-Origin

- Make api available to differenct hostname.

```javascript
const cors = require('cors');
const app = express();
app.use(cors());
```

### Access-Control-Expose-Headers

- Make browser available to read headers.

```javascript
app.use(cors({
    exposedHeaders: ['Content-Disposition']
}));
```

- Read filename from header of download api.

```javascript
fetch("/download").then(async (res) => {
  const filename = res.headers
    .get("Content-Disposition")
    .match(/filename="(?<filename>.*?)"/);

  return {
    filename: filename.groups.filename,
    file: await res.blob(),
  };
});
```

## Express

- [reference](https://expressjs.com/en/guide/routing.html)

- Simple server

```javascript
const express = require('express');
const app = express();
const port = 8000
app.listen(port, () => {
  console.log(`app listening on port ${port}`)
})
```

- Route parameters

```javascript
app.get('/shortLink/:Id', (req, res) => {
  res.send(req.params)
})
```

- Download file

```javascript
app.get('/download', function(req, res) {
  res.download('./file.txt','download.txt');
});
```

## Websocket

- [reference](https://eudora.cc/posts/220105/)

- project setup

```
npm init -y
npm install express ws
```

- add `app.js` with following sample code and run `node app.js`

```javascript
const express = require('express')
const SocketServer = require('ws').Server
const PORT = 3000

const server = express().listen(PORT, () => {
    console.log(`Listening on ${PORT}`)
})

const wss = new SocketServer({ server })
wss.on('connection', ws => {
    console.log('Client connected')

    ws.on('message', data => {
        data = data.toString()  
        console.log(data)

        ws.send(data)

        wss.clients.forEach(client => {
            client.send(data)
        })
    })

    ws.on('close', () => {
        console.log('Close connected')
    })
})
```

- connect websocket in client :

    - [online testing tool](https://socketsbay.com/test-websockets)

    - vanila javascript 
    
    ```javascript
    const ws = new WebSocket('ws://localhost:3000')

    ws.onopen = () => {
        console.log(ws.readyState)
    }
    ws.onclose = () => {
        console.log(ws.readyState);
    }
    ws.onmessage = event => {
        console.log(JSON.parse(event.data))
    }

    // ws.close() //close websocket
    ```
