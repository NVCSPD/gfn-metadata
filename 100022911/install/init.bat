:: InstallScript:ServiceInstall:GOG InstallScript:FileOperation:Xcopy
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set GFN_SHORTNAME=gog_galaxy
set source_dir=C:\Program Files (x86)\NVIDIA_Grid_Bundle\%GFN_SHORTNAME%
set MSQ=C:\asgard\services\masquerade\msq.exe
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\%GFN_SHORTNAME%_init_bat.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo %DATE%_%TIME%  mklink /d /j "C:\ProgramData\GOG.com" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\pdata\GOG.com" >> %MY_LOG_PATH%
mklink /d /j "C:\ProgramData\GOG.com" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\pdata\GOG.com" >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME%  mklink /d /j "C:\Users\Kiosk\AppData\Local\GOG.com" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\lappdata\GOG.com" >> %MY_LOG_PATH%
mklink /d /j "C:\Users\Kiosk\AppData\Local\GOG.com" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\lappdata\GOG.com" >> %MY_LOG_PATH% 2>&1

echo xcopy /y /i /s /h /o "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\GOG Galaxy" "C:\Program Files (x86)\GOG Galaxy"  >> %MY_LOG_PATH%
xcopy /y /i /s /h /o "C:\Program Files (x86)\NVIDIA_Grid_Bundle\gog_galaxy\GOG Galaxy" "C:\Program Files (x86)\GOG Galaxy"  >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME%  icacls "C:\ProgramData\GOG.com" /t /grant Users:(OI)(CI)F >> %MY_LOG_PATH% 
icacls "C:\ProgramData\GOG.com" /t /grant Users:(OI)(CI)F 
echo %DATE%_%TIME%  icacls "C:\Users\Kiosk\AppData\Local\GOG.com" /t /grant Users:(OI)(CI)F >> %MY_LOG_PATH% 2>&1
icacls "C:\Users\Kiosk\AppData\Local\GOG.com" /t /grant Users:(OI)(CI)F
echo %DATE%_%TIME%  icacls "C:\Program Files (x86)\GOG Galaxy" /t /grant Users:(OI)(CI)F >> %MY_LOG_PATH% 2>&1
icacls "C:\Program Files (x86)\GOG Galaxy" /t /grant Users:(OI)(CI)F

echo %DATE%_%TIME% Running Dummy EXPLORER.EXE as Kiosk >> %MY_LOG_PATH%
echo %DATE%_%TIME% "%~dp0CreateProcAsActiveUser.exe" --logpath %MY_LOG_PATH% --path "%~dp0explorer.exe" --cmdline explorer.exe --dir "C:" >> %MY_LOG_PATH%
"%~dp0CreateProcAsActiveUser.exe" --logpath %MY_LOG_PATH% --path "%~dp0explorer.exe" --cmdline explorer.exe --dir "C:" 2>&1

echo %DATE%_%TIME% Installing GOG services>> %MY_LOG_PATH%

echo %DATE%_%TIME% sc create GalaxyClientService type=own start=demand error=normal binpath="C:\Program Files (x86)\GOG Galaxy\GalaxyClientService.exe" displayname=GalaxyClientService >> %MY_LOG_PATH%
sc create GalaxyClientService type=own start=demand error=normal binpath="C:\Program Files (x86)\GOG Galaxy\GalaxyClientService.exe" displayname=GalaxyClientService >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% sc create GalaxyCommunication type=own start=demand error=normal binpath="C:\ProgramData\GOG.com\Galaxy\redists\GalaxyCommunication.exe" displayname=GalaxyCommunication >> %MY_LOG_PATH%
sc create GalaxyCommunication type=own start=demand error=normal binpath="C:\ProgramData\GOG.com\Galaxy\redists\GalaxyCommunication.exe" displayname=GalaxyCommunication >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service GalaxyClientService /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service GalaxyClientService /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service GalaxyCommunication /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service GalaxyCommunication /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% InstallScript done. >> %MY_LOG_PATH%

exit 0


