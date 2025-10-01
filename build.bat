@echo off
REM Vercel Build Script for Flutter Web App (Windows)
echo 🚀 Starting Flutter Web Build for Vercel...

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter not found. Please install Flutter first.
    exit /b 1
)

REM Enable web support
flutter config --enable-web

REM Get dependencies
echo 📦 Getting Flutter dependencies...
flutter pub get

REM Clean previous builds
flutter clean

REM Build for web with optimizations
echo 🔨 Building Flutter web app...
flutter build web --release --base-href "/"

if %errorlevel% equ 0 (
    echo ✅ Flutter web build completed!
    echo 📁 Build output: build\web\
    dir build\web\
) else (
    echo ❌ Build failed!
    exit /b 1
)