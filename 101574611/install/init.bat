:: InstallScript:ServiceStart

@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\genshin_impact_init_bat.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo sc create mhyprot3 binPath="C:\Program Files (x86)\NVIDIA_Grid_Bundle\genshin_impact\mhyprot3.Sys" type=kernel >> %MY_LOG_PATH% 2>&1
@sc create mhyprot3 binPath="C:\Program Files (x86)\NVIDIA_Grid_Bundle\genshin_impact\mhyprot3.Sys" type=kernel >> %MY_LOG_PATH% 2>&1

echo net start mhyprot3 >> %MY_LOG_PATH% 2>&1
net start mhyprot3 >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Granting access to mhyprot3 >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service "mhyprot3" /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

exit 0

