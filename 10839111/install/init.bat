:: InstallScript:ServiceInstall:AC-EAC InstallScript:FileOperation:Copy
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\war_thunder_gfn_pc.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

echo move /Y "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\win64\cefprocess.exe" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\win64\cefprocess.exe.bak" >>%MY_LOG_PATH% 2>&1
move /Y "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\win64\cefprocess.exe" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\win64\cefprocess.exe.bak" >>%MY_LOG_PATH% 2>&1


echo move /Y "B:\Asgard\GameLibrary\10839111\build\WarThunder\win64\cefprocess.exe" "B:\Asgard\GameLibrary\10839111\build\WarThunder\win64\cefprocess.exe.bak" >>%MY_LOG_PATH% 2>&1
move /Y "B:\Asgard\GameLibrary\10839111\build\WarThunder\win64\cefprocess.exe" "B:\Asgard\GameLibrary\10839111\build\WarThunder\win64\cefprocess.exe.bak" >>%MY_LOG_PATH% 2>&1


echo %DATE%_%TIME% start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\EasyAntiCheat" "" "EasyAntiCheat_Setup.exe"  install 45 -console
start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\war_thunder_gfn_pc\WarThunder\EasyAntiCheat" "" "EasyAntiCheat_Setup.exe"  install 45 -console >> %MY_LOG_PATH% 2>&1

echo "%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1
"%~dp0subinacl.exe" /service EasyAntiCheat /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is completed. >> %MY_LOG_PATH%
exit 0