:: InstallScript:ServiceInstallation InstallScript:FileOperation:ProvideAdminRights
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\init_bat.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

TASKKILL /f /im OriginWebHelperService.exe >> %MY_LOG_PATH%
TASKKILL /f /im OriginClientService.exe >> %MY_LOG_PATH%

ping 8.8.8.8 >> %MY_LOG_PATH%

echo %DATE%_%TIME% sc create "Origin Client Service"  binpath= "C:\Program Files (x86)\NVIDIA_Grid_Bundle\ea_origin\OriginClientService.exe" start= auto >> %MY_LOG_PATH%
sc create "Origin Client Service" binpath= "C:\Program Files (x86)\NVIDIA_Grid_Bundle\ea_origin\OriginClientService.exe" start= auto >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% sc create "Origin Web Helper Service" binpath= "C:\Program Files (x86)\NVIDIA_Grid_Bundle\ea_origin\OriginWebHelperService.exe" start= auto >> %MY_LOG_PATH%
sc create "Origin Web Helper Service" binpath= "C:\Program Files (x86)\NVIDIA_Grid_Bundle\ea_origin\OriginWebHelperService.exe" start= auto >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service "Origin Client Service" /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service "Origin Client Service" /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% "%~dp0subinacl.exe" /service "Origin Web Helper Service"  /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service "Origin Web Helper Service" /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

icacls "C:\programdata\Electronic Arts" /grant Kiosk:(OI)(CI)F /T >> %MY_LOG_PATH% 2>&1
icacls "C:\programdata\Origin" /grant Kiosk:(OI)(CI)F /T >> %MY_LOG_PATH% 2>&1
icacls "C:\Program Files (x86)\NVIDIA_Grid_Bundle" /grant Kiosk:(OI)(CI)F >> %MY_LOG_PATH% 2>&1

attrib +R "C:\ProgramData\Origin\Telemetry\data" >> %MY_LOG_PATH% 2>&1
attrib +R "C:\ProgramData\Origin\Telemetry\tmh" >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% deleting C:\ProgramData\Origin\Logs\* >> %MY_LOG_PATH%
del /q "C:\ProgramData\Origin\Logs\*" >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% deleting directory C:\ProgramData\Origin\Logs >> %MY_LOG_PATH%
rd /s /q "C:\ProgramData\Origin\Logs" >> %MY_LOG_PATH% 2>&1
echo %DATE%_%TIME% create link C:\ProgramData\Origin\Logs to C:\Asgard\logs\SessionMngr >> %MY_LOG_PATH%
mklink /d /j "C:\ProgramData\Origin\Logs" "C:\Asgard\logs\SessionMngr" >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Spawning %~dp0OriginWatcher.exe >> %MY_LOG_PATH%
start "" "%~dp0OriginWatcher.exe" 2>&1

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Temporary WAR for gfndesktop bug (nvbugs/3559299, GAMEINC-321)                          ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo %DATE%_%TIME% Icacls c:\asgard\conf\Honeycomb_bg_3840x2160.bmp /grant kiosk:F /T >> %MY_LOG_PATH%
Icacls c:\asgard\conf\Honeycomb_bg_3840x2160.bmp /grant kiosk:F /T >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Icacls c:\asgard\tools\gfndesktop /grant kiosk:F /T >> %MY_LOG_PATH%
Icacls c:\asgard\tools\gfndesktop /grant kiosk:F /T >> %MY_LOG_PATH% 2>&1

tasklist /fi "ImageName eq gfndesktop.exe" /fo csv 2>NUL | find /I "gfndesktop.exe">NUL
IF "%ERRORLEVEL%"=="0" (
	echo %DATE%_%TIME% GfnDesktop.exe is running, replacing it with a custom one >> %MY_LOG_PATH%
	echo %DATE%_%TIME% killing gfndesktop processes >> %MY_LOG_PATH%
	taskkill /f /im gfndesktop* >> %MY_LOG_PATH% 2>&1

	ping -n 2 127.0.0.1

	echo %DATE%_%TIME% copy "%~dp0gfndesktop.exe" /Y /B "C:\Windows\" >> %MY_LOG_PATH%
	copy "%~dp0gfndesktop.exe" /Y /B "C:\Windows\gfndesktop.exe" >> %MY_LOG_PATH% 2>&1

	echo %DATE%_%TIME% schtasks /Run /TN "EnableGfnDesktopKiosk" >> %MY_LOG_PATH%
	schtasks /Run /TN "EnableGfnDesktopKiosk" >> %MY_LOG_PATH% 2>&1
) ELSE (
	echo %DATE%_%TIME% explorer.exe is running, replacing it with a custom gfndesktop >> %MY_LOG_PATH%
	echo %DATE%_%TIME% killing explorer processes >> %MY_LOG_PATH%
	taskkill /f /im explorer* >> %MY_LOG_PATH% 2>&1

	ping -n 2 127.0.0.1

	echo %DATE%_%TIME% copy "%~dp0gfndesktop.exe" /Y /B "C:\Windows\explorer.exe" >> %MY_LOG_PATH%
	copy "%~dp0gfndesktop.exe" /Y /B "C:\Windows\explorer.exe" >> %MY_LOG_PATH% 2>&1

	echo %DATE%_%TIME% schtasks /Run /TN "Enabledefaultexplorerkiosk" >> %MY_LOG_PATH%
	schtasks /Run /TN "Enabledefaultexplorerkiosk" >> %MY_LOG_PATH% 2>&1
)

echo %DATE%_%TIME% InstallScript finished >> %MY_LOG_PATH%
exit 0