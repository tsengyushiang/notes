# GitLab

## Templates

- MR template : `.gitlab/merge_request_templates/Default.md`
- Issue template : `.gitlab/issue_templates/Default.md`
- named `Default.md` (case insensitive) will auto fill when issue and MR creates

## CI/CD

- log difference table.

    `.gitlab-ci.yml`
    ```
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