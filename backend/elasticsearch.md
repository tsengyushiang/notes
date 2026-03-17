# Elasticsearch

## Setup in Development Mode

### Create Network & Start Container

```bash
docker network create elastic-network
docker run -d --name elasticsearch --net elastic-network -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:9.3.1
```

### Generate Credentials

Run the following inside the container to generate passwords for default users:

```bash
docker exec -it elasticsearch bash
bin/elasticsearch-setup-passwords auto

...
Changed password for user elastic
PASSWORD elastic = Bbdra7e36sO8OL6ic0lY
```

- Default User: `elastic`
- Password: (Use the generated value, e.g., Bbdra7e36sO8OL6ic0lY)

### Verify Connection

Visit https://localhost:9200. A successful JSON response with tagline "You Know, for Search" confirms it is running.

## Kibana Setup

### Start Container

```bash
docker run -d --name my-kibana --net elastic-network -p 5601:5601 kibana:9.3.1
```

### Generate Enrollment Token

Required to link Kibana to Elasticsearch:

```bash
docker container exec -it elasticsearch bash
elasticsearch-create-enrollment-token -s kibana

eyJ2ZXIiOiI4LjE0LjAiLCJhZHIiOlsiMTcyLjE4LjAuMjo5MjAwIl0sImZnciI6IjNjY2NkNTJlZjE1NjJhMzdkYzgwYTU3ZjA3OGMxMDUwNTk0YTZiZWRkYzcxOTY3NDBmOWQ0OWFmYzYwODU0YTQiLCJrZXkiOiJiN0tqLXB3Qk5FbXdfaGRmY2QyVTphQ1N5cTZUR0xzY2pQaXJrX01mWVV3In0=
```

### Configuration & Login

- Visit `http://localhost:5601/`
- Paste in enroll token `eyJ2ZXIiOiI4LjE0LjA...`
- Log in using the `elastic` username and password generated in the previous step.