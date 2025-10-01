@echo off
REM Sports Assessment App - Quick Launch Script
REM This batch file automatically deploys Convex and runs your Flutter app

echo.
echo ========================================
echo   Sports Assessment App - Quick Launch
echo ========================================
echo.

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo ERROR: Not in Flutter project directory!
    echo Please run this script from your Flutter project root.
    pause
    exit /b 1
)

echo [1/3] Installing dependencies...
call npm install

echo.
echo [2/3] Deploying Convex backend...
call npm run deploy

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Convex deployment failed!
    pause
    exit /b 1
)

echo.
echo [3/3] Starting Flutter app...
call flutter run

pause