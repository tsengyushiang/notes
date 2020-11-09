## Widgets

- Property checker

    ```
    for att in dir(self.mesh):
        print (att, getattr(self.mesh,att))
    ```

- Pack to exe

    - [Reference](https://www.coderbridge.com/@WeiHaoEric/0b2ced0696cc4c38a62d7b26fa7bbea0)
    - `pip install pyinstaller`
    - `pyinstaller -F -n justRunMe main.py`
