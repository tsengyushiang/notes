# Github SSH


## Setup

- `ssh-keygen -t rsa -C "${email}"`
- `ssh -v git@github.com` and type `yes` for connecting

  ```
    The authenticity of host 'github.com (20.27.177.113)' can't be established.
    ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
    This key is not known by any other names
    Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
  ```

- `ssh-agent -s`

- `ssh-add ~/.ssh/id_rsa`

- `cat id_rsa.pub` and paste value to [Github SSH Keys](https://github.com/settings/keys)

- `ssh -T git@github.com`
  
  ```
  Hi ${username show here}! You've successfully authenticated, but GitHub does not provide shell access.
  ``` 

## Reference

- [Tutorial](https://blog.csdn.net/qq_40047019/article/details/122898308)
