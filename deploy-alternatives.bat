@echo off
REM deploy-alternatives.bat - Show all free deployment options

echo 🌐 FREE DEPLOYMENT OPTIONS for ML Server
echo ================================================
echo.
echo 🥇 OPTION 1: Render (RECOMMENDED - Most Free Hours)
echo    ✅ 750 hours/month FREE (25 days continuous)
echo    ✅ Automatic Python detection
echo    ✅ GitHub integration
echo    ✅ Custom domains
echo    👉 Run: deploy-render.bat
echo.
echo 🥈 OPTION 2: Vercel (Good for Python)
echo    ✅ Unlimited serverless functions
echo    ✅ GitHub auto-deploy
echo    ✅ Global CDN
echo    ⚠️  15 second timeout limit
echo    👉 Manual: vercel.com
echo.
echo 🥉 OPTION 3: Heroku (Reliable but limited)
echo    ✅ 550 hours/month FREE
echo    ✅ Professional grade
echo    ⚠️  Requires credit card
echo    👉 Manual: heroku.com
echo.
echo 🔧 OPTION 4: Google Cloud Run (Pay-per-use)
echo    ✅ $300 free credits
echo    ✅ Auto-scaling
echo    ✅ Pay only when used
echo    👉 Manual: cloud.google.com
echo.
echo 💡 OPTION 5: Keep Local + Ngrok (Quick Test)
echo    ✅ Instant public URL
echo    ✅ Great for testing
echo    ⚠️  Requires your computer running
echo    👉 Run: start-with-ngrok.bat
echo.
echo ================================================
echo.
echo 🎯 RECOMMENDED: Use Render for permanent deployment
echo    Most generous free tier + automatic detection
echo.
pause