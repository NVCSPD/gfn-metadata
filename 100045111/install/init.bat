:: InstallScript:WhitelistProtocol
@echo off
mkdir C:\Asgard
mkdir C:\Asgard\logs
mkdir C:\Asgard\logs\SessionMngr
set MY_LOG_PATH=C:\Asgard\logs\SessionMngr\eve_online_gfn_pc.log

echo %DATE%_%TIME% init.bat is launched. >> %MY_LOG_PATH%

rem echo %DATE%_%TIME% Whitelisting eveonline protocol >> %MY_LOG_PATH%
rem reg add "HKEY_LOCAL_MACHINE\SOFTWARE\NVIDIA Corporation\Global" /v WhitelistedProtocols /t REG_MULTI_SZ /d "eveonline:" /f >> %MY_LOG_PATH% 2>&1

echo %DATE%_%TIME% init.bat is completed. >> %MY_LOG_PATH%
exit 0
