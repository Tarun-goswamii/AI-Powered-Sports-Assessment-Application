@echo off
REM Sports Assessment App with ML - Complete Launcher
echo.
echo ==========================================
echo   Sports Assessment App with ML Support
echo ==========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo WARNING: Python not found. ML features will use simulation mode.
    echo You can still run the app - ML will be simulated.
    echo.
    goto :flutter_only
)

echo [1/5] Installing Python dependencies...
pip install flask flask-cors opencv-python mediapipe numpy >nul 2>&1

echo [2/5] Installing Node.js dependencies...
call npm install

echo [3/5] Starting Python ML Server...
start "ML Server" cmd /k "python python_ml_server.py"

REM Wait a moment for the server to start
timeout /t 3 /nobreak >nul

echo [4/5] Deploying Convex backend...
call npm run deploy

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Convex deployment failed!
    echo Please check your Convex configuration.
    pause
    exit /b 1
)

echo [5/5] Starting Flutter app with full ML support...
call flutter run

goto :end

:flutter_only
echo [1/3] Installing Node.js dependencies...
call npm install

echo [2/3] Deploying Convex backend...
call npm run deploy

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Convex deployment failed!
    pause
    exit /b 1
)

echo [3/3] Starting Flutter app with simulated ML...
call flutter run

:end
echo.
echo App session ended.
pause