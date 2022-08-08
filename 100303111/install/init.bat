:: InstallScript:mklink
@echo off

mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set LOG=C:\Asgard\logs\SessionMngr\epic_init_bat.log

echo %DATE%_%TIME%: init.bat is launched > %LOG% 2>&1

set "NGB_EGL_PATH=C:\Program Files (x86)\NVIDIA_Grid_Bundle\epic_games_launcher_gfn_pc\"
set "PROG_FILES_86_PATH=C:\Program Files (x86)\"
set "PROG_DATA_PATH=C:\ProgramData\"

set "EPIC_GAMES_FOLDER=Epic Games\"
set "EPIC_FOLDER=Epic\"

:REMOVE_OLD_SYMLINKS
echo %DATE%_%TIME%: rmdir %PROG_FILES_86_PATH%%EPIC_GAMES_FOLDER% >> %LOG% 2>&1
rmdir "%PROG_FILES_86_PATH%%EPIC_GAMES_FOLDER%" >> %LOG% 2>&1

echo %DATE%_%TIME%: rmdir %PROG_DATA_PATH%%EPIC_FOLDER% >> %LOG% 2>&1
rmdir "%PROG_DATA_PATH%%EPIC_FOLDER%" >> %LOG% 2>&1

:CREATE_NEW_SYMLINKS
echo %DATE%_%TIME%: mklink /d /j %PROG_FILES_86_PATH%%EPIC_GAMES_FOLDER% %NGB_EGL_PATH%%EPIC_GAMES_FOLDER% >> %LOG% 2>&1
mklink /d /j "%PROG_FILES_86_PATH%%EPIC_GAMES_FOLDER%" "%NGB_EGL_PATH%%EPIC_GAMES_FOLDER%" >> %LOG% 2>&1

echo %DATE%_%TIME%: mklink /d /j %PROG_DATA_PATH%%EPIC_FOLDER% %NGB_EGL_PATH%pdata\%EPIC_FOLDER% >> %LOG% 2>&1
mklink /d /j "%PROG_DATA_PATH%%EPIC_FOLDER%" "%NGB_EGL_PATH%pdata\%EPIC_FOLDER%" >> %LOG% 2>&1

echo %DATE%_%TIME% Installing "Epic Online Services" service >> %LOG%

::echo %DATE%_%TIME% start /w /d "C:\Program Files (x86)\Epic Games\Launcher\Portal\Extras\EOS" "" "msiexec.exe" /i EpicOnlineServices.msi /qn >> %LOG%
::start /w /d "C:\Program Files (x86)\Epic Games\Launcher\Portal\Extras\EOS" "" "msiexec.exe" /i EpicOnlineServices.msi /qn >> %LOG% 2>&1

echo %DATE%_%TIME% sc create EpicOnlineServices type=own start=demand error=normal binpath="C:\Program Files (x86)\Epic Games\Epic Online Services\service\EpicOnlineServicesHost.exe" displayname="Epic Online Services" >> %LOG%
sc create EpicOnlineServices type=own start=demand error=normal binpath="C:\Program Files (x86)\Epic Games\Epic Online Services\service\EpicOnlineServicesHost.exe" displayname="Epic Online Services" >> %LOG% 2>&1

echo %DATE%_%TIME% reg import "%~dp0EOS_service.reg" >> %LOG%
reg import "%~dp0EOS_service.reg" >> %LOG%

echo %DATE%_%TIME% "%~dp0subinacl.exe" /service EpicOnlineServices /grant=Kiosk=TOP >> %LOG%
"%~dp0subinacl.exe" /service EpicOnlineServices /grant=Kiosk=TOP >> %LOG% 2>&1

echo %DATE%_%TIME% Fixing iexplore shell commands compatibility with GFN Browser >> %LOG%
reg import %~dp0iexplore_fix.reg >> %LOG% 2>&1

echo %DATE%_%TIME%: Install script finished >> %LOG% 2>&1

exit 0

:ERROR
echo %DATE%_%TIME%: Failure!  >> %LOG% 2>&1
exit 1
