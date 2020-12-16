GHUSER=tsengyushiang;
LATESTBACKUPDATE=2020-10-28;
curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+is:private+pushed:>$LATESTBACKUPDATE" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone
curl -H 'Authorization: token 1bb635a629d7d803c02af48188df34b710ec0786' -s "https://api.github.com/search/repositories?q=user:$GHUSER+pushed:>$LATESTBACKUPDATE" | grep -w clone_url | grep -o '[^"]\+://.\+.git' | xargs -L1 git clone