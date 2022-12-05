@echo off
rem -- Run Vim --

set VIM_EXE_DIR=%~dp0\Vim90
if exist "%VIM%\vim73\gvim.exe" set VIM_EXE_DIR=%VIM%\vim73
if exist "%VIM%\vim74\gvim.exe" set VIM_EXE_DIR=%VIM%\vim74
if exist "%VIM%\vim81\gvim.exe" set VIM_EXE_DIR=%VIM%\vim81
if exist "%VIM%\vim82\gvim.exe" set VIM_EXE_DIR=%VIM%\vim82
if exist "%VIMRUNTIME%\gvim.exe" set VIM_EXE_DIR=%VIMRUNTIME%

if exist "%VIM_EXE_DIR%\vim.exe" goto havevim
echo "%VIM_EXE_DIR%\vim.exe" not found
goto eof

:havevim
rem collect the arguments in VIMARGS for Win95
set VIMARGS=
:loopstart
if .%1==. goto loopend
set VIMARGS=%VIMARGS% %1
shift
goto loopstart
:loopend

if .%OS%==.Windows_NT goto ntaction

"%VIM_EXE_DIR%\vim.exe"  %VIMARGS%
goto eof

:ntaction
rem for WinNT we can use %*
"%VIM_EXE_DIR%\vim.exe"  %*
goto eof


:eof
set VIMARGS=
