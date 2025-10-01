@echo off
REM start-with-ngrok.bat - Make local ML server publicly accessible

echo 🌐 Making Local ML Server Globally Accessible with Ngrok...
echo.

REM Check if ngrok is installed
where ngrok >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Ngrok not found. Installing...
    echo.
    echo Please install ngrok:
    echo 1. Go to https://ngrok.com/download
    echo 2. Download and extract ngrok.exe
    echo 3. Add to PATH or copy to this folder
    echo 4. Run: ngrok authtoken [your-token]
    echo.
    pause
    exit /b 1
)

echo ✅ Ngrok found! Starting services...

REM Start ML Server in background
echo 🤖 Starting ML Server...
start "ML Server" cmd /k "python python_ml_server.py"
timeout /t 3 >nul

REM Start Convex dev in background  
echo 🔗 Starting Convex dev server...
start "Convex Dev" cmd /k "npm run dev"
timeout /t 2 >nul

REM Start ngrok to expose ML server
echo 🌐 Creating public URL for ML server...
start "Ngrok" cmd /k "ngrok http 5000"

echo.
echo ================================================
echo   🚀 GLOBAL ACCESS READY!
echo ================================================
echo.
echo ✅ ML Server: Running locally on port 5000
echo ✅ Convex: Running in development mode  
echo ✅ Ngrok: Creating public URL...
echo.
echo 🌐 Check the Ngrok window for your public URL:
echo    Example: https://abc123.ngrok.io
echo.
echo 📝 TO USE WITH MOBILE:
echo    1. Copy the ngrok URL from the Ngrok window
echo    2. Update lib/core/config/app_config.dart:
echo       static const String mlServerUrlProd = 'https://abc123.ngrok.io';
echo    3. Build APK: flutter build apk --release
echo    4. Share APK - it will work globally!
echo.
echo ⚠️  NOTE: Ngrok URL changes each restart
echo    For permanent deployment, use Render (run deploy-render.bat)
echo.
echo 🎯 Your app is now globally accessible!
echo.
pause