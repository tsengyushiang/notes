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
from routes import api_bp
from extensions import db

if __name__ == '__main__':
  app = Flask(__name__)
  app.app_context().push() # avoid with app.app_context(). warning.

  app.register_blueprint(api_bp)

  # bind the database and ORM. The DB_URI is specified in the docker-compose file."
  app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DB_URI')
  db.init_app(app)
  db.create_all()
  app.run(host='0.0.0.0', debug=True)
```

## SQLAlchemy

### Initialize

- Init instance in `extensions.py` to avoid circular import.

```python
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
```

### Define Schema

```python
from extensions import db
from datetime import datetime

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password = db.Column(db.String(120), unique=True, nullable=False)
    date_joined = db.Column(db.Date, default=datetime.utcnow)
    
    # log format for debug.
    def __repr__(self):
        return f'<User: {self.username}>'
```

### APIs

- Create tables by `db.create_all()`.

- Insert data

```python
admin = User(username='admin', password='admin')
db.session.add(admin)
db.session.commit()
```

- Update data

```python

root = User.query.filter_by(username='admin').first()
root.password='root'
db.session.commit()
```

- Delete data

```python
target = User.query.filter_by(password='root').first()
db.session.delete(target)
db.session.commit()
```


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