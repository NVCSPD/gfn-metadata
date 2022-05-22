:: InstallScript:mklink
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set "GFN_SHORTNAME=unravel_two_origin"
set "GAME_FOLDER=UnravelTwo"
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\%GFN_SHORTNAME%_init_bat.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

if not exist "C:\Program Files (x86)\Origin Games" (
  echo mkdir -p "C:\Program Files (x86)\Origin Games" >> %MY_LOG_PATH%
  mkdir -p "C:\Program Files (x86)\Origin Games" >> %MY_LOG_PATH% 2>&1
)

echo mklink /D /J "C:\Program Files (x86)\Origin Games\%GAME_FOLDER%" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\%GFN_SHORTNAME%" >> %MY_LOG_PATH%
mklink /D /J "C:\Program Files (x86)\Origin Games\%GAME_FOLDER%" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\%GFN_SHORTNAME%" >> %MY_LOG_PATH% 2>&1

if exist "C:\ProgramData\Origin\LocalContent" (
  echo rmdir /s /q "C:\ProgramData\Origin\LocalContent" >> %MY_LOG_PATH%
  rmdir /s /q "C:\ProgramData\Origin\LocalContent" >> %MY_LOG_PATH% 2>&1
)

echo mkdir -p "C:\ProgramData\Origin\LocalContent" >> %MY_LOG_PATH%
mkdir -p "C:\ProgramData\Origin\LocalContent" >> %MY_LOG_PATH% 2>&1

echo mklink /D /J "C:\ProgramData\Origin\LocalContent\%GAME_FOLDER%" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\%GFN_SHORTNAME%\_metadata" >> %MY_LOG_PATH%
mklink /D /J "C:\ProgramData\Origin\LocalContent\%GAME_FOLDER%" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\%GFN_SHORTNAME%\_metadata" >> %MY_LOG_PATH% 2>&1

echo install_origin_touchup.exe >> %MY_LOG_PATH%
install_origin_touchup.exe >> %MY_LOG_PATH% 2>&1

echo start /B origin_watcher.exe >> %MY_LOG_PATH%
start /B origin_watcher.exe

echo COPY AACACM.acm C:\Windows\System32\AACACM.acm >> %MY_LOG_PATH%
COPY AACACM.acm C:\Windows\System32\AACACM.acm >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Reg import app.reg >> %MY_LOG_PATH%
Reg import app.reg >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is finished. >> %MY_LOG_PATH%

exit 0