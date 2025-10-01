@echo off
REM build-production.bat - Build production APK

echo 🏗️ Building Sports Assessment App for Production...

REM Clean build
echo 📦 Cleaning previous build...
call flutter clean
call flutter pub get

REM Build APK for production
echo 🚀 Building production APK...
call flutter build apk --release --dart-define=PRODUCTION=true

REM Build App Bundle for Play Store
echo 📱 Building App Bundle for Google Play Store...
call flutter build appbundle --release --dart-define=PRODUCTION=true

echo ✅ Build complete!
echo 📁 APK Location: build\app\outputs\flutter-apk\app-release.apk
echo 📁 App Bundle Location: build\app\outputs\bundle\release\app-release.aab
echo.
echo 📱 You can now:
echo   1. Install APK directly on Android devices
echo   2. Upload App Bundle to Google Play Store
echo   3. Share APK globally without needing local servers
echo.
pause