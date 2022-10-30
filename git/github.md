# GitHub

## Backup

- Add Personal access tokens at `Settings/Developer/Personal access tokens`
- replace `tsengyushiang`, `1bb635a629d7d803c02af48188df34b710ec0786` and run backup shell:

    ```
    GHUSER=tsengyushiang; 
    curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+is:private" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone
    ```
- [search by something](https://docs.github.com/en/free-pro-team@latest/github/searching-for-information-on-github/searching-for-repositories)

## Submodule :

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
