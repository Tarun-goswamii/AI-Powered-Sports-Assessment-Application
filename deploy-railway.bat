@echo off
REM deploy-railway.bat - Deploy ML Server to Railway (Windows)

echo 🚀 Deploying Sports Assessment ML Server to Railway...

REM Check if Railway CLI is installed
where railway >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Railway CLI not found. Installing...
    npm install -g @railway/cli
)

REM Login to Railway
echo 🔐 Logging in to Railway...
railway login

REM Initialize Railway project if needed
if not exist "railway.toml" (
    echo 🏗️ Initializing Railway project...
    railway init
)

REM Deploy to Railway  
echo 📦 Deploying to Railway...
railway up

echo ✅ Deployment complete!
echo 🌐 Your ML server will be available at: https://[your-project].railway.app
echo 📝 Update AppConfig.mlServerUrlProd with your actual Railway URL
pause