:: InstallScript:ServiceInstallation
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\uplay_init_bat.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

REM --------------------------------------------------
REM Installing services
REM --------------------------------------------------

echo %DATE%_%TIME% sc create UplayService binpath= "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UplayService.exe" start= auto >> %MY_LOG_PATH%
sc create UplayService binpath= "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UplayService.exe" start= auto >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% sc create UplayWebCore binpath= "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UplayWebCore.exe" start= auto >> %MY_LOG_PATH%
sc create UplayWebCore binpath= "C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\UplayWebCore.exe" start= auto >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service UplayService /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service UplayService /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service UplayWebCore /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service UplayWebCore /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo "%~dp0subinacl.exe" /subkeyreg "HKEY_CLASSES_ROOT\uplay" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1
"%~dp0subinacl.exe" /subkeyreg "HKEY_CLASSES_ROOT\uplay" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1

echo "%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\uplay" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1
"%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\uplay" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1

echo reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ubisoft" /F >> %MY_LOG_PATH% 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ubisoft" /F >> %MY_LOG_PATH% 2>&1

echo "%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ubisoft" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1
"%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Ubisoft" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1


echo %DATE%_%TIME% Done. >> %MY_LOG_PATH% 2>&1
exit 0

exit 0