@echo off
REM Install (Windows) - automated setup for running on Windows desktop
SETLOCAL ENABLEDELAYEDEXPANSION

echo === Install (Windows) - Starting ===

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

echo 4) Ensure Windows desktop support is enabled and required tools are installed...
echo Running: flutter config --enable-windows-desktop
flutter config --enable-windows-desktop

echo 5) Deploy Convex backend (this may take a minute)...
npm run deploy

echo 6) Run the Flutter app on Windows desktop...
flutter run -d windows

echo === Install (Windows) - Done ===
pause
ENDLOCAL
