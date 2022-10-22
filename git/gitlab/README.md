# GitLab

## Template

- named `Default.md` (case insensitive) will auto fill when issue and MR created
- `.gitlab/merge_request_templates/Default.md`

    ```
    # ui

    * descript ui and expected response

    # code

    * folder changes, descript output of `git diff-tree -r --no-commit-id --name-status --text <soure> <target>`
    * how logic work, parse arguments

    # others

    * ...

    * end
    ```

- `.gitlab/issue_templates/Default.md`

    ```
    * descript issue

    # testing

    * descript how to test ui
    * any special test case

    # related

    * external ticket link,id from mantis,Redmine

    *end
    ```

# CI/CD

## MR Pipeline

- `.gitlab-ci.yml` for difference table of MR can be used in description.

    ```
    LogDifferenceTable:
    script:
        - git fetch
        - git diff-tree -r --no-commit-id --name-status origin/${CI_MERGE_REQUEST_TARGET_BRANCH_NAME} origin/${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME} | sed -e 's/\t/|/' -e '1i|State|File|Description|' -e '1i|:---:|:---|:---|' -e 's/^/|/' -e 's/$/||/'

    only:
        - merge_requests
    ```