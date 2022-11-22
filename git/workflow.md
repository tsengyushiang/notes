# Fork Workflow

- [view on github](https://github.com/tsengyushiang/notes/blob/master/git/workflow.md)

- develop on base repo, denote fork repo as `client1`.

```mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
    commit
    commit
    branch feature order: 1
    branch client1/main order: 5
    commit tag:"repo for client1" type: HIGHLIGHT
    branch client1/dev order: 6
    commit tag:"develop branch"
    checkout feature
    commit
    checkout client1/main
    branch client1/feature-customize order: 7
    merge feature tag:"sync MR1"
    checkout client1/dev
    commit
    checkout client1/feature-customize
    commit
    merge client1/dev
    commit
    checkout feature
    commit
    checkout client1/feature-customize
    merge feature tag:"sync MR2"
    checkout client1/dev
    merge client1/feature-customize tag:"new feature MR"
    checkout main
    merge feature tag:"new feature MR"
    checkout client1/feature-customize
    branch client1/fix-feature-customize order: 8
    commit
    checkout feature
    branch fix-feature order: 2
    commit
    checkout feature
    merge fix-feature
    checkout client1/feature-customize
    merge feature tag:"sync MR3"
    checkout main
    merge feature tag:"solve issue MR"
    checkout client1/fix-feature-customize
    commit
    checkout client1/feature-customize
    merge client1/fix-feature-customize
    checkout client1/dev
    merge client1/feature-customize tag:"solve issue MR"
    checkout client1/main
    branch client1/fix-base-issue order:10
    commit
    checkout client1/main
    merge client1/fix-base-issue
    checkout main
    branch fix-base-issue order:3
    merge client1/main tag:"solve issue from fork"
    checkout main
    merge fix-base-issue tag:"solve issue MR"
    commit
    checkout client1/main
    merge main tag:"sync base"
    checkout client1/dev
    merge client1/main tag:"sync base"
    checkout client1/main
    branch client1/feature2 order:11
    commit

```

- develop on fork repo, denote fork repo as `client1`.

```mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
    commit
    commit
    branch feature
    branch client1/main
    commit tag:"repo for client1" type: HIGHLIGHT
    branch client1/dev
    commit tag:"develop branch"
    checkout client1/main
    branch client1/feature
    commit
    checkout client1/dev
    branch client1/feature-customize
    merge client1/feature
    checkout client1/dev
    commit id:"other feature"
    checkout client1/feature-customize
    commit
    checkout client1/feature
    commit
    checkout client1/feature-customize
    merge client1/feature
    merge client1/dev
    checkout client1/dev
    merge client1/feature-customize tag:"new feature MR"
    checkout feature
    merge client1/feature tag:"new feature MR"
    checkout client1/feature-customize
    branch client1/fix-feature-customize
    commit
    checkout client1/feature
    branch client1/fix-feature
    commit
    checkout client1/feature
    merge client1/fix-feature
    checkout client1/feature-customize
    merge client1/feature
    checkout client1/fix-feature-customize
    commit
    checkout client1/feature-customize
    merge client1/fix-feature-customize
    checkout client1/dev
    merge client1/feature-customize  tag:"solve issue MR"
    checkout main
    checkout feature
    merge client1/feature tag:"solve issue MR"
    checkout main
    merge feature
    checkout client1/main
    branch client1/feature2
    commit
    checkout main
    commit
    checkout client1/main
    merge main tag:"sync base"
    checkout client1/dev
    merge client1/main tag:"sync base"
    checkout client1/main
    branch client1/feature3
    commit
```
