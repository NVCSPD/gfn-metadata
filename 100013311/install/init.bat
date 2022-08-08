:: InstallScript:Regedit InstallScript:ServiceInstall:AC-BattleEye InstallScript:ServiceInstall:AC-EAC
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\fortnite_gfn_pc.log
echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%
:: mklink /j /d "C:\Program Files\Epic Games" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\Epic Games" >> %MY_LOG_PATH% 2>&1
mklink /j /d "C:\Program Files (x86)\Epic Games" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\Epic Games Launcher" >> %MY_LOG_PATH% 2>&1
mklink /j /d "C:\ProgramData\Epic" "C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\pdata\Epic" >> %MY_LOG_PATH% 2>&1

::temporary add disable encryption for d3dreg
set D3DREG="c:\asgard\tools\d3dreg.exe" 
echo "%D3DREG%" PS_SHADERDISKCACHE_FLAGS=DISABLE_ENCRYPTION >> %MY_LOG_PATH%
"%D3DREG%" PS_SHADERDISKCACHE_FLAGS=DISABLE_ENCRYPTION >> %MY_LOG_PATH% 2>&1

::importing classes registry keys
echo reg import "%~dp0epic.reg" >> %MY_LOG_PATH% 2>&1
reg import "%~dp0epic.reg" >> %MY_LOG_PATH% 2>&1

echo "%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\com.epicgames.launcher" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1
"%~dp0subinacl.exe" /subkeyreg "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\com.epicgames.launcher" /grant=Kiosk=F >> %MY_LOG_PATH% 2>&1

md "C:\Program Files (x86)\Common Files\BattlEye">> %MY_LOG_PATH% 2>&1
"C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping_BE.exe" 1 0 >> %MY_LOG_PATH% 2>&1
echo start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\Fortnite\FortniteGame\Binaries\Win64\EasyAntiCheat\" "" "EasyAntiCheat_Setup.exe" install 217 -console
start /WAIT /d "C:\Program Files (x86)\NVIDIA_Grid_Bundle\fortnite_gfn_pc\Fortnite\FortniteGame\Binaries\Win64\EasyAntiCheat\" "" "EasyAntiCheat_Setup.exe" install 217 -console

echo %DATE%_%TIME% Registering BattleEYE >> %MY_LOG_PATH%
"%~dp0subinacl.exe" /service "BEService" /grant=Kiosk=TOP >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% Applying set_instance_regkey.ps1 >> %MY_LOG_PATH%
powershell -File set_instance_regkey.ps1 >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is completed. >> %MY_LOG_PATH%
exit 0