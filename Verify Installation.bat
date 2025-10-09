@echo off
echo ==================================================
echo System Verification - Development Tools Check
echo ==================================================

echo Checking installed development tools...
echo.

REM Check Node.js
echo [1/5] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js: NOT FOUND
    set MISSING=1
) else (
    for /f "tokens=*" %%a in ('node --version 2^>nul') do echo ✅ Node.js: %%a
)

REM Check npm
echo [2/5] Checking npm...
where npm >nul 2>&1
if errorlevel 1 (
    echo ❌ npm: NOT FOUND
    set MISSING=1
) else (
    for /f "tokens=*" %%a in ('npm --version 2^>nul') do echo ✅ npm: v%%a
)

REM Check Git
echo [3/5] Checking Git...
where git >nul 2>&1
if errorlevel 1 (
    echo ❌ Git: NOT FOUND
    set MISSING=1
) else (
    for /f "tokens=3" %%a in ('git --version 2^>nul') do echo ✅ Git: %%a
)

REM Check Flutter
echo [4/5] Checking Flutter...
where flutter >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter: NOT FOUND
    set MISSING=1
) else (
    for /f "tokens=2" %%a in ('flutter --version ^| findstr "Flutter" 2^>nul') do echo ✅ Flutter: %%a
)

REM Check ADB
echo [5/5] Checking Android Debug Bridge...
where adb >nul 2>&1
if errorlevel 1 (
    if exist "platform-tools-local\platform-tools\adb.exe" (
        echo ✅ ADB: Found (local installation)
    ) else (
        echo ❌ ADB: NOT FOUND
        set MISSING=1
    )
) else (
    for /f "tokens=5" %%a in ('adb version 2^>nul ^| findstr "Android Debug Bridge"') do echo ✅ ADB: %%a
)

echo.
echo ==================================================

if defined MISSING (
    echo ❌ Some tools are missing. Run "Install (Android).bat" to install them.
) else (
    echo ✅ All development tools are installed correctly!
    echo.
    echo Additional checks:
    echo [Flutter Doctor]
    flutter doctor --disable-analytics
    echo.
    echo [Connected Android Devices]
    adb devices
)

echo.
echo ==================================================
pause