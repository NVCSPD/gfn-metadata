:: InstallScript:FileOperation:Copy
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set SHORT_NAME=easy_anti_cheat_gfn
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\%SHORT_NAME%_init_bat.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo %DATE%_%TIME% Installing EAC v5.0 service >> %MY_LOG_PATH%

echo %DATE%_%TIME% Spawning %~dp0EACReplacer.exe >> %MY_LOG_PATH%
start "" "%~dp0EACReplacer.exe" 2>&1

echo %DATE%_%TIME% InstallScript finished >> %MY_LOG_PATH%
exit 0