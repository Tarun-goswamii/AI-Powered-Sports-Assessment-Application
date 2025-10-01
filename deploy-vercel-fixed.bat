@echo off
REM ================================================================
REM Quick Vercel Deployment Script
REM Deploys the submission page to Vercel
REM ================================================================

echo.
echo ========================================
echo   Vita Sports - Vercel Deployment
echo ========================================
echo.

REM Check if Vercel CLI is installed
where vercel >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Vercel CLI not found!
    echo.
    echo Installing Vercel CLI globally...
    call npm install -g vercel
    
    if %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Failed to install Vercel CLI
        echo Please run manually: npm install -g vercel
        pause
        exit /b 1
    )
    
    echo.
    echo [SUCCESS] Vercel CLI installed!
    echo.
)

echo [INFO] Vercel CLI is ready
echo.

REM Navigate to project root
cd /d "%~dp0"

echo [INFO] Current directory: %CD%
echo.

REM Check if submission folder exists
if not exist "submission\index.html" (
    echo [ERROR] submission\index.html not found!
    echo Make sure you're in the project root directory.
    pause
    exit /b 1
)

echo [SUCCESS] Submission page found
echo.

REM Show deployment info
echo ========================================
echo   Deployment Information
echo ========================================
echo.
echo   Deploying: submission/index.html
echo   Target: Vercel Production
echo   Configuration: vercel.json
echo.

REM Ask for confirmation
set /p CONFIRM="Ready to deploy? (y/n): "
if /i not "%CONFIRM%"=="y" (
    echo.
    echo [CANCELLED] Deployment cancelled by user
    pause
    exit /b 0
)

echo.
echo ========================================
echo   Deploying to Vercel...
echo ========================================
echo.

REM Deploy to Vercel
call vercel --prod

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo   [SUCCESS] Deployment Complete!
    echo ========================================
    echo.
    echo Your submission page is now live!
    echo Copy the URL above and share it with judges.
    echo.
) else (
    echo.
    echo ========================================
    echo   [ERROR] Deployment Failed
    echo ========================================
    echo.
    echo Troubleshooting:
    echo   1. Make sure you're logged in: vercel login
    echo   2. Check your internet connection
    echo   3. Try deploying from submission folder:
    echo      cd submission
    echo      vercel --prod
    echo.
)

pause
