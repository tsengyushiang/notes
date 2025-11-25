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
  - report

generate-report:
  stage: report
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
      RESULT="Branch,Merged,MR_ID,MR_Title\n"

      for BR in $BRANCHES; do
          # Skip ignored branches
          if echo "$IGNORE_BRANCHES" | grep -qw "$BR"; then
              RESULT="$RESULT$BR,-,-,-\n"
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

          RESULT="$RESULT$BR,$MERGED,$IID,$TITLE\n"
      done

      echo -e "$RESULT" > $CI_PROJECT_DIR/report.csv
  artifacts:
    paths:
      - report.csv
    expire_in: 1 day

push-to-branch:
  stage: report
  image: alpine:latest
  needs:
    - job: generate-report
      artifacts: true
  variables:
    GIT_STRATEGY: clone
    TARGET_BRANCH: "workflow"
  before_script:
    - apk add --no-cache git
    - git config --global user.email "ci-bot@example.com"
    - git config --global user.name "CI Bot"
  script:
    - git fetch origin
    - git switch "$TARGET_BRANCH" 2>/dev/null || git switch -c "$TARGET_BRANCH" origin/main
    - git pull
    - cp ./report.csv ./status.csv
    - date '+%Y-%m-%d %H:%M:%S' >> ./status.csv
    - git add ./status.csv
    - |
      git commit -m "chore: update report from pipeline $CI_PIPELINE_ID"
    - git push --set-upstream "$CI_REPOSITORY_URL" HEAD:"$TARGET_BRANCH" # For private repo: git push --set-upstream "https://oauth2:${PAT_TOKEN}@${CI_SERVER_HOST}/${CI_PROJECT_PATH}.git" HEAD:$TARGET_BRANCH

run-snippet:
  stage: report
  image: node:latest
  needs:
    - job: generate-report
      artifacts: true
  variables:
    WEBHOOK_SNIPPET_ID: "4904668"
    WEBHOOK_URL: "https://webhook-test.com/74c3fec59f92b922110646aa8cb23217"
  script:
  - curl -s "$CI_API_V4_URL/projects/$CI_PROJECT_ID/snippets/$WEBHOOK_SNIPPET_ID/raw" > snippet.js
  - node snippet.js $CI_PROJECT_DIR/report.csv

```
> If the CI job will push code, make sure to enable `“Allow Git push”` in the project’s `CI/CD settings`.

- (Optional) Prepare a public project snippet named `csv-to-webhook.js`.

```javascript
const fs = require('fs');
const filePath = process.argv[2];
const content = fs.readFileSync(filePath, 'utf8');

function parseCSV(csv) {
  const lines = csv.split('\n').filter(line => line.trim() !== '');
  const headers = lines.shift().split(',').map(h => h.trim());
  return lines.map(line => {
    const values = line.split(',').map(v => v.trim());
    const obj = {};
    headers.forEach((header, i) => {
      obj[header] = values[i] || '';
    });
    return obj;
  });
}

const payload = parseCSV(content);
console.log("Parsed CSV:", payload);

fetch(process.env.WEBHOOK_URL, {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify(payload)
})
```
