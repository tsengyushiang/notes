# GPUInspector

## Ubuntu

- `watch -n <time> <command>`
- `<command>`
  - 記憶體 `free -m`
  - nvidia顯卡 `nvidia-smi`

## Windows
- 存成`.bat`檔,下方監控範例指令為`nvidia-smi`

  ```
  @ECHO OFF

  :: 執行的指令
  SET ExecuteCommand=nvidia-smi

  :: 單位: 秒
  SET ExecutePeriod=1

  SETLOCAL EnableDelayedExpansion

  :loop

    cls

    echo !date! !time!
    echo every !ExecutePeriod! second, command^: !ExecuteCommand!

    echo.

    %ExecuteCommand%
    
    timeout /t %ExecutePeriod% > nul

  goto loop
  ```