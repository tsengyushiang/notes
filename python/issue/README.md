## issue

- Set ubuntu to UTF-8 for Python 3

   ```
    apt-get update
    apt-get install -y locales
    locale-gen en_US.UTF-8
    export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8
   ```
- Python setup.py `UnicodeDecodeError: 'utf-8' codec can't decode...`

   modify `cpp_extension.py`
   ```
   95 - info = info.decode().lower
   95 + info = info.decode('utf8','ignore').lower() 
   ```