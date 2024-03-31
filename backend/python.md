# Python

## Flask

- Add `routes/auth.py` for api endpoints

```python
from flask import Blueprint, request, jsonify
from models.user import User
from app.extensions import db

auth_bp = Blueprint('auth', __name__)

@auth_bp.route("/signup", methods=['POST'])
def signup():
    data = request.json
    username = data.get('username')
    password = data.get('password')

    if User.query.filter_by(username=username).first() is not None:
        return jsonify({'error_code': 401}), 400

    user = User(username=username, password=password)
    db.session.add(user)
    db.session.commit()
    return jsonify({'message': 'User signed up successfully'}), 200
```

- Add `app/__init_.py` to initialize the Flask app.

```python
from flask import Flask
from .extensions import db
from .config import config
from routes.auth import auth_bp
 
def create_app(config_name):
 
    app = Flask(__name__)
    app.app_context().push()

    app.config.from_object(config[config_name])
    db.init_app(app)

    app.register_blueprint(auth_bp)

    return app
```
- Add `app/config.py` to store environment variables in different environments.

```python
import os
 
basedir = os.path.abspath(os.path.dirname(__file__))

def create_sqlite_uri(db_name):
    return "sqlite:///" + os.path.join(basedir, db_name)
 
class BaseConfig:
    SECRET_KEY = 'SECRET_KEY'
 
class DevelopmentConfig(BaseConfig):
    SQLALCHEMY_DATABASE_URI = os.environ.get('DB_URI')
 
class TestingConfig(BaseConfig):
    SQLALCHEMY_DATABASE_URI = create_sqlite_uri("test.db")
 
config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
}
```
- Use `create_app` in `main.py` to start server.

```python
import os
from app.extensions import db
from app import create_app
from flask_migrate import Migrate

app = create_app('development')
migrate = Migrate(app, db)

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
```

## SQLAlchemy

### Initialize

- Init instance in `app/extensions.py` to avoid circular import.

```python
from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()
```

### Define Schema

```python
from app.extensions import db
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

## Flask-Migrate

- Install package `pip install Flask-Migrate cryptography`

- Setup flask app

```diff
  from app.extensions import db
  from app import create_app
+ from flask_migrate import Migrate

  app = create_app('development')
+ migrate = Migrate(app, db)
```

- Create Version Control `flask db init`
- Check the difference between the database and the schema, and create migration scripts using `flask db migrate -m "some changelogs"`.
- Apply files settings to database `flask db upgrade`

> Manually check the script is necessary

## Flask-Testing

- Install package `pip install Flask-Testing`.

- Add test script `test.py`

```python
import unittest
import sys

tests = unittest.TestLoader().discover("tests")
result = unittest.TextTestRunner(verbosity=2).run(tests)
if result.errors or result.failures:
    sys.exit(1)
```

- Add testcases in `/test/test_*.py` files

```python
import unittest
import json
from flask import url_for
from flask_testing import TestCase
from app import create_app, db
import json
 
class SettingBase(TestCase):
    def create_app(self):
        return create_app("testing")

    def setUp(self):
        db.create_all()
 
    def tearDown(self):
        db.session.remove()
        db.drop_all()
 
    def signup(self):
        response = self.client.post(url_for('auth.signup'),
                                    json={
                                        "username": 'admin',
                                        "password": 'admin',
                                    })
        return response
 
class CheckUserAndLogin(SettingBase):
    def test_signup(self):
        response = self.signup()
        self.assertEqual(response.status_code, 200)

    def test_signup_duplicate(self):
        self.signup()
        response = self.signup()

        response_data = json.loads(response.data.decode('utf-8'))

        self.assertEqual(response_data['error_code'], 401)
        self.assertEqual(response.status_code, 400)
 
if __name__ == '__main__':
    unittest.main()
```

> Additionally, you can verify using the following command: `curl -X POST   -H "Content-Type: application/json"   -d '{"username": "admin2", "password": "admin2"}'   http://localhost/signup`

- Finally, you can execute `python test.py` to run the tests

```
root@208fd29e978c:/app# python test.py
test_signup (test_auth.CheckUserAndLogin) ... ok
test_signup_duplicate (test_auth.CheckUserAndLogin) ... ok

----------------------------------------------------------------------
Ran 2 tests in 0.144s

OK
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
    command: ./wait-for-it.sh db:3306 --strict -- bash -c "FLASK_APP=main.py flask db upgrade && python main.py"
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

## Issues

### Database Not Ready for Server

- To ensure that the server starts only when the database is ready, utilize `wait-for-it.sh` to check the database port before initiating the server. Modify the `docker-compose.yml` file as shown below:

```diff
-    command: python app.py
+    command: ./wait-for-it.sh db:3306 --strict -- bash -c "flask db upgrade && python app.py"
```

> The source code of `wait-for-it.sh` is copied from [vishnubob/wait-for-it](https://github.com/vishnubob/wait-for-it).

```sh
#!/usr/bin/env bash
# Use this script to test if a given TCP host/port are available

WAITFORIT_cmdname=${0##*/}

echoerr() { if [[ $WAITFORIT_QUIET -ne 1 ]]; then echo "$@" 1>&2; fi }

usage()
{
    cat << USAGE >&2
Usage:
    $WAITFORIT_cmdname host:port [-s] [-t timeout] [-- command args]
    -h HOST | --host=HOST       Host or IP under test
    -p PORT | --port=PORT       TCP port under test
                                Alternatively, you specify the host and port as host:port
    -s | --strict               Only execute subcommand if the test succeeds
    -q | --quiet                Don't output any status messages
    -t TIMEOUT | --timeout=TIMEOUT
                                Timeout in seconds, zero for no timeout
    -- COMMAND ARGS             Execute command with args after the test finishes
USAGE
    exit 1
}

wait_for()
{
    if [[ $WAITFORIT_TIMEOUT -gt 0 ]]; then
        echoerr "$WAITFORIT_cmdname: waiting $WAITFORIT_TIMEOUT seconds for $WAITFORIT_HOST:$WAITFORIT_PORT"
    else
        echoerr "$WAITFORIT_cmdname: waiting for $WAITFORIT_HOST:$WAITFORIT_PORT without a timeout"
    fi
    WAITFORIT_start_ts=$(date +%s)
    while :
    do
        if [[ $WAITFORIT_ISBUSY -eq 1 ]]; then
            nc -z $WAITFORIT_HOST $WAITFORIT_PORT
            WAITFORIT_result=$?
        else
            (echo -n > /dev/tcp/$WAITFORIT_HOST/$WAITFORIT_PORT) >/dev/null 2>&1
            WAITFORIT_result=$?
        fi
        if [[ $WAITFORIT_result -eq 0 ]]; then
            WAITFORIT_end_ts=$(date +%s)
            echoerr "$WAITFORIT_cmdname: $WAITFORIT_HOST:$WAITFORIT_PORT is available after $((WAITFORIT_end_ts - WAITFORIT_start_ts)) seconds"
            break
        fi
        sleep 1
    done
    return $WAITFORIT_result
}

wait_for_wrapper()
{
    # In order to support SIGINT during timeout: http://unix.stackexchange.com/a/57692
    if [[ $WAITFORIT_QUIET -eq 1 ]]; then
        timeout $WAITFORIT_BUSYTIMEFLAG $WAITFORIT_TIMEOUT $0 --quiet --child --host=$WAITFORIT_HOST --port=$WAITFORIT_PORT --timeout=$WAITFORIT_TIMEOUT &
    else
        timeout $WAITFORIT_BUSYTIMEFLAG $WAITFORIT_TIMEOUT $0 --child --host=$WAITFORIT_HOST --port=$WAITFORIT_PORT --timeout=$WAITFORIT_TIMEOUT &
    fi
    WAITFORIT_PID=$!
    trap "kill -INT -$WAITFORIT_PID" INT
    wait $WAITFORIT_PID
    WAITFORIT_RESULT=$?
    if [[ $WAITFORIT_RESULT -ne 0 ]]; then
        echoerr "$WAITFORIT_cmdname: timeout occurred after waiting $WAITFORIT_TIMEOUT seconds for $WAITFORIT_HOST:$WAITFORIT_PORT"
    fi
    return $WAITFORIT_RESULT
}

# process arguments
while [[ $# -gt 0 ]]
do
    case "$1" in
        *:* )
        WAITFORIT_hostport=(${1//:/ })
        WAITFORIT_HOST=${WAITFORIT_hostport[0]}
        WAITFORIT_PORT=${WAITFORIT_hostport[1]}
        shift 1
        ;;
        --child)
        WAITFORIT_CHILD=1
        shift 1
        ;;
        -q | --quiet)
        WAITFORIT_QUIET=1
        shift 1
        ;;
        -s | --strict)
        WAITFORIT_STRICT=1
        shift 1
        ;;
        -h)
        WAITFORIT_HOST="$2"
        if [[ $WAITFORIT_HOST == "" ]]; then break; fi
        shift 2
        ;;
        --host=*)
        WAITFORIT_HOST="${1#*=}"
        shift 1
        ;;
        -p)
        WAITFORIT_PORT="$2"
        if [[ $WAITFORIT_PORT == "" ]]; then break; fi
        shift 2
        ;;
        --port=*)
        WAITFORIT_PORT="${1#*=}"
        shift 1
        ;;
        -t)
        WAITFORIT_TIMEOUT="$2"
        if [[ $WAITFORIT_TIMEOUT == "" ]]; then break; fi
        shift 2
        ;;
        --timeout=*)
        WAITFORIT_TIMEOUT="${1#*=}"
        shift 1
        ;;
        --)
        shift
        WAITFORIT_CLI=("$@")
        break
        ;;
        --help)
        usage
        ;;
        *)
        echoerr "Unknown argument: $1"
        usage
        ;;
    esac
done

if [[ "$WAITFORIT_HOST" == "" || "$WAITFORIT_PORT" == "" ]]; then
    echoerr "Error: you need to provide a host and port to test."
    usage
fi

WAITFORIT_TIMEOUT=${WAITFORIT_TIMEOUT:-15}
WAITFORIT_STRICT=${WAITFORIT_STRICT:-0}
WAITFORIT_CHILD=${WAITFORIT_CHILD:-0}
WAITFORIT_QUIET=${WAITFORIT_QUIET:-0}

# Check to see if timeout is from busybox?
WAITFORIT_TIMEOUT_PATH=$(type -p timeout)
WAITFORIT_TIMEOUT_PATH=$(realpath $WAITFORIT_TIMEOUT_PATH 2>/dev/null || readlink -f $WAITFORIT_TIMEOUT_PATH)

WAITFORIT_BUSYTIMEFLAG=""
if [[ $WAITFORIT_TIMEOUT_PATH =~ "busybox" ]]; then
    WAITFORIT_ISBUSY=1
    # Check if busybox timeout uses -t flag
    # (recent Alpine versions don't support -t anymore)
    if timeout &>/dev/stdout | grep -q -e '-t '; then
        WAITFORIT_BUSYTIMEFLAG="-t"
    fi
else
    WAITFORIT_ISBUSY=0
fi

if [[ $WAITFORIT_CHILD -gt 0 ]]; then
    wait_for
    WAITFORIT_RESULT=$?
    exit $WAITFORIT_RESULT
else
    if [[ $WAITFORIT_TIMEOUT -gt 0 ]]; then
        wait_for_wrapper
        WAITFORIT_RESULT=$?
    else
        wait_for
        WAITFORIT_RESULT=$?
    fi
fi

if [[ $WAITFORIT_CLI != "" ]]; then
    if [[ $WAITFORIT_RESULT -ne 0 && $WAITFORIT_STRICT -eq 1 ]]; then
        echoerr "$WAITFORIT_cmdname: strict mode, refusing to execute subprocess"
        exit $WAITFORIT_RESULT
    fi
    exec "${WAITFORIT_CLI[@]}"
else
    exit $WAITFORIT_RESULT
fi
```
