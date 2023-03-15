# GitLab

## Templates

- MR template : `.gitlab/merge_request_templates/Default.md`
- Issue template : `.gitlab/issue_templates/Default.md`
- named `Default.md` (case insensitive) will auto fill when issue and MR creates

## CI/CD

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
