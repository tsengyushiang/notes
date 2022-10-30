# GitLab

## Fork

```
//check cuurent remote setting
$ git remote -v
origin  https://gitlab.com/tsengyushiang/basic-custum-2.git (fetch)
origin  https://gitlab.com/tsengyushiang/basic-custum-2.git (push)

// add upstream repo to remote
$ git remote add upstream https://gitlab.com/testing1078/basic.git
$ git remote -v
origin  https://gitlab.com/tsengyushiang/basic-custum-2.git (fetch)
origin  https://gitlab.com/tsengyushiang/basic-custum-2.git (push)
upstream        https://gitlab.com/testing1078/basic.git (fetch)
upstream        https://gitlab.com/testing1078/basic.git (push)

// fetch upstream state
$ git fetch upstream
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 4 (delta 1), reused 2 (delta 0), pack-reused 0
Unpacking objects: 100% (4/4), 419 bytes | 34.00 KiB/s, done.
From https://gitlab.com/testing1078/basic
 * [new branch]      main       -> upstream/main

// merge upstream main to our branch
$ git merge upstream/main
Updating f576df4..30eb41b
Fast-forward
 foo | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 foo
```


## Templates

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

## CI

### MR Pipeline

- `.gitlab-ci.yml` for difference table of MR can be used in description.

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