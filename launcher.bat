@echo off

setlocal
cd /d %~dp0

where gh>nul 2>nul
if %ERRORLEVEL% NEQ 0 goto :gherr

:pstart

echo E - Exit
echo U - Update/Install
echo [empty] - Launch

set /P c=? 
if /I "%c%" EQU "U" goto :update
if /I "%c%" EQU "E" goto :end
goto :launch

:launch

cd yuzu-early-access
start yuzu.exe

goto :end
exit

:update

echo|set /p="Cleaning up..."
IF exist yuzu-early-access ( rd /s /q yuzu-early-access )
echo [Done]

echo|set /p="Downloading the latest release from GitHub..."
gh release download --repo Kryptuq/Yuzu-Early-Access-files --pattern ** > nul
echo [Done]

echo|set /p="Cleaning up..."
dir /b/s *yuzu*.zip > .temp
set /p path=<.temp
del .temp
ren "%path%" latest.zip
echo [Done]

echo|set /p="Extracting..."
7za x latest.zip -o"." > nul
echo [Done]

echo|set /p="Cleaning up..."
del latest.zip
echo [Done]

echo.
echo [OK] Installed successfully!
echo.

pause
exit

:gherr
echo [ERROR] Please install GitHub CLI and authenticate
echo https://cli.github.com/
goto :end

:end
rem