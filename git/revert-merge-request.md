# Revert Merge Request

## Scenario

```mermaid
%%{init: { 'gitGraph': {'showCommitLabel': false}} }%%

gitGraph
  commit
  branch feature1 order:3
  commit
  checkout main
  commit
  branch feature2 order:2
  commit
  checkout feature1
  commit tag:"MR : feature1 to main"
  checkout feature2
  merge feature1
  commit tag:"MR : feature2 to main"
  checkout main
  commit
```
- `feature2`'s MR and `feature1`'s MR are waiting code review

## Merge without code review accidentally

```mermaid
gitGraph
  commit id:"main_0"
  branch feature1 order:3
  commit id:"feature1_0"
  checkout main
  commit id:"main_1"
  branch feature2 order:2
  commit id:"feature2_0"
  checkout feature1
  commit id:"feature1_1"
  checkout feature2
  merge feature1
  commit id:"feature2_1"
  checkout main
  commit id:"main_3"
  merge feature2
```

- what happened:
  - `feature2`'s author accidentally click the merge button on MR.
  -  merge `feature2` and `feature1` into `main`, and both MR is mark as merged.

### Revert merge

- `git revert ${accidentally merge commit id} -m 1`

### Reopen both MR

- `git checkout main`
- `git reset ${main_3 commit id}`
- `git checkout feature2`
- `git rebase main`
- `git push -f`
- `git checkout feature1`
- `git rebase main`
- `git push -f`

```mermaid
gitGraph
  commit id:"main_0"
  branch feature1 order:3
  commit id:"feature1_0"
  checkout main
  commit id:"main_1"
  branch feature2 order:2
  commit id:"feature2_0"
  checkout feature1
  commit id:"feature1_1"
  checkout feature2
  merge feature1
  commit id:"feature2_1"
  checkout main
  commit id:"main_3"
  branch feat1 order:11
  branch feat2 order:10
  checkout main
  merge feature2
  commit id:"revert_merge_feature2"
  checkout feat2
  commit id:"same_feature2_0"
  commit id:"same_feature2_1" tag:"MR : feature2 to main"
  checkout feat1
  commit id:"same_feature1_0"
  commit id:"same_feature1_1" tag:"MR : feature1 to main"

```
