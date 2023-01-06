# Github SSH

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

## Console Record

```
kdanmobile@2021C15 .ssh % ssh-keygen -t rsa -C "yushiang.tseng@kdanmobile.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/kdanmobile/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/kdanmobile/.ssh/id_rsa
Your public key has been saved in /Users/kdanmobile/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:T5c5P+HLOB5qNy8j2tSE+rEM6PhTKuWoYNPAAgSIlDc yushiang.tseng@kdanmobile.com
The key's randomart image is:
+---[RSA 3072]----+
|*o.              |
|+. E             |
|. . .            |
|o          . o   |
|.o      S o * .  |
|. o   ...+ + + . |
|.o . +.oo + o +  |
|... oo+  *o+*+ o |
|  ...oo..o*+o*+  |
+----[SHA256]-----+
kdanmobile@2021C15 .ssh % ssh -v git@github.com
OpenSSH_8.6p1, LibreSSL 3.3.6
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 21: include /etc/ssh/ssh_config.d/* matched no files
debug1: /etc/ssh/ssh_config line 54: Applying options for *
debug1: Authenticator provider $SSH_SK_PROVIDER did not resolve; disabling
debug1: Connecting to github.com port 22.
debug1: Connection established.
debug1: identity file /Users/kdanmobile/.ssh/id_rsa type 0
debug1: identity file /Users/kdanmobile/.ssh/id_rsa-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_dsa type -1
debug1: identity file /Users/kdanmobile/.ssh/id_dsa-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ecdsa type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ecdsa-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ecdsa_sk type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ecdsa_sk-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ed25519 type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ed25519-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ed25519_sk type -1
debug1: identity file /Users/kdanmobile/.ssh/id_ed25519_sk-cert type -1
debug1: identity file /Users/kdanmobile/.ssh/id_xmss type -1
debug1: identity file /Users/kdanmobile/.ssh/id_xmss-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_8.6
debug1: Remote protocol version 2.0, remote software version babeld-5ac5b432
debug1: compat_banner: no match: babeld-5ac5b432
debug1: Authenticating to github.com:22 as 'git'
debug1: load_hostkeys: fopen /Users/kdanmobile/.ssh/known_hosts: No such file or directory
debug1: load_hostkeys: fopen /Users/kdanmobile/.ssh/known_hosts2: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts2: No such file or directory
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ssh-ed25519
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: SSH2_MSG_KEX_ECDH_REPLY received
debug1: Server host key: ssh-ed25519 SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU
debug1: load_hostkeys: fopen /Users/kdanmobile/.ssh/known_hosts: No such file or directory
debug1: load_hostkeys: fopen /Users/kdanmobile/.ssh/known_hosts2: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts2: No such file or directory
debug1: hostkeys_find_by_key_hostfile: hostkeys file /Users/kdanmobile/.ssh/known_hosts does not exist
debug1: hostkeys_find_by_key_hostfile: hostkeys file /Users/kdanmobile/.ssh/known_hosts2 does not exist
debug1: hostkeys_find_by_key_hostfile: hostkeys file /etc/ssh/ssh_known_hosts does not exist
debug1: hostkeys_find_by_key_hostfile: hostkeys file /etc/ssh/ssh_known_hosts2 does not exist
The authenticity of host 'github.com (20.27.177.113)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey in after 134217728 blocks
debug1: Will attempt key: yushiang.tseng@kdanmobile.com RSA SHA256:w1YLHIrh9hP2s9zr1H6MupPMRR0bh3y7lt1jRjwo6uo agent
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_rsa RSA SHA256:T5c5P+HLOB5qNy8j2tSE+rEM6PhTKuWoYNPAAgSIlDc
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_dsa 
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_ecdsa 
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_ecdsa_sk 
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_ed25519 
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_ed25519_sk 
debug1: Will attempt key: /Users/kdanmobile/.ssh/id_xmss 
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<ssh-ed25519-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,sk-ecdsa-sha2-nistp256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ecdsa-sha2-nistp256@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256,rsa-sha2-512,rsa-sha2-256,ssh-rsa>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey
debug1: Next authentication method: publickey
debug1: Offering public key: yushiang.tseng@kdanmobile.com RSA SHA256:w1YLHIrh9hP2s9zr1H6MupPMRR0bh3y7lt1jRjwo6uo agent
debug1: Authentications that can continue: publickey
debug1: Offering public key: /Users/kdanmobile/.ssh/id_rsa RSA SHA256:T5c5P+HLOB5qNy8j2tSE+rEM6PhTKuWoYNPAAgSIlDc
debug1: Authentications that can continue: publickey
debug1: Trying private key: /Users/kdanmobile/.ssh/id_dsa
debug1: Trying private key: /Users/kdanmobile/.ssh/id_ecdsa
debug1: Trying private key: /Users/kdanmobile/.ssh/id_ecdsa_sk
debug1: Trying private key: /Users/kdanmobile/.ssh/id_ed25519
debug1: Trying private key: /Users/kdanmobile/.ssh/id_ed25519_sk
debug1: Trying private key: /Users/kdanmobile/.ssh/id_xmss
debug1: No more authentication methods to try.
git@github.com: Permission denied (publickey).
kdanmobile@2021C15 .ssh % ssh-agent -s
SSH_AUTH_SOCK=/var/folders/w4/wdfmcxs51mjf_kbv2bw01n_m0000gn/T//ssh-7du4e4rNZ94L/agent.36068; export SSH_AUTH_SOCK;
SSH_AGENT_PID=36069; export SSH_AGENT_PID;
echo Agent pid 36069;
kdanmobile@2021C15 .ssh % ssh-add ~/.ssh/id_rsa
Identity added: /Users/kdanmobile/.ssh/id_rsa (yushiang.tseng@kdanmobile.com)
kdanmobile@2021C15 .ssh % cat id_rsa.pub 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvr1T9CkxijO89o0pO4cMfACxQEopo9iW1lXlPymlPssLi2SEhXN7JPpSZwE+1/I1w+mmzt8fSzPg/0DkISBCw/T5CSr8pO4KVwp1nn0d76WlBChBVIa96wfsab23NbdON2kwTpNevYhsrIakqjS1AYYd/dxNKOqO159FkO3rxb5DkQUZJNOJsNkp3K0npkgGysAPmmiJr+sdHB9Fe8ZOiEzQ8jQtfBc1TU50vBA3m3bTLCxB0BxqtYXfPRtQXJr7b/uY3HkktAAIn9mo1LWfQVehpQhttK5UdRTBDoP0sMV6jF6IRKwG8YSzj9r37mCHQtu02ZBK9OttcqRVAf8+F8PZdH+qybvnjyWs4oXIyBJUrilxo5w1SPrPD2r5NCDV0lfaxYEyWj5uEipRNnNQcfKOe9Aq5glvQGysR0hu/1NgVY3G+EnLyzvMUiylosCpETq8A3JSJrkW8OzNADsA3sOGstA9IBE5LRFXHo7b37C13tPfiFWhgteuAADEsBdk= yushiang.tseng@kdanmobile.com
kdanmobile@2021C15 .ssh % ssh -T git@github.com
Hi kdan-yushiang! You've successfully authenticated, but GitHub does not provide shell access.

kdanmobile@2021C15 .ssh % cd /Users/kdanmobile/Desktop 
kdanmobile@2021C15 Desktop % mkdir nextjs
kdanmobile@2021C15 Desktop % echo "# nextjs" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:kdan-yushiang/nextjs.git
git push -u origin main
提示：將「master」設定為初始分支的名稱。這個預設分支名稱可以變更。
提示：如果要設定所有新版本庫要使用的初始分支名稱，
提示：請呼叫（會隱藏這個警告）：
提示：
提示：	git config --global init.defaultBranch <name>
提示：
提示：除了 “master” 外，常用的分支名稱有 “main”, “trunk” 以及
提示：“development”。剛建立的分支可以用這個命令重新命名：
提示：
提示：	git branch -m <name>
已初始化空的 Git 版本庫於 /Users/kdanmobile/Desktop/.git/
[master (根提交) fc214f4] first commit
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
枚舉物件: 3, 完成.
物件計數中: 100% (3/3), 完成.
寫入物件中: 100% (3/3), 224 位元組 | 224.00 KiB/s, 完成.
總共 3 (差異 0)，復用 0 (差異 0)，重用包 0
To github.com:kdan-yushiang/nextjs.git
 * [new branch]      main -> main
已將「main」分支設定為追蹤「origin/main」。
```

## Reference

- [tutorial](https://blog.csdn.net/qq_40047019/article/details/122898308)