# NextJs

## Quick start


- [Install Node](https://nodejs.org/en/)
- [Create Nextjs app](https://nextjs.org/docs/getting-started)

```
$ npx -v
6.14.13

$ npx create-next-app@latest
```

## Custom server

- [official document](https://nextjs.org/docs/advanced-features/custom-server)

- change dev script in `package.json`

    ```
    "scripts": {
        "dev": "node server.js",
    },
    ```

- add `server.js` and install package `yarn add express`

    ```javascript
    const express = require('express')
    const next = require('next')

    const port = parseInt(process.env.PORT, 10) || 3000
    const dev = process.env.NODE_ENV !== 'production'
    const app = next({ dev })
    const handle = app.getRequestHandler()

    app.prepare()
    .then(() => {
        const server = express()
        
        // learn more express routing from nodejs document
        server.get('/custom/:id', (req, res) => {
            res.send(req.params)
        })

        server.get('/*', (req, res) => {
            return handle(req, res)
        })

        server.listen(port, (err) => {
            if (err) throw err
            console.log(`> Ready on http://localhost:${port}`)
        })
    })
    ```