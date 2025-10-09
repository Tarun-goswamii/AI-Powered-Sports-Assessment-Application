@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ==================================================
echo AI Sports Assessment - Complete Auto Installer
echo For completely fresh PCs - installs everything needed
echo ==================================================

REM Create temp directory for downloads
if not exist "%TEMP%\sports_installer" mkdir "%TEMP%\sports_installer"
set INSTALLER_TEMP=%TEMP%\sports_installer

echo Checking system requirements...

REM Check if we have PowerShell for downloads
powershell -Command "exit 0" >nul 2>&1 || goto missing_powershell

REM Check and install Node.js
echo Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo Node.js not found. Installing Node.js...
    call :install_nodejs || goto error_exit
) else (
    echo Node.js found.
)

REM Check npm (should come with Node.js)
echo Checking npm...
where npm >nul 2>&1 || goto missing_npm

REM Check and install Git
echo Checking Git...
where git >nul 2>&1
if errorlevel 1 (
    echo Git not found. Installing Git...
    call :install_git || goto error_exit
) else (
    echo Git found.
)

REM Check and install Flutter
echo Checking Flutter...
where flutter >nul 2>&1
if errorlevel 1 (
    echo Flutter not found. Installing Flutter...
    call :install_flutter || goto error_exit
) else (
    echo Flutter found.
)

REM Check VS Code
echo Checking VS Code...
where code >nul 2>&1
if errorlevel 1 (
    echo VS Code not found. VS Code is recommended for development.
    echo You can install it from: https://code.visualstudio.com/
) else (
    echo VS Code found.
)

REM Check Flutter doctor
echo Running Flutter doctor...
flutter doctor || echo WARNING: Flutter doctor found issues, continuing...

REM Check and setup Android tools
echo Checking Android tools...
where adb >nul 2>&1
if errorlevel 1 call :setup_adb

echo All tools ready.

echo Step 1: Installing Node dependencies...
npm install || goto error_exit

echo Step 2: Installing Flutter dependencies...
flutter pub get || goto error_exit

echo Step 3: Accepting Android licenses...
flutter doctor --android-licenses || echo WARNING: License acceptance may have failed

if not "%~1"=="" (
    echo Step 4: Setting RESEND_API_KEY...
    npx convex env set RESEND_API_KEY %~1 || echo WARNING: Failed to set key
) else (
    echo Step 4: Skipping RESEND_API_KEY setup
)

echo Step 5: Deploying backend...
npm run deploy || echo WARNING: Deploy failed, continuing...

echo Step 6: Building APK (this may take 5-10 minutes)...
flutter build apk --release || goto error_exit

set APK=
if exist "build\app\outputs\flutter-apk\app-release.apk" set APK=build\app\outputs\flutter-apk\app-release.apk
if exist "build\app\outputs\apk\release\app-release.apk" set APK=build\app\outputs\apk\release\app-release.apk
if "%APK%"=="" goto no_apk

echo Found APK: %APK%
echo Step 7: Installing on device...

for /f "tokens=1,2" %%a in ('adb devices 2^>nul') do (
    if "%%b"=="device" goto install_now
)
goto no_device

:install_now
adb install -r "%APK%" || goto install_failed
echo.
echo ==================================================
echo ✅ SUCCESS: App installed successfully!
echo ==================================================
echo.
echo Your AI Sports Assessment app is now installed on your device.
echo You can find it in your app drawer.
echo.
echo Cleaning up temporary files...
rmdir /s /q "%INSTALLER_TEMP%" 2>nul
echo.
echo Installation complete! Press any key to close...
pause >nul
exit /b 0

:install_nodejs
echo Downloading Node.js LTS...
set NODE_URL=https://nodejs.org/dist/v20.17.0/node-v20.17.0-x64.msi
set NODE_FILE=%INSTALLER_TEMP%\nodejs.msi
powershell -Command "Invoke-WebRequest '%NODE_URL%' -OutFile '%NODE_FILE%'" || goto download_failed
echo Installing Node.js (this may take a few minutes)...
msiexec /i "%NODE_FILE%" /quiet /norestart || goto install_nodejs_failed
echo Waiting for Node.js installation to complete...
timeout /t 30 /nobreak >nul
REM Refresh PATH
call :refresh_path
where node >nul 2>&1 || goto install_nodejs_failed
echo Node.js installed successfully.
exit /b 0

:install_git
echo Downloading Git...
set GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe
set GIT_FILE=%INSTALLER_TEMP%\git.exe
powershell -Command "Invoke-WebRequest '%GIT_URL%' -OutFile '%GIT_FILE%'" || goto download_failed
echo Installing Git (this may take a few minutes)...
"%GIT_FILE%" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh" || goto install_git_failed
echo Waiting for Git installation to complete...
timeout /t 30 /nobreak >nul
call :refresh_path
where git >nul 2>&1 || goto install_git_failed
echo Git installed successfully.
exit /b 0

:install_flutter
echo Downloading Flutter SDK...
set FLUTTER_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.24.3-stable.zip
set FLUTTER_FILE=%INSTALLER_TEMP%\flutter.zip
set FLUTTER_DIR=C:\flutter
powershell -Command "Invoke-WebRequest '%FLUTTER_URL%' -OutFile '%FLUTTER_FILE%'" || goto download_failed
echo Extracting Flutter SDK...
if exist "%FLUTTER_DIR%" rmdir /s /q "%FLUTTER_DIR%"
powershell -Command "Expand-Archive '%FLUTTER_FILE%' 'C:\' -Force" || goto extract_failed
echo Adding Flutter to PATH...
setx PATH "%PATH%;%FLUTTER_DIR%\bin" /M >nul 2>&1
set PATH=%PATH%;%FLUTTER_DIR%\bin
echo Running Flutter doctor --android-licenses...
flutter doctor --android-licenses --disable-analytics || echo WARNING: License acceptance may have failed
echo Flutter installed successfully.
exit /b 0

:refresh_path
REM Refresh environment variables
for /f "tokens=2*" %%a in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "PATH=%%b"
for /f "tokens=2*" %%a in ('reg query "HKEY_CURRENT_USER\Environment" /v PATH 2^>nul') do set "PATH=!PATH!;%%b"
exit /b 0

:missing_node
echo ERROR: Node.js not found and auto-installation failed.
echo Please manually install Node.js from https://nodejs.org
echo This is required for npm and the Convex backend.
echo.
pause
exit /b 1

:missing_npm
echo ERROR: npm not found. Usually comes with Node.js.
echo Please reinstall Node.js from https://nodejs.org
echo.
pause
exit /b 1

:missing_flutter
echo ERROR: Flutter not found and auto-installation failed.
echo Please manually install Flutter from https://flutter.dev
echo Make sure flutter/bin is added to your PATH.
echo.
pause
exit /b 1

:missing_powershell
echo ERROR: PowerShell not available. Cannot download dependencies automatically.
echo Please install PowerShell or download dependencies manually:
echo - Node.js: https://nodejs.org
echo - Git: https://git-scm.com
echo - Flutter: https://flutter.dev
echo - Android Studio: https://developer.android.com/studio
echo.
pause
exit /b 1

:install_nodejs_failed
echo ERROR: Node.js installation failed.
echo Please manually install Node.js from https://nodejs.org
echo.
pause
exit /b 1

:install_git_failed
echo ERROR: Git installation failed.
echo Please manually install Git from https://git-scm.com
echo.
pause
exit /b 1

:download_failed
echo ERROR: Download failed. Check your internet connection.
echo.
pause
exit /b 1

:extract_failed
echo ERROR: Archive extraction failed.
echo.
pause
exit /b 1

:no_apk
echo ERROR: APK not found after build
echo The Flutter build may have failed. Check the output above for errors.
echo.
pause
exit /b 1

:no_device
echo ERROR: No Android device found with USB debugging enabled.
echo Please follow these steps:
echo 1. Connect your Android device via USB
echo 2. Go to Settings ^> About phone ^> Tap "Build number" 7 times
echo 3. Go to Settings ^> Developer Options ^> Enable "USB debugging"
echo 4. Accept the RSA fingerprint prompt on your device when it appears
echo 5. Run 'adb devices' to verify connection
echo 6. Re-run this installer
echo.
pause
exit /b 1

:install_failed
echo ERROR: APK installation failed. This could be due to:
echo 1. Device storage full
echo 2. App signature conflicts (try uninstalling old version first)
echo 3. Device not allowing installation from unknown sources
echo 4. USB debugging not properly enabled
echo Try running: adb install -r "%APK%" manually for more details
echo.
pause
exit /b 1

:error_exit
echo ERROR: Installation step failed. Check the output above for details.
echo Common solutions:
echo 1. Run as Administrator
echo 2. Check internet connection
echo 3. Ensure Android device is connected with USB debugging enabled
echo 4. Try running individual commands manually
echo.
pause
exit /b 1

:setup_adb
echo Setting up Android platform-tools...
set TOOLS_DIR=%CD%\platform-tools-local
if exist "%TOOLS_DIR%\platform-tools\adb.exe" goto add_adb_path

echo Downloading Android platform-tools...
powershell -Command "Invoke-WebRequest 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile '%INSTALLER_TEMP%\pt.zip'" || goto download_failed
echo Extracting platform-tools...
powershell -Command "Expand-Archive '%INSTALLER_TEMP%\pt.zip' '%TOOLS_DIR%' -Force" || goto extract_failed

:add_adb_path
set PATH=%TOOLS_DIR%\platform-tools;%PATH%
where adb >nul 2>&1 || goto adb_failed
echo Android platform-tools ready.
exit /b 0

:adb_failed
echo ERROR: Android platform-tools setup failed.
echo Please manually install Android Studio or platform-tools.
echo.
pause
exit /b 1
