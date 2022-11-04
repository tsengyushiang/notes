# Commands

## Fetch and Push

- stage all files

    ```
    git add .
    ```
- commit 
    ```
    git commit -m "write your commit message here"
    ```
- find remote
    ```
    git remote -v
    ```
- get remote branches

    ```
    git remote update origin --prune
    ```

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

- parse output to markdown table format by `sed`

    - Git bash
        
        - command

            ```
            git diff-tree -r --no-commit-id --name-status --indent-heuristic --text <source> <target> | sed -e 's/\t/|/' -e '1i|State|File|Description|' -e '1i|:---:|:---|:---|' -e 's/^/|/' -e 's/$/||/'
            ```

        - supplementary Instructions

            ```
            sed -e 's/\t/|/' : replace tab to "|".
            sed -e '1i|State|File|Description| -e '1i|---|---|---|'` : add table title to first line.
            sed -e 's/^/|/' -e 's/$/||/' : add "|" to begin and end. 
            ```
            
            - In macOS
            ```
            brew install gnu-sed
            alias sed=gsed //set everytime open a new bash
            ```
         
- output

    |State|File|Description|
    |:---:|:---|:---|
    |M|.github/workflows/GithubCICD.yml||
    |M|.gitignore||
    |M|README.md||
    |A|lib/isomorphic-git.ts||
    |M|package.json||
    |A|pages/isomorphic-git/index.tsx||
    |M|yarn.lock||

## Submodule

- create repo `subModule`
- create repo `application1`
- extend normal repo to subeModule repo 
    - clone normal repo `application1`
    - import another repo as submodule, after command `.gitmodules` and folder will be added 
        
        `git submodule add {cloneUrl of subModule repo}`
    - push the repo

- develope app repo with submodule work independently so,

    - add submodule code : push to `subModule`
    - add app code : push to `application1`

- clone app repo with submodule 
    - clone `application1`
    - cd `subModule` folder and `git submodule init`
    - `git submodule update`

- update submodule at parent
    - `git submodule update --remote`

- remove submodule
    - `git rm subModule`
    - `rm .git/modules/subModule`
    -  open `config` file, and remove following lines
        
        ```
        [submodule = "subModule"]
            acitvate = true
            url = https://~.git
        ```
