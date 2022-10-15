# Git

## Log difference

- input
    ```
    git diff-tree -r --no-commit-id --name-status --text <source> <target>
    ```
    - `<source>`,`<target>` can be branch name, commit id
- output
    ```
    M       .github/workflows/GithubCICD.yml
    M       .gitignore
    M       README.md
    A       lib/isomorphic-git.ts
    M       package.json
    A       pages/isomorphic-git/index.tsx
    M       yarn.lock
    ```
    - state represent:
        * A - Added
        * C - Copied
        * D - Deleted
        * M - Modified
        * R - Renamed
        * T - have their type (mode) changed
        * U - Unmerged
        * X - Unknown
        * B - have had their pairing Broken
