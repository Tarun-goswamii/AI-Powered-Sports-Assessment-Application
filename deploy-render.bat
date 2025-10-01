@echo off
REM deploy-render.bat - Deploy ML Server to Render (Free Alternative)

echo 🚀 Deploying Sports Assessment ML Server to Render...
echo.
echo ℹ️  Render offers 750 hours/month free tier (better than Railway)
echo.
echo 📋 Manual Deployment Steps:
echo.
echo 1. Go to https://render.com
echo 2. Sign up/Login with GitHub
echo 3. Click "New +" → "Web Service"
echo 4. Connect your GitHub repository: FITNESS-APP-NEW
echo 5. Configure:
echo    - Name: sports-assessment-ml
echo    - Environment: Python 3
echo    - Build Command: pip install -r requirements.txt
echo    - Start Command: python python_ml_server.py
echo    - Instance Type: Free
echo.
echo 6. Click "Create Web Service"
echo 7. Render will auto-deploy and give you a URL like:
echo    https://sports-assessment-ml.onrender.com
echo.
echo 8. Update lib/core/config/app_config.dart with your URL
echo.
echo ✅ Render automatically detects Python and installs dependencies!
echo ✅ Your ML server will be available 24/7 with the free tier!
echo.
pause