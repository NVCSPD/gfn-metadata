:: InstallScript:ServiceInstall:AC-EAC
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\bdo_init_bat.log
set source_dir=C:\Program Files (x86)\NVIDIA_Grid_Bundle\black_desert_online_steam_gfn_pc\common\Black Desert Online

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

taskkill /f /im autohotkey.exe >> %MY_LOG_PATH%

echo %DATE%_%TIME% del "C:\Program Files (x86)\Steam\steamapps\common\Black Desert Online\EasyAntiCheat\installscript.vdf" /Q >> %MY_LOG_PATH%
del "C:\Program Files (x86)\Steam\steamapps\common\Black Desert Online\EasyAntiCheat\installscript.vdf" /Q >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Installing EAC. >> %MY_LOG_PATH%
echo "%source_dir%\EasyAntiCheat\EasyAntiCheat_Setup.exe" install 528 -console >> %MY_LOG_PATH%
start /WAIT /d "%source_dir%\EasyAntiCheat" "" "EasyAntiCheat_Setup.exe"  install 614 -console >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Replacing EAC exe with the signed one. >> %MY_LOG_PATH%
echo copy /y /b "%~dp0EasyAntiCheat.exe" "C:\Program Files (x86)\EasyAntiCheat\EasyAntiCheat.exe" >> %MY_LOG_PATH%
copy /y /b "%~dp0EasyAntiCheat.exe" "C:\Program Files (x86)\EasyAntiCheat\EasyAntiCheat.exe" >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Disabling PS_DX12_SURFACE_PLACEMENT_LOCK_CACHING >> %MY_LOG_PATH%
"C:\Asgard\tools\d3dreg.exe" PS_DX12_SURFACE_PLACEMENT_LOCK_CACHING=OFF >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is finished. >> %MY_LOG_PATH%

exit 0