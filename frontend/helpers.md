# Helpers

## API Helper (Token Refresh)

- `/pages/api/refreshToken.js`

```javascript
export default async function handler(req, res) {
  if (req.method === "POST") {
    try {
      // some server-side fetch token code here
      res.status(200).json({ token });
    } catch {
      res.status(500).json({
        error: { message: "Server side cannot get token.", status: 401 },
      });
    }
  }
}
```

- `/helper/apiHelper.js`

```javascript
import * as cookies from "./cookies";

export const invokeApi = async ({url}) => {
  const token = cookies.getToken();
  const option = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };
  
  const refreshTokenURL = "/api/refreshToken";
  const refreshTokenParams = { method: "POST" };

  const retry = () => invokeApi(params);
  const refreshTokenAndRetry = () => {
    return fetch(refreshTokenURL,refreshTokenParams)
      .then((response) => response.json())
      .then((response) => {
        if (!response?.token) return response;
        cookies.setToken(response.token);
        return retry();
      });
  };

  return fetch(url, option)
    .then((response) => response.json())
    .then((response) => {
      if (!response.error) return response;
      return refreshTokenAndRetry(response);
    });
};
```
- `/api/getPlaylist.js`

```
import { invokeApi } from "../helper/apiHelper";

const getPlaylist = ({ categoryId }) => {
  const param = {
    url: `https://api.spotify.com/v1/browse/categories/${categoryId}/playlists`,
  };
  return invokeApi(param);
};

export default getPlaylist;
```
