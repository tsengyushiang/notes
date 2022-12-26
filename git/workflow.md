# Fork Workflow

- [view on github](https://github.com/tsengyushiang/notes/blob/master/git/workflow.md)

## Develop Git Graph

``` mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
    commit
    branch fork/main order: 5
    checkout main
    commit
    branch base/feature order: 1
    checkout fork/main
    commit tag:"repo for client1" type: HIGHLIGHT
    branch fork/dev order: 7
    commit tag:"develop branch"
    checkout base/feature
    commit
    checkout main
    merge base/feature tag:"new feature MR"
    commit
    checkout fork/main
    merge main tag:"sync base"
    checkout main
    commit
    branch base/fix-feature order: 2
    checkout fork/dev
    merge fork/main
    branch fork/feature order: 8
    commit
    checkout fork/dev
    merge fork/feature tag:"new feature MR"
    checkout base/fix-feature
    commit
    checkout main
    merge base/fix-feature tag:"solve issue MR"
    commit
    checkout fork/main
    merge main tag:"sync base"
    checkout fork/dev
    merge fork/main
    checkout fork/main
    commit
    branch fork/fix-base order:6
    commit
    checkout fork/dev
    branch fork/fix-feature order: 9
    commit
    checkout fork/dev
    merge fork/fix-feature tag:"solve issue MR"
    
    checkout fork/main
    merge fork/fix-base tag:"solve base issue"
    checkout main
    merge fork/main tag:"solve issue from fork"
    checkout main
    commit
    checkout fork/main
    merge main tag:"sync base"
    checkout fork/dev
    merge fork/main tag:"sync base"
    checkout fork/dev
    branch fork/feature2 order:11
    commit
```

## Merge Requests

|develop actions|branch's base|MR from|MR to|
|:---|:---:|:---:|:---:|
|base feature|`main`|`feature`|`main`|
|fix base feature|`main`|`fix`|`main`|
|customize feature|`fork/dev`|`fork/feature`|`fork/dev`|
|fix customize feature|`fork/dev`|`fork/fix`|`fork/dev`|
|fix base issue in frok|`fork/main`|`fork/fix-base`|`fork/main`|
|sync base|-|`main`|`fork/main`|
|update fix to base|-|`fork/main`|`main`|