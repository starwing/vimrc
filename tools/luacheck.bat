::reg:: --[=[
@echo off
lua -e "package.path=[[%~dp0\?.lua;%~dp0..\?\init.lua;]]..package.path" "%~f0" %*
goto :eof
::]=]

require "luacheck.main"
