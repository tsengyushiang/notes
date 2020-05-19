## issue

- Set the locale to UTF-8 for Python 3

   ```
    apt-get update
    apt-get install -y locales
    locale-gen en_US.UTF-8
    export LANG=en_US.UTF-8 LANGUAGE=en_US.en LC_ALL=en_US.UTF-8
   ```