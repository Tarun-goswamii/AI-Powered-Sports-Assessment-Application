@echo off
REM Install (Android) - automated setup for Windows + Android device
SETLOCAL ENABLEDELAYEDEXPANSION

echo === Install (Android) - Starting ===

echo 1) Installing Node dependencies...
npm install

echo 2) Installing Flutter dependencies...
flutter pub get

echo 3) Set RESEND_API_KEY environment variable for Convex (you will be prompted)
set /p RESEND_KEY=Enter your RESEND_API_KEY (re_...): 
if not "%RESEND_KEY%"=="" (
  npx convex env set RESEND_API_KEY %RESEND_KEY%
) else (
  echo Skipping setting RESEND_API_KEY (you can set it later with: npx convex env set RESEND_API_KEY re_xxx)
)

echo 4) Deploy Convex backend (this may take a minute)...
npm run deploy

echo 5) Run the Flutter app on connected Android device/emulator...
flutter devices
necho If a device is listed, press CTRL+C to stop and then run: flutter run
n
echo To start the app now automatically, running flutter run...
flutter run

echo === Install (Android) - Done ===
pause
ENDLOCAL
