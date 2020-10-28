# GitHub API

- backup all repos:

    - Add Personal access tokens at `Settings/Developer/Personal access tokens`
    - replace `tsengyushiang`, `1bb635a629d7d803c02af48188df34b710ec0786` and run backup shell:
    
        ```
        GHUSER=tsengyushiang; 
        curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+is:private" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone
        ```
    - [search by something](https://docs.github.com/en/free-pro-team@latest/github/searching-for-information-on-github/searching-for-repositories)