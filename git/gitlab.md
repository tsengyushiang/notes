# GitLab

## Templates

- MR template : `.gitlab/merge_request_templates/Default.md`
- Issue template : `.gitlab/issue_templates/Default.md`
- named `Default.md` (case insensitive) will auto fill when issue and MR creates

## CI/CD

### Setup Runner

- [Reference](https://docs.gitlab.com/runner/install/docker.html)
- [Create a new runner](https://gitlab.com/tsengyushiang/runner/-/runners/new) via the web UI.
- Choose Linux OS
- Start the Runner Container:

  ```bash
  docker run -d --name gitlab-runner --restart always -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock gitlab/gitlab-runner:latest
  ```

- Register the runner (only once)

  ```bash
  docker exec -it gitlab-runner bash
  ```
  
  ```bash
  root@679375f8d930:/# gitlab-runner register  --url https://gitlab.com  --token glrt-_6x3zVpsK22MRrAqvPbp
  Runtime platform                                    arch=amd64 os=linux pid=25 revision=9882d9c7 version=17.2.1
  Running in system-mode.                            
                                                     
  Enter the GitLab instance URL (for example, https://gitlab.com/):
  [https://gitlab.com]: https://gitlab.com
  Verifying runner... is valid                        runner=_6x3zVpsK
  Enter a name for the runner. This is stored only in the local config.toml file:
  [679375f8d930]: gitlab-runner-testing
  Enter an executor: parallels, virtualbox, docker, docker-windows, docker+machine, instance, shell, ssh, kubernetes, docker-autoscaler, custom:
  docker
  Enter the default Docker image (for example, ruby:2.7):
  node:20
  Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
   
  Configuration (with the authentication token) was saved in "/etc/gitlab-runner/config.toml"
  ```


### Run test for merge request when target is default branch.

`.gitlab-ci.yml`
```yml
test_codes:
  stage: test
  image: node:16.13.1-slim
  only:
    refs:
      - merge_requests
    variables:
      - $CI_MERGE_REQUEST_TARGET_BRANCH_NAME == $CI_DEFAULT_BRANCH
  script:
    - yarn
    - yarn test
    - yarn eslint
    - yarn build
```
- Go setting to block merge request merging when pipline failed.

### Log difference table.

`.gitlab-ci.yml`
```yml
LogDifferenceTable:
script:
    - git fetch
    - git diff-tree -r --no-commit-id --name-status origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME} origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME} | sed -e 's/\t/|/' -e '1i|State|File|Description|' -e '1i|:---:|:---|:---|' -e 's/^/|/' -e 's/$/||/'
    - git diff-tree -r --no-commit-id --name-status origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME} origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME} | sed -e 's/\t/|/' -e '1i|State|File|Description|' -e '1i|:---:|:---|:---|' -e 's/^/|/' -e 's/$/||/' > difference.md

only:
    - merge_requests

artifacts:
    expose_as: 'difference'
    expire_in : 1 hrs
    paths:
    - difference.md

# run when manually click button on web interface
when: manual

# run pipeline when MR is ready and changed
except:
    variables:
        - $CI_MERGE_REQUEST_TITLE =~ /^WIP:.*/ || $CI_MERGE_REQUEST_TITLE =~ /^Draft:.*/
```
