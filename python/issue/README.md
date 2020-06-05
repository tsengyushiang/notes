## issue

- Set ubuntu to UTF-8 for Python 3, need to set every time open terminal

   ```
    apt-get update
    apt-get install -y locales
    locale-gen en_US.UTF-8
    export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8
   ```
   - or can add command to `~/.bashrc`, and it will be execute automatically

- Python setup.py `UnicodeDecodeError: 'utf-8' codec can't decode...`

   modify `cpp_extension.py`
   ```
   95 - info = info.decode().lower
   95 + info = info.decode('utf8','ignore').lower() 
   ```