# Sonarqube

- [reference](https://old-oomusou.goodjack.tw/sonarqube/docker/)


## Quick start

- Install from [sonarqube docker image](https://hub.docker.com/_/sonarqube).

```bash
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```

- Go [http://localhost:9000/](http://localhost:9000/) to create a [manual project](http://localhost:9000/projects/create?mode=manual) and use [local scan](http://localhost:9000/dashboard?id=test&selectedTutorial=local) to get token.

- Run [scanner-cli](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/), following params should be change for your scan:
    
    - SONAR_HOST_URL=`http://localhost:9000`
    - SONAR_SCANNER_OPTS="-Dsonar.projectKey=`test`
    - SONAR_LOGIN=`sqp_5b06c6a3ab1d93a8c2e88fe38284ef470bd01ae0`
    - -v `/c/Users/tseng/Desktop/PanoToMesh`

```
docker run \
    --rm \
    --network="host" \
    -e SONAR_HOST_URL=http://localhost:9000 \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=test" \
    -e SONAR_LOGIN=sqp_5b06c6a3ab1d93a8c2e88fe38284ef470bd01ae0 \
    -v /c/Users/tseng/Desktop/PanoToMesh:/usr/src \
    sonarsource/sonar-scanner-cli
```

## Issues

- When sonarqube is hosted on the same machine use `--network="host"` to make network work.

- Gitbash on window will break volume path of docker command.