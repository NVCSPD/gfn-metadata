:: InstallScript:FileOperation:Delete
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\unravel_two_steam_init_bat.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%
echo %DATE%_%TIME% Installing CODEC  >> %MY_LOG_PATH%

echo COPY AACACM.acm C:\Windows\System32\AACACM.acm >> %MY_LOG_PATH%
COPY AACACM.acm C:\Windows\System32\AACACM.acm >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Reg import app.reg >> %MY_LOG_PATH%
Reg import app.reg >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is finished. >> %MY_LOG_PATH%

exit 0