# Sonarqube

## Quick start

- Install from [sonarqube docker image](https://hub.docker.com/_/sonarqube).

```bash
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092  sonarqube:9.9.1-community
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

- Or using [offical scanner](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner/).

```bash
sonar-scanner \
  -Dsonar.projectKey=${YOUR_PROJECT_KEY} \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONARQUBE_URL} \
  -Dsonar.login=${YOUR_AUTH_TOKEN} \
```

## Issues

- When sonarqube is hosted on the same machine use `--network="host"` to make network work.

- Gitbash on **Windows** will break volume path of docker command.

## WebAPI

- API document can be found at http://localhost:9000/web_api.

- Fetch api with a `User Token` set from http://localhost:9000/account/security.

```
curl -u <token>: 'http://localhost:9000/api/qualitygates/project_status?projectKey=test&pullRequest=1'
```

- Fetch api with a password

```
curl -u <user>:<password> 'http://localhost:9000/api/qualitygates/project_status?projectKey=test&pullRequest=1'
```

## Plugins

### Install

- Download `${plugin}.jar` to local and copy into containers then restart.

```bash
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube:lts
docker cp ${plugin}.jar sonarqube:/opt/sonarqube/extensions/plugins
docker restart sonarqube
```

### Recommend plugins

> Following package's verion works with sonarqube `Community EditionVersion 9.9.1 (build 69595)`.

- [sonar-cnes-report-4.2.0](https://github.com/cnescatlab/sonar-cnes-report/releases/tag/4.2.0), supported veriosn can be found in [source code](https://github.com/cnescatlab/sonar-cnes-report/blob/4.0.0/src/main/java/fr/cnes/sonar/report/factory/ServerFactory.java#L34C4-L34C4).
    
    - plugin can be found in `More` tab.

- [sonarqube-community-branch-plugin 1.14.0](https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/tag/1.14.0)

    - Additional steps after move `.jar`

    ```
    docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 -e SONAR_WEB_JAVAADDITIONALOPTS=-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=web -e SONAR_CE_JAVAADDITIONALOPTS=-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=ce sonarqube:9.9.1-community
    ```

    > There will have `Branches and Pull Requests` in Administration > HouseKeeping tab means install success.

    - Add `-Dsonar.branch.name=${branch_name}` for branch
    - Add `-Dsonar.pullrequest.key=${pr_number} -Dsonar.pullrequest.branch=${pr_branch} -Dsonar.pullrequest.base=${base_branch}` for pr.


### Build From Dockerfile

- Download plugins

```bash
curl -L https://github.com/cnescatlab/sonar-cnes-report/releases/download/4.2.0/sonar-cnes-report-4.2.0.jar --output sonar-cnes-report-4.2.0.jar

curl -L https://github.com/cnescatlab/sonar-cnes-report/releases/download/4.2.0/sonar-cnes-report-4.2.0.jar --output sonar-cnes-report-4.2.0.jar
```

- Add `Dockerfile`

```dockerfile
FROM sonarqube:9.9.1-community

COPY ./sonar-cnes-report-4.2.0.jar /opt/sonarqube/extensions/plugins/sonar-cnes-report-4.2.0.jar

COPY ./sonarqube-community-branch-plugin-1.14.0.jar /opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar

ENV SONAR_WEB_JAVAADDITIONALOPTS=-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=web
ENV SONAR_CE_JAVAADDITIONALOPTS=-javaagent:/opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-1.14.0.jar=ce

EXPOSE 9000 9092
```

- Build and Run, then executes scans for your projects.

```bash
docker build -t my-sonarqube .
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 my-sonarqube
```
