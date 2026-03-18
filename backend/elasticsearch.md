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

Visit `https://localhost:9200`. A successful JSON response with tagline "You Know, for Search" confirms it is running.

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

## Ingest Pipeline for daily CSV files

### Create pipeline

- Go to Kibana Dev Tools (`http://localhost:5601/app/dev_tools#/console`) and run the following API:

```json
PUT _ingest/pipeline/csv_parser
{
  "description": "Extracts custom timestamp from filename 2026-03-16_00-04-13",
  "processors": [
    {
      "grok": {
        "field": "log.file.path",
        "patterns": ["%{GREEDYDATA}/%{YEAR:y}-%{MONTHNUM:m}-%{MONTHDAY:d}_%{HOUR:h}-%{MINUTE:min}-%{SECOND:s}\\.csv"]
      }
    },
    {
      "set": {
        "field": "_temp_ts",
        "value": "{{{y}}}-{{{m}}}-{{{d}}} {{{h}}}:{{{min}}}:{{{s}}}"
      }
    },
    {
      "date": {
        "field": "_temp_ts",
        "formats": ["yyyy-MM-dd HH:mm:ss"],
        "target_field": "timestamp"
      }
    },
    {
      "csv": {
        "field": "message",
        "target_fields": ["column1", "column2"],
        "separator": ","
      }
    },
    {
      "remove": {
        "field": ["message", "_temp_ts", "y", "m", "d", "h", "min", "s"],
        "ignore_missing": true
      }
    }
  ]
}
```

- Verify the pipeline with the following simulation data. If the output displays a clean `"timestamp": "2026-03-16T00:04:13.000Z"`, you're all set!

```json
POST _ingest/pipeline/csv_parser/_simulate
{
  "docs": [
    {
      "_source": {
        "log": { "file": { "path": "/usr/share/filebeat/csv_data/2026-03-16_00-04-13.csv" } },
        "message": "Value1,Value2"
      }
    }
  ]
}
```

### Setup Filebeat

- Configure `filebeat.yml` to monitor file changes:


```yaml
filebeat.inputs:
  - type: filestream
    id: daily-csv-pipeline
    enabled: true
    paths:
      - /usr/share/filebeat/csv_data/*.csv

output.elasticsearch:
  hosts: ["https://elasticsearch:9200"]
  username: "elastic"
  password: "Bbdra7e36sO8OL6ic0lY"
  ssl.verification_mode: "none"
  pipeline: "csv_parser"
```

- Run the Filebeat container:

```bash
docker run -d \
  --name filebeat \
  --user root \
  --net elastic-network \
  -v "$(pwd)/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro" \
  -v "$(pwd)/csv_data:/usr/share/filebeat/csv_data:ro" \
  -v "$(pwd)/filebeat_data:/usr/share/filebeat/data" \
  docker.elastic.co/beats/filebeat:9.3.1 \
  filebeat run -e --strict.perms=false
```

- Add a CSV to `/csv_data` and verify it appears in Elasticsearch.

### Debug Filebeat container issues:

```bash
# Test configuration validity
docker exec -it filebeat filebeat test config

# Test Elasticsearch connectivity
docker exec -it filebeat filebeat test output

# Monitor logs to confirm the harvester is active
docker logs filebeat | grep "harvester"
```