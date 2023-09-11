# Others

## Linux Commands

### Text Editor - Vim

- `apt-get update`
- `apt-get install vim`
- `vim <filename>` : open/create file
- `i` : enter edit mode
- `Esc`, type `:x` then `Enter` : exit vim


### File Transmit

 - `scp -r <soure/path> <dst/path>`
    - `<soure/path>`, `<dst/path>` : `username@IP:path`


### Run in background - Screen

- `apt-get update`
- `apt-get install screen`
- `screen`, type command, `ctrl`+`a` then `d` to exit
- `screen -ls`: list all process
- `screen -r <process id>`: enter running process

### Port - lsof

- `apt-get update`
- `apt-get install lsof`
- `lsof -i -P -n` : print using ports

### Check available package version

- `apt update`
- `apt-cache policy <packageName>`

- Example of getting available version of `curl`, then we can specify in `dockerfile` using `RUN apt update && apt install curl=7.64.0-4+deb10u6 -y`.

```.
test@2023 ~ % docker run -it node:16.13.1-slim bash
root@795660af5321:/# apt update
Get:1 http://security.debian.org/debian-security buster/updates InRelease [34.8 kB]
Get:2 http://deb.debian.org/debian buster InRelease [122 kB]
Get:3 http://security.debian.org/debian-security buster/updates/main arm64 Packages [541 kB]
Get:4 http://deb.debian.org/debian buster-updates InRelease [56.6 kB]
Get:5 http://deb.debian.org/debian buster/main arm64 Packages [7737 kB]
Get:6 http://deb.debian.org/debian buster-updates/main arm64 Packages [8780 B]                                                                                    
Fetched 8500 kB in 19s (447 kB/s)                                                                                                                                 
Reading package lists... Done
Building dependency tree       
Reading state information... Done
20 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@795660af5321:/# apt-cache policy curl
curl:
  Installed: (none)
  Candidate: 7.64.0-4+deb10u6
  Version table:
     7.64.0-4+deb10u6 500
        500 http://security.debian.org/debian-security buster/updates/main arm64 Packages
     7.64.0-4+deb10u2 500
        500 http://deb.debian.org/debian buster/main arm64 Packages
```
