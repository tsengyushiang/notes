# Nodejs API & Websocket

## Express

- [reference](https://expressjs.com/en/guide/routing.html)

- Route parameters

```javascript
app.get('/shortLink/:Id', (req, res) => {
  res.send(req.params)
})
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