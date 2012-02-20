@echo off
if NOT "%VIM%" == "" (
  start %VIM%/Vim72/gvim.exe
) else (
  :loop
  if "%CD:~3%" == "" exit

  if EXIST vim72 (
    start vim72/gvim.exe
  ) else (
    cd..
    goto :loop
  )

)