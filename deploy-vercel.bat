@echo off
echo 🚀 Vercel Deployment Script for Flutter Sports Assessment App
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter not found. Please install Flutter first.
    pause
    exit /b 1
)

REM Check if Vercel CLI is installed
vercel --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 📦 Installing Vercel CLI...
    npm install -g vercel
)

echo 🔧 Step 1: Cleaning and preparing Flutter app...
flutter clean
flutter pub get

echo 🏗️ Step 2: Building Flutter web app for production...
flutter build web --release --base-href "/"

if %errorlevel% neq 0 (
    echo ❌ Flutter build failed!
    pause
    exit /b 1
)

echo ✅ Flutter build completed successfully!
echo.

echo 🌐 Step 3: Deploying to Vercel...
echo.
echo Choose deployment option:
echo 1. Deploy to staging (preview)
echo 2. Deploy to production
echo 3. Just show preview (no deploy)
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo 📤 Deploying to staging...
    vercel
) else if "%choice%"=="2" (
    echo 🚀 Deploying to production...
    vercel --prod
) else if "%choice%"=="3" (
    echo 👀 Showing deployment preview...
    vercel --dry-run
) else (
    echo ❌ Invalid choice. Exiting...
    pause
    exit /b 1
)

if %errorlevel% equ 0 (
    echo.
    echo ✅ Deployment completed successfully!
    echo.
    echo 🎉 Your Flutter Sports Assessment app is now live!
    echo.
    echo 📱 Features included:
    echo   - Real-time Convex backend integration
    echo   - Firebase authentication and storage
    echo   - Resend email service
    echo   - AI-powered assessment features
    echo   - Mobile-responsive design
    echo   - PWA capabilities
    echo.
    echo 🔗 Next steps:
    echo   1. Test your app thoroughly
    echo   2. Set up custom domain (optional)
    echo   3. Configure monitoring and alerts
    echo   4. Share with your users!
    echo.
) else (
    echo ❌ Deployment failed!
    echo.
    echo 🔧 Troubleshooting tips:
    echo   1. Check your internet connection
    echo   2. Ensure you're logged into Vercel (vercel login)
    echo   3. Verify your project configuration
    echo   4. Check the Vercel dashboard for error logs
    echo.
)

pause