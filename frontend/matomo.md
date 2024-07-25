# Matomo

- [matomo](https://github.com/matomo-org/matomo)

## Quick start

### Run with `docker-compose.yml`

```yml
version: "3"

services:
  matomo_db:
    image: mariadb:10.6
    container_name: matomo_db
    command: --max-allowed-packet=64MB
    restart: always
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root_pwd
      - MYSQL_DATABASE=my_matomo_tracking

  matomo_app:
    image: matomo:4.11.0-apache
    container_name: matomo_app
    restart: always
    depends_on: 
      - matomo_db
    volumes:
      - ./web:/var/www/html
    environment:
      - MATOMO_DATABASE_HOST=matomo_db
      - MATOMO_DATABASE_USERNAME=root
      - MATOMO_DATABASE_PASSWORD=root_pwd
      - MATOMO_DATABASE_DBNAME=my_matomo_tracking

    ports:
      - 80:80

  nginx:
    image: nginx:latest
    volumes:
      - ./webapp:/usr/share/nginx/html:ro
    ports:
      - 8080:80
```

### Prepared a html for testing `./webapp/index.html` served by nginx

```html
<!DOCTYPE html>
<html>
<head>
<title>Matomo</title>

<!-- Matomo -->
<script>
    var _paq = window._paq = window._paq || [];
    /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
    _paq.push(['trackPageView']);
    _paq.push(['enableLinkTracking']);
    (function() {
      var u="//localhost/";
      _paq.push(['setTrackerUrl', u+'matomo.php']);
      _paq.push(['setSiteId', '1']);
      var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
      g.async=true; g.src=u+'matomo.js'; s.parentNode.insertBefore(g,s);
    })();
  </script>
  <!-- End Matomo Code -->

</head>
<body>

<button>This is a button</button>

</body>
</html>
```

> `_paq.push(['setSiteId', '1']);` should match the id on matomo web ui.

### Start services

- Run matomo 

```
docker-compose up -d
```

- Visit the demo web app at [http://localhost:8080/](http://localhost:8080/).

  - If you encounter Failed to load resource: net::ERR_BLOCKED_BY_CLIENT in Chrome, it means some plugins are blocking scripts. Disable them or try using private mode.

- Visit Matomo at [http://localhost/](http://localhost/).

  - Set up an admin account.
  - Enter [http://localhost:8080/](http://localhost:8080/) in the Website URL field for testing purposes.
  - Copy the JavaScript Tracking Code into your HTML file.
