# Fork Workflow

- [view on github](https://github.com/tsengyushiang/notes/blob/master/git/workflow.md)

- develop on base repo, denote fork repo as `client1`.


- develop on fork repo, denote fork repo as `client1`.

```mermaid

gitGraph
    commit
    commit
    branch feature
    branch client1/main
    commit tag:"repo for client1"
    branch client1/feature
    commit
    checkout client1/main
    commit id:"other feature"
    checkout client1/feature
    branch client1/feature-customize
    commit
    merge client1/main
    checkout client1/feature
    commit
    checkout client1/feature-customize
    commit
    merge client1/feature
    checkout client1/main
    merge client1/feature-customize tag:"new feature MR"
    checkout client1/feature
    branch client1/fix-feature
    commit
    checkout client1/feature
    merge client1/fix-feature
    checkout client1/feature-customize
    branch client1/fix-feature-customize
    commit
    merge client1/feature
    checkout client1/main
    merge client1/fix-feature-customize tag:"solve issue MR"
    checkout main
    checkout feature
    merge client1/feature tag:"client1 feature MR"
    checkout main
    merge feature
```
