@echo off
echo 🎯 SPORTS ASSESSMENT APP - JUDGE DEMONSTRATION
echo ====================================================
echo.
echo This demonstration showcases the complete integration of:
echo ✅ CONVEX Backend Database 
echo ✅ RESEND Email Service
echo ✅ Complete User Journey (Sign-up → Test → Leaderboard)
echo.

echo 📋 DEMONSTRATION FLOW:
echo.
echo 1. User Sign-up Process:
echo    - Creates account in Firebase Auth
echo    - Creates user profile in Firestore  
echo    - Creates user record in Convex database (for leaderboard)
echo    - Sends welcome email via Resend
echo    - User starts at 0 progress state
echo.
echo 2. App Exploration:
echo    - User can browse different sections
echo    - View empty leaderboard (initially)
echo    - Access camera test features
echo.
echo 3. Test Execution:
echo    - User records exercise video
echo    - ML analysis processes the video
echo    - Results are computed
echo.
echo 4. Results Integration:
echo    - Test results saved to Convex database
echo    - Leaderboard automatically updates
echo    - Test completion email sent via Resend
echo    - User progress is reflected across the app
echo.

echo 🚀 STARTING FLUTTER APPLICATION...
echo.
echo Notes for Judges:
echo - The app will open in debug mode
echo - All integrations are live and functional
echo - Synthetic data is available for demonstration
echo - Email notifications will be sent to configured addresses
echo.

pause

echo Starting Flutter app in web mode for demonstration...
flutter run -d chrome --web-port 3000

pause