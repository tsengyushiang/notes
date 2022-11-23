# Revert Merge Request

## Scenario

- `feature2`'s MR and `feature1`'s MR are waiting code review

```mermaid
gitGraph
  commit id:"init project"
  branch dev
  commit id:"dev1"
  branch feature1 order:2
  commit id:"feature1"
  checkout dev
  commit id:"dev2"
  branch feature2 order:1
  commit id:"feature2"
  checkout feature1
  commit id:"feature1.1" tag:"MR : feature1 to dev"
  checkout feature2
  merge feature1
  commit id:"feature2.1" tag:"MR : feature2 to dev"
  checkout dev
  commit id:"dev3"
```

## Merge without code review accidentally

- what happened:
  - `feature2`'s author accidentally click the merge button on gitlab merge request ui.
  - Then, gitlab automatically merge `feature2` and `feature1` into `dev`, and both MR is mark as merged.
  - `feature1` and `feature2` can no longer merge to `dev`, becase they already exist in history.

```mermaid
gitGraph
  commit id:"init project"
  branch dev
  commit id:"dev1"
  branch feature1 order:2
  commit id:"feature1"
  checkout dev
  commit id:"dev2"
  branch feature2 order:1
  commit id:"feature2"
  checkout feature1
  commit id:"feature1.1"
  checkout feature2
  merge feature1
  commit id:"feature2.1"
  checkout dev
  merge feature2 tag:"${merge}"
  commit id:"dev4"
  branch revert_feature2
  commit id:"revert-feature2" tag:"${revert}"
  checkout dev
  merge revert_feature2
  branch feature2_Reopen order:3
  commit id:"rever-revert-feature2"
```

### Revert merge

```
git checkout dev
git branch revert_feature2
git checkout revert_feature2
git revert ${merge commit id} -m 1
:q
git checkout dev
git merge revert-feature2
git push
```

### Reopen Feature2

```
git checkout feature2
git push
git merge dev
git revert ${revert commit id} -m 1
:q
git push
```

### Problem

- Can't recover `feature1` with `git revert`.
- Some code of `feature1` stuck in `feature2`, such as commits `feature1`,`feature1.1` in above case.

### Conclusion

- Don't merge any feature branch to any other branch, only merge with `base branch`, or one the them is deprecated.
- Uses `rebase` to move whole branch to the other branch for some functions.

## Reproduce scenario with gitlab

- init repo

  ```
  git clone ${repo/on/gitlab}
  git branch dev
  git checkout dev
  touch dev1
  git add .
  git commit -m "dev1"
  git branch feature1
  git checkout feature1
  touch feature1
  git add .
  git commit -m "feature1"
  git checkout dev
  touch dev2
  git add .
  git commit -m "dev2"
  git branch feature2
  git checkout feature2
  touch feature2
  git add .
  git commit -m "feature2"
  git checkout feature1
  touch feature1.1
  git add .
  git commit -m "feature1.1" 
  git checkout feature2
  git merge feature1
  touch feature2.1
  echo "change feature1.1" > feature1.1
  git add .
  git commit -m "feature2.1" 
  git checkout dev
  touch dev3
  git add .
  git commit -m "dev3" 
  git push --set-upstream origin dev
  git checkout feature1
  git push --set-upstream origin feature1
  git checkout feature2
  git push --set-upstream origin feature2

  ```

- create MR on gitlab : `feature1 to dev`, `feature2 to dev`
- merge MR `feature2 to dev`
- `git remote update --prune` and you will see git graph the same as `Merge without code review accidentally` section.
