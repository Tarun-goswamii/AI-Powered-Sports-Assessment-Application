@echo off
REM Install (iOS) - helper script for macOS users only (Windows cannot build iOS)

echo === Install (iOS) - macOS helper ===
echo Note: iOS builds require macOS and Xcode. This script provides the commands you should run on macOS.
echo 
echo 1) Install Node & dependencies
echo npm install && flutter pub get

echo 2) Install CocoaPods (if not installed)
echo sudo gem install cocoapods && pod setup

echo 3) Set RESEND_API_KEY environment variable for Convex (replace below):
echo npx convex env set RESEND_API_KEY re_your_real_key_here

echo 4) Deploy Convex backend (optional)
echo npm run deploy

echo 5) Open Xcode workspace and run on a simulator or device:
echo open ios/Runner.xcworkspace

echo === Install (iOS) - Instructions printed. Execute these commands in a macOS terminal ===
pause
