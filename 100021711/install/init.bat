:: InstallScript:ServiceInstall:Steam InstallScript:ServiceStart InstallScript:FileOperation:Copy InstallScript:FileOperation:Xcopy InstallScript:FileOperation:Delete InstallScript:mklink
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\steam_client_init_bat.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo mkdir "C:\Program Files (x86)\Common Files\Steam" >> %MY_LOG_PATH%
mkdir "C:\Program Files (x86)\Common Files\Steam" >> %MY_LOG_PATH% 2>&1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: WAR FOR COMMON REDISTS                                                     ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
IF EXIST "C:\Program Files (x86)\NVIDIA_Grid_Bundle\steamworks_common_redistributables" (
	md "C:\Program Files (x86)\steam\steamapps\common" >> %MY_LOG_PATH% 2>&1
	mklink /d /j "C:\Program Files (x86)\steam\steamapps\common\Steamworks Shared" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\steamworks_common_redistributables\common\Steamworks Shared" >> %MY_LOG_PATH% 2>&1
) ELSE (
	md "C:\Program Files (x86)\steam\steamapps\" >> %MY_LOG_PATH% 2>&1
)
echo %DATE%_%TIME% copy appmanifest_228980.acf "C:\Program Files (x86)\steam\steamapps\" /Y /B >> %MY_LOG_PATH% 2>&1
copy appmanifest_228980.acf "C:\Program Files (x86)\steam\steamapps\" /Y /B >> %MY_LOG_PATH% 2>&1
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
del "C:\Program Files (x86)\Steam\appcache\appinfo.vdf" /Q >> %MY_LOG_PATH% 2>&1
del "C:\Program Files (x86)\Steam\appcache\localization.vdf" /Q >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% xcopy "C:\Program Files (x86)\Steam\bin\steamservice.exe" "C:\Program Files (x86)\Common Files\Steam\steamservice.exe" >> %MY_LOG_PATH% 2>&1
xcopy "C:\Program Files (x86)\Steam\bin\steamservice.exe" "C:\Program Files (x86)\Common Files\Steam\" /S /Q /Y /F >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% xcopy "C:\Program Files (x86)\Steam\bin\SteamService.dll" "C:\Program Files (x86)\Common Files\Steam\SteamService.dll" >> %MY_LOG_PATH% 2>&1
xcopy "C:\Program Files (x86)\Steam\bin\SteamService.dll" "C:\Program Files (x86)\Common Files\Steam\" /S /Q /Y /F >> %MY_LOG_PATH% 2>&1
::setx -m PATH "C:\Program Files (x86)\Steam\;%PATH%";
echo %DATE%_%TIME% sc create "Steam Client Service"  binpath= "C:\Program Files (x86)\Common Files\Steam\SteamService.exe /RunAsService" start= auto >> %MY_LOG_PATH%
sc create "Steam Client Service" binpath= "C:\Program Files (x86)\Common Files\Steam\SteamService.exe /RunAsService" start= auto >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Applying custom Steam.cfg >> %MY_LOG_PATH%
echo %DATE%_%TIME% xcopy "%~dp0Steam.cfg" "C:\Program Files (x86)\Steam\" /S /Q /Y /F >> %MY_LOG_PATH%
xcopy "%~dp0Steam.cfg" "C:\Program Files (x86)\Steam\" /S /Q /Y /F >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service "Steam Client Service" /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service "Steam Client Service" /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

::Grant full access for kiosk
icacls "C:\Program Files (x86)\Steam\steamapps\common\Steamworks Shared" /grant Kiosk:(OI)(CI)F /T

echo %DATE%_%TIME% "%~dp0subinacl.exe" /subkeyreg HKEY_LOCAL_MACHINE\Software\Wow6432Node\Valve /grant=Kiosk=F >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /subkeyreg HKEY_LOCAL_MACHINE\Software\Wow6432Node\Valve /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Merging Steam and Session logs folders                                     ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo %DATE%_%TIME% del "C:\Program Files (x86)\Steam\logs\*" /Q >> %MY_LOG_PATH%
del "C:\Program Files (x86)\Steam\logs\*" /Q >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% rmdir "C:\Program Files (x86)\Steam\logs" /S /Q >> %MY_LOG_PATH%
rmdir "C:\Program Files (x86)\Steam\logs" /S /Q >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% mklink "C:\Program Files (x86)\Steam\logs" C:\Asgard\logs\SessionMngr /d /j >> %MY_LOG_PATH%

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Monitor corner case scenarios using MB Steam Watcher tool (GCE-2437)       ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo %DATE%_%TIME% Spawning %~dp0MBSteamWatcher.exe >> %MY_LOG_PATH%
start "" "%~dp0MBSteamWatcher.exe" 2>&1

echo %DATE%_%TIME% Install script is finished. >> %MY_LOG_PATH%
exit 0