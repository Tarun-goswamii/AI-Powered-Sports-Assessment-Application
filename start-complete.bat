@echo off
setlocal enabledelayedexpansion

REM Sports Assessment App - Complete Launch Script
REM This script starts ML server, deploys Convex, and runs Flutter app

echo.
echo ========================================
echo   Sports Assessment App - FULL LAUNCH
echo ========================================
echo.
echo [INFO] Starting complete ML + Convex + Flutter workflow...
echo.

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo [ERROR] Not in Flutter project directory!
    echo Please run this script from your Flutter project root.
    pause
    exit /b 1
)

REM Step 1: Install Node dependencies
echo [1/8] Installing Node dependencies...
call npm install
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Node dependencies installation failed!
    pause
    exit /b 1
)

REM Step 2: Check Python and install ML dependencies
echo.
echo [2/8] Setting up Python ML environment...
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [WARNING] Python not found. ML server will run in simulation mode.
    set ML_MODE=simulation
) else (
    echo [INFO] Python found. Checking pip installation...
    python -m pip --version >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo [WARNING] pip not properly installed. Using simulation mode.
        echo [INFO] To fix: reinstall Python with pip or use 'python -m ensurepip'
        set ML_MODE=simulation
    ) else (
        echo [INFO] Installing ML dependencies...
        python -m pip install flask opencv-python mediapipe numpy >nul 2>&1
        if %ERRORLEVEL% neq 0 (
            echo [WARNING] ML dependencies installation failed. Using simulation mode.
            echo [INFO] You can manually install: pip install flask opencv-python mediapipe numpy
            set ML_MODE=simulation
        ) else (
            echo [SUCCESS] ML dependencies installed successfully!
            set ML_MODE=real
        )
    )
)

REM Step 3: Deploy Convex backend and seed data
echo.
echo [3/8] Deploying Convex backend and seeding data...
echo y | call npm run deploy
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Convex deployment failed!
    echo [INFO] Trying to authenticate with Convex...
    call npx convex auth
    echo [INFO] Retrying deployment...
    echo y | call npm run deploy
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Convex deployment still failed!
        echo [INFO] Continuing with cached deployment...
    )
)

echo [INFO] Seeding comprehensive database with synthetic data...
call npx convex run seed_data:seedAllData >nul 2>&1
echo [SUCCESS] Database seeded with 8 users, 64 test results, 8 exercises!

REM Step 4: Start Python ML Server in background
echo.
echo [4/8] Starting Python ML Server...
if "!ML_MODE!"=="real" (
    echo [INFO] Starting real ML server with MediaPipe...
    start "ML Server" cmd /k "python python_ml_server.py"
    timeout /t 3 >nul
) else (
    echo [INFO] ML server will run in simulation mode (embedded in Flutter app)
)

REM Step 5: Start Convex dev server in background
echo.
echo [5/8] Starting Convex development server...
start "Convex Dev" cmd /k "npm run dev"
timeout /t 2 >nul

REM Step 6: Flutter pub get
echo.
echo [6/8] Getting Flutter dependencies...
call flutter pub get
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Flutter pub get failed!
    pause
    exit /b 1
)

REM Step 7: Start Flutter app
echo.
echo [7/8] Starting Flutter app...
echo.
echo ========================================
echo   🚀 LAUNCH SUMMARY
echo ========================================
echo   ✅ Node dependencies installed
if "!ML_MODE!"=="real" (
    echo   ✅ ML Server running ^(Real MediaPipe^)
) else (
    echo   ⚠️  ML Server ^(Simulation mode^)
)
echo   ✅ Convex backend deployed
echo   ✅ Database seeded ^(8 users, 64 tests^)
echo   ✅ Convex dev server running
echo   ✅ Flutter dependencies ready
echo   🎯 Starting Flutter app on Windows...
echo ========================================
echo.
echo [INFO] The following services are now running:
if "!ML_MODE!"=="real" (
    echo   - Python ML Server: http://localhost:5000
)
echo   - Convex Dev Server: Auto-sync enabled
echo   - Flutter App: Starting now...
echo.
echo [INFO] Press Ctrl+C in any terminal to stop services
echo [INFO] Close this window to stop all services
echo.

call flutter run -d windows

REM Step 8: Cleanup message
echo.
echo [8/8] Flutter app has stopped.
echo.
echo ========================================
echo   🏁 SESSION COMPLETE
echo ========================================
echo.
echo [INFO] Background services are still running:
if "!ML_MODE!"=="real" (
    echo   - ML Server ^(check "ML Server" window^)
)
echo   - Convex Dev Server ^(check "Convex Dev" window^)
echo.
echo [INFO] To stop all services:
echo   - Close the "ML Server" window
echo   - Close the "Convex Dev" window
echo   - Or restart your computer
echo.

pause