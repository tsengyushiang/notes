# Ngrok

- Login to https://dashboard.ngrok.com/get-started/setup/docker for auth token.

- Run command to make localhost available for others

```
docker run --net=host -it -e NGROK_AUTHTOKEN=${TOKEN} ngrok/ngrok:latest http ${PORT}
```
