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

### Check Branches and Merge Requests

`.gitlab-ci.yml`
```yml
stages:
  - test

check-branches-mrs:
  stage: test
  image: alpine:latest
  variables:
    TARGET_BRANCH: "dev"
    IGNORE_BRANCHES: "main, origin, dev"
  before_script:
    - apk add --no-cache git curl jq
  script:
    - git clone "$CI_REPOSITORY_URL" repo
    - cd repo
    - git fetch --all --prune

    - BRANCHES=$(git for-each-ref --format='%(refname:short)' refs/remotes/origin/ | grep -v 'HEAD' | sed 's|^origin/||')
    - echo "$BRANCHES"

    - |
      ALL_MRS_JSON=$(curl --silent --header "PRIVATE-TOKEN: $CI_JOB_TOKEN" \
        "$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests?state=opened")

    - echo "===== Check each branch ====="
    - |
      # Print table header
      printf "%-25s %-10s %-10s %-40s\n" "Branch" "Merged" "MR IID" "MR Title"
      printf "%-25s %-10s %-10s %-40s\n" "------" "------" "------" "--------"

      for BR in $BRANCHES; do
          # Skip ignored branches
          if echo "$IGNORE_BRANCHES" | grep -qw "$BR"; then
              printf "%-25s %-10s %-10s %-40s\n" "$BR" "-" "-" "-"
              continue
          fi

          # Get MR for this branch
          MR=$(echo "$ALL_MRS_JSON" | jq -c --arg BR "$BR" '.[] | select(.source_branch==$BR)')

          if [ -z "$MR" ]; then
              IID="-"
              TITLE="-"
          else
              IID=$(echo "$MR" | jq -r '.iid')
              TITLE=$(echo "$MR" | jq -r '.title')
          fi

          # Check if merged
          if git merge-base --is-ancestor origin/"$BR" origin/"$TARGET_BRANCH" >/dev/null 2>&1; then
              MERGED="Yes"
          else
              MERGED="No"
          fi

          # Print table row
          printf "%-25s %-10s %-10s %-40s\n" "$BR" "$MERGED" "$IID" "$TITLE"
      done
```
The result will be:

```bash
===== Check each branch =====
$ # Print table header # collapsed multi-line command
Branch                    Merged     MR IID     MR Title                                
------                    ------     ------     --------                                
origin                    -          -          -                                       
already-in-dev            Yes        3          Draft: already-in-dev                   
dev                       -          -          -                                       
main                      -          -          -                                       
merge-wo-mr               Yes        -          -                                       
ready-with-mr             No         1          Draft: ready-with-mr                    
wo-mr                     No         -          -                                       
Cleaning up project directory and file based variables
00:01
Job succeeded
```
