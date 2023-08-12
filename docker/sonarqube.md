# Sonarqube

## Quick start

- Install from [sonarqube docker image](https://hub.docker.com/_/sonarqube).

```bash
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
```

- Go [http://localhost:9000/](http://localhost:9000/) to create a [manual project](http://localhost:9000/projects/create?mode=manual) and use [local scan](http://localhost:9000/dashboard?id=test&selectedTutorial=local) to get token.

- Run [scanner-cli](https://docs.sonarsource.com/sonarqube/latest/analyzing-source-code/scanners/sonarscanner/) for scan.

```
docker run \
    --rm \
    --network="host" \
    -e SONAR_HOST_URL=${SONARQUBE_URL} \
    -e SONAR_SCANNER_OPTS="-Dsonar.projectKey=${YOUR_PROJECT_KEY}" \
    -e SONAR_LOGIN=${YOUR_AUTH_TOKEN} \
    -v ${YOUR_REPO}:/usr/src \
    sonarsource/sonar-scanner-cli
```
> For example, my command looks like:    

```bash
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

- Gitbash on **Windows** will break volume path of docker command.

## Plugins

### Install

- Download `${plugin}.jar` to local and copy into containers then restart.

```bash
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube:lts
docker cp ${plugin}.jar sonarqube:/opt/sonarqube/extensions/plugins
docker stop sonarqube
docker start sonarqube
```

- After restart plugin can be found in `More` tab.
  
### Recommend plugins

> Following package's verion works with sonarqube `Community EditionVersion 9.9.1 (build 69595)`.

- [sonar-cnes-report-4.2.0](https://github.com/cnescatlab/sonar-cnes-report#compatibility-matrix), supported veriosn can be found in [source code](https://github.com/cnescatlab/sonar-cnes-report/blob/4.0.0/src/main/java/fr/cnes/sonar/report/factory/ServerFactory.java#L34C4-L34C4).
