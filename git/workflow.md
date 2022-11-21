# Fork Workflow

- [view on github](https://github.com/tsengyushiang/notes/blob/master/git/workflow.md)

- develop on base repo, denote fork repo as `client1`.

```mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
    commit
    commit
    branch feature
    branch client1/main
    commit tag:"repo for client1"
    checkout feature
    commit
    checkout client1/main
    branch client1/feature-customize
    merge feature tag:"feature MR1"
    checkout client1/main
    commit
    checkout client1/feature-customize
    commit
    merge client1/main
    commit
    checkout feature
    commit
    checkout client1/feature-customize
    merge feature tag:"feature MR2"
    checkout client1/main
    merge client1/feature-customize tag:"new feature MR"
    checkout main
    merge feature tag:"new feature MR"

```

- develop on fork repo, denote fork repo as `client1`.

```mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
    commit
    commit
    branch feature
    branch client1/base
    commit tag:"repo for client1"
    branch client1/main
    commit tag:"develop branch"
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
    checkout feature
    merge client1/feature tag:"client1 feature MR"
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
    merge client1/feature tag:"client1 fix MR"
    checkout main
    merge feature
    checkout client1/base
    branch client1/feature2
    commit
    checkout main
    commit
    checkout client1/base
    merge main tag:"sync base"
    checkout client1/main
    merge client1/base tag:"sync base"
    checkout client1/base
    branch client1/feature3
    commit
```
