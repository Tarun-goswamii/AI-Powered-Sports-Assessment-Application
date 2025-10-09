@echo off
cd /d "%~dp0"

echo ==================================================
echo Install Android App - Automated Installer
echo For fresh repo clones - fully automated setup
echo ==================================================

REM Ensure we have PowerShell for downloads
powershell -Command "exit 0" >nul 2>&1 || goto missing_powershell

where node >nul 2>&1 || goto missing_node
where npm >nul 2>&1 || goto missing_npm  
where flutter >nul 2>&1 || goto missing_flutter

where adb >nul 2>&1
if errorlevel 1 call :setup_adb

echo All tools ready.

echo Step 1: Installing Node dependencies...
npm install || goto error_exit

echo Step 2: Installing Flutter dependencies...
flutter pub get || goto error_exit

if not "%~1"=="" (
    echo Step 3: Setting RESEND_API_KEY...
    npx convex env set RESEND_API_KEY %~1 || echo WARNING: Failed to set key
) else (
    echo Step 3: Skipping RESEND_API_KEY setup
)

echo Step 4: Deploying backend...
npm run deploy || echo WARNING: Deploy failed, continuing...

echo Step 5: Building APK (this may take 5-10 minutes)...
flutter build apk --release || goto error_exit

set APK=
if exist "build\app\outputs\flutter-apk\app-release.apk" set APK=build\app\outputs\flutter-apk\app-release.apk
if exist "build\app\outputs\apk\release\app-release.apk" set APK=build\app\outputs\apk\release\app-release.apk
if "%APK%"=="" goto no_apk

echo Found APK: %APK%
echo Step 6: Installing on device...

for /f "tokens=1,2" %%a in ('adb devices 2^>nul') do (
    if "%%b"=="device" goto install_now
)
goto no_device

:install_now
adb install -r "%APK%" || goto install_failed
echo.
echo SUCCESS: App installed successfully!
exit /b 0

:missing_node
echo ERROR: Node.js not found. Install from https://nodejs.org
echo This is required for npm and the Convex backend.
exit /b 1

:missing_npm
echo ERROR: npm not found. Usually comes with Node.js.
exit /b 1

:missing_flutter
echo ERROR: Flutter not found. Install from https://flutter.dev
echo Make sure flutter/bin is added to your PATH.
exit /b 1

:missing_powershell
echo ERROR: PowerShell not available. Cannot download platform-tools automatically.
echo Please install Android platform-tools manually and ensure adb is in PATH.
exit /b 1

:no_apk
echo ERROR: APK not found after build
exit /b 1

:no_device
echo ERROR: No Android device found with USB debugging enabled.
echo 1. Connect your Android device via USB
echo 2. Enable Developer Options in Settings
echo 3. Enable USB debugging in Developer Options
echo 4. Accept the RSA fingerprint prompt on your device
echo 5. Run 'adb devices' to verify connection
exit /b 1

:install_failed
echo ERROR: APK installation failed. This could be due to:
echo 1. Device storage full
echo 2. App signature conflicts
echo 3. Device not allowing installation from unknown sources
echo Try: adb install -r "%APK%" manually for more details
exit /b 1

:error_exit
echo ERROR: Step failed
exit /b 1

:setup_adb
echo Downloading platform-tools...
set TOOLS_DIR=%CD%\platform-tools-local
if exist "%TOOLS_DIR%\platform-tools\adb.exe" goto add_path

powershell -Command "Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile 'pt.zip'" || goto download_failed
powershell -Command "Expand-Archive 'pt.zip' '%TOOLS_DIR%' -Force; Remove-Item 'pt.zip'" || goto extract_failed

:add_path
set PATH=%TOOLS_DIR%\platform-tools;%PATH%
where adb >nul 2>&1 || goto adb_failed
echo Platform-tools ready.
exit /b 0

:download_failed
echo ERROR: Download failed
exit /b 1

:extract_failed  
echo ERROR: Extract failed
exit /b 1

:adb_failed
echo ERROR: adb not available
exit /b 1
