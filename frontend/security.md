# Security

## Cross-site request forgery(CSRF)

- [Reference](https://dev.to/adelhamad/csrf-protection-in-nextjs-1g1m)

- Install [csurf package](https://github.com/expressjs/csurf)

```
yarn add csurf
```

- Create helper function.

```javascript
import csurf from 'csurf'

// Helper method to wait for a middleware to execute before continuing
// And to throw an error when an error happens in a middleware
export function csrf(req, res) {
    return new Promise((resolve, reject) => {
        csurf({ cookie: true })(req, res, (result) => {
            if (result instanceof Error) {
                return reject(result)
            }
            return resolve(result)
        })
    })
}

export default csrf
```

- Make sure the `api/hello` API is protected by CSRF token.

```javascript
export default async function handler(req, res) {
  await csrf(req, res);
  res.status(200).json({ name: 'John Doe' })
}
```

- Expose token to pages

```javascript
// for single page use setting in pages/**/*.js
export async function getServerSideProps(context) {
    const { req, res } = context
    await csrf(req, res)
    return {
        props: { csrfToken: req.csrfToken() },
    }
}
```

```javascript
// for whole app use setting in pages/_app.js
MyApp.getInitialProps = async ({ Component, ctx }) => {
    const { req, res } = ctx;
    await csrf(req, res);
    const pageProps = {
        csrfToken: ctx.req.csrfToken(),
    };
})
```

- Call api with csrf token

```javascript
fetch('/api/hello', {
    headers:{
        'CSRF-Token': csrfToken
    }
})
```


## Content-Security-Policy(CSP)

- [Reference](https://hackmd.io/@Eotones/BkOX6u5kX)

```html
<meta http-equiv="Content-Security-Policy" content="default-src 'none'; img-src 'self' data:;">
```

- Safari issues : 

  - use `child-src` for `worker-src`
  - use `script-src` for `script-src-elem`.

