# Others

## Linux Commands

### SSH

- Create a `.pem` file on the virtual machine.
  
```
ssh-keygen -b 4096
cat .ssh/id_rsa.pub >> .ssh/authorized_keys
cp .ssh/id_rsa /home/your_user/your_key.pem
```

- Copy the content of the `.pem` file to the local machine and use it with SSH.

```
ssh -p 22 -i "C:\Users\YUSHIANG.TSENG\.ssh\yushiang.pem" yushiangtseng@localhost
```

> Unable to log in due to the error log message: `SSH Authentication Refused: Bad Ownership or Modes for Directory.`

- View the log on the virtual machine: `tail -f /var/log/auth.log`
- Resolve the issue by adjusting file permissions:
```
chmod go-w /home/your_user
chmod 700 /home/your_user/.ssh
chmod 600 /home/your_user/.ssh/authorized_keys
```

### Text Editor - Vim

- `apt-get update`
- `apt-get install vim`
- `vim <filename>` : open/create file
- `i` : enter edit mode
- `Esc`, type `:x` then `Enter` : exit vim

### Monitor Logs

- `tail -f <filename>` can continuously log file even it's changing.

### File Transmit

 - `scp -r <soure/path> <dst/path>`
    - `<soure/path>`, `<dst/path>` : `username@IP:path`


### Run in background - Screen

- `apt-get update`
- `apt-get install screen`
- `screen`, type command, `ctrl`+`a` then `d` to exit
- `screen -ls`: list all process
- `screen -r <process id>`: enter running process


### Fetch api - Curl

- download file from link

```
curl "${download_link}" --output ${filename.extension}
```

- test api

```
curl --location -g --request ${api_method} '${api_path}' \
--header 'Content-Type: application/json' \
--data-raw '{
 "key": "value", 
}'
```
### Schedule Jobs — crontab

- Run `crontab -e`, then press **i** to start editing.  
  Press **Esc** and type `:wq` to save and quit.  
  Example:

  ```
  # Run every minute (unix-cron-format)
  * * * * * /bin/bash /path/to/test.sh
  ```

- Use `crontab -l` to view current jobs.
- Use `crontab -r` to remove **all** jobs.
- Be careful: cron jobs do **not** run with the same environment as your shell, so always use absolute paths.  
  For example:

  ```diff
  - git clone http://...
  + /usr/bin/git clone http://...

  - echo "result" >> ./log.txt
  + echo "result" >> $HOME/where/is/your/folder/log.txt
  ```

- Make your script executable:

  ```bash
  chmod +x /path/to/test.sh
  ```

- Give cron permission on macOS, [Reference](https://www.bejarano.io/fixing-cron-jobs-in-mojave/)

1. Open **System Settings → Security & Privacy → Privacy**
2. Select **Full Disk Access**
3. Add **/usr/sbin/cron**

### Port - lsof

- `apt-get update`
- `apt-get install lsof`
- `lsof -i -P -n` : print using ports
> For windows, use `netstat -aof`

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
