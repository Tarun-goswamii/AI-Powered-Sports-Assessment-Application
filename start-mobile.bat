@echo off
echo 🚀 Starting Sports Assessment App for Mobile Testing...
echo.

REM Get the current directory
set CURRENT_DIR=%cd%

echo 📱 Starting ML Server for Mobile Devices...
cd ml-server
start "ML Server" cmd /k "node ml-server.js"
cd %CURRENT_DIR%

REM Wait for ML server to start
echo ⏳ Waiting for ML server to initialize...
timeout /t 5 /nobreak > nul

REM Test ML server connectivity
echo 🔍 Testing ML server connectivity...
powershell -Command "try { Invoke-WebRequest -Uri http://localhost:5001/health -UseBasicParsing | Out-Null; Write-Host '✅ ML Server is running and accessible' -ForegroundColor Green } catch { Write-Host '❌ ML Server connection failed' -ForegroundColor Red }"

echo.
echo 📋 Important Notes for Mobile Testing:
echo.
echo 1. Make sure your mobile device and computer are on the same Wi-Fi network
echo 2. Find your computer's IP address using 'ipconfig' command
echo 3. On mobile, the app will try to connect to your computer's IP:5001
echo 4. Make sure Windows Firewall allows connections on port 5001
echo.

REM Get IP address for mobile connectivity
echo 🌐 Your computer's IP addresses:
ipconfig | findstr /i "IPv4"

echo.
echo 🎯 To test the complete video recording pipeline:
echo 1. Open the Flutter app on your mobile device
echo 2. Navigate to Camera Test section
echo 3. Choose an exercise type (e.g., Push-up)
echo 4. Grant camera permissions when prompted
echo 5. Record a video of the exercise
echo 6. Wait for ML analysis to complete
echo 7. Check the results and leaderboard update
echo.

echo 📱 Starting Flutter app for mobile devices...
echo.
flutter run

pause