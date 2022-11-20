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
