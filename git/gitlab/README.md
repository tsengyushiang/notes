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