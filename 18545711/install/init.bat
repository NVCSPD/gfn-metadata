:: InstallScript:ServiceInstall:AC-EAC
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\deadbydaylight_init_bat.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\dead_by_daylight_gfn_pc\common\Dead by Daylight\EasyAntiCheat" "" "EasyAntiCheat_Setup.exe" install 83 -console  >> %MY_LOG_PATH%
start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\dead_by_daylight_gfn_pc\common\Dead by Daylight\EasyAntiCheat" "" "EasyAntiCheat_Setup.exe" install 83 -console  >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is finished. >> %MY_LOG_PATH%

exit 0
