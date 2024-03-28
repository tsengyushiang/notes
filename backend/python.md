# Python


## Flask

- Add `routes.py` for api endpoints

```python
from flask import Blueprint

api_bp = Blueprint('api', __name__)

@api_bp.route("/")
def hello():
    return "Hello, World!"
```

- Add `app.py` for configurations.

```python
import os
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from routes import api_bp

app = Flask(__name__)

# register routes
app.register_blueprint(api_bp)

# bind the database and ORM. The DB_URI is specified in the docker-compose file."
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DB_URI')
db = SQLAlchemy(app)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

## SQLAlchemy



## Docker-compose

- `phpmyadmin` isn't essential, but it greatly improves inspection for newcomers.

    - open localhost:8081 and log in with the username `root` and the password `MYSQL_ROOT_PASSWORD` as specified in the following file.

- Writes environment variables in `.env`.
```
DB_NAME=app
DB_PASSWORD=my_secret_password
```

- Run service with following `docker-compose.yml`.

```yml
version: '3'

services:
  nginx:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/conf.d/default.conf:ro

  server:
    build: ./server
    command: python app.py
    environment:
        DB_URI: mysql+pymysql://root:${DB_PASSWORD}@db/${DB_NAME}
    volumes:
      - ./server:/app

  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
      MYSQL_DATABASE: ${DB_NAME}
    ports:
      - "6033:3306"
    volumes:
      - ./dbdata:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    links:
      - db
    environment:
      PMA_HOST: db
      PMA_PORT: 3306
      #PMA_ARBITRARY: 1
    restart: always
    ports:
      - 8081:80
```