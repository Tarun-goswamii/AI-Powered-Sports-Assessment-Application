# Android App Installation Guide

## Complete Auto-Installer for Fresh PCs

The `Install (Android).bat` file is a comprehensive installer that handles everything needed to build and install the AI Sports Assessment app on your Android device, even on a completely fresh PC.

## What the Installer Does

### 1. System Requirements Check
- Checks for PowerShell (required for downloads)
- Verifies or installs Node.js LTS (v20.17.0)
- Verifies or installs Git for Windows
- Verifies or installs Flutter SDK (v3.24.3)
- Sets up Android platform-tools (adb)

### 2. Dependency Installation
- Installs Node.js dependencies (`npm install`)
- Installs Flutter dependencies (`flutter pub get`)
- Accepts Android licenses automatically
- Sets up Convex backend environment

### 3. App Building & Installation
- Deploys the Convex backend
- Builds the Android APK (release version)
- Installs the APK on your connected Android device

## Prerequisites

### On Your PC:
- Windows 10/11 with PowerShell
- Administrator privileges (recommended)
- Stable internet connection
- At least 5GB free disk space

### On Your Android Device:
1. **Enable Developer Options:**
   - Go to Settings > About phone
   - Tap "Build number" 7 times
   - Developer options will be enabled

2. **Enable USB Debugging:**
   - Go to Settings > Developer Options
   - Turn on "USB debugging"

3. **Connect Device:**
   - Connect your Android device via USB cable
   - When prompted, accept the RSA fingerprint on your device

## How to Use

### Simple Installation:
```cmd
"Install (Android).bat"
```

### With Custom API Key:
```cmd
"Install (Android).bat" your_resend_api_key_here
```

## Installation Process

The installer will:

1. **Check Dependencies** (2-3 minutes)
   - Downloads and installs missing tools automatically

2. **Install Project Dependencies** (1-2 minutes)
   - Node.js packages and Flutter dependencies

3. **Backend Setup** (1-2 minutes)
   - Deploys Convex backend to cloud

4. **Build APK** (5-10 minutes)
   - Compiles the Flutter app for Android

5. **Install on Device** (30 seconds)
   - Transfers and installs APK on your phone

## Total Time: 10-20 minutes (depending on internet speed)

## What Gets Installed

### Development Tools:
- **Node.js LTS** → For backend development and npm
- **Git for Windows** → Version control system
- **Flutter SDK** → Mobile app development framework
- **Android Platform Tools** → For device communication (adb)

### Project Dependencies:
- **Convex** → Backend-as-a-Service for real-time data
- **Flutter packages** → UI framework and plugins

## Troubleshooting

### Common Issues:

1. **"Access Denied" Errors:**
   - Run Command Prompt as Administrator
   - Right-click on cmd.exe → "Run as administrator"

2. **Device Not Found:**
   - Ensure USB debugging is enabled
   - Try different USB cable/port
   - Check device manager for driver issues

3. **Download Failures:**
   - Check internet connection
   - Disable antivirus temporarily
   - Try running from a different network

4. **Flutter Build Errors:**
   - Run `flutter doctor` to check setup
   - Accept Android licenses: `flutter doctor --android-licenses`
   - Clear Flutter cache: `flutter clean`

### Manual Verification:

After installation, verify tools are working:

```cmd
node --version
npm --version
git --version
flutter --version
adb devices
```

## File Locations

The installer creates these directories:

- **Node.js:** Default Windows location (`Program Files\nodejs`)
- **Git:** Default Windows location (`Program Files\Git`)
- **Flutter:** `C:\flutter`
- **Platform Tools:** `[Project]\platform-tools-local`

## Security Notes

- The installer downloads tools from official sources only
- All downloads use HTTPS
- No personal data is collected during installation
- You can review the batch file before running

## Need Help?

If the installer fails:

1. Check the error messages carefully
2. Try running individual steps manually
3. Ensure you have admin privileges
4. Check Windows Defender/antivirus settings
5. Try a different network connection

For manual installation, follow the individual tool installation guides:
- [Node.js](https://nodejs.org)
- [Git](https://git-scm.com)
- [Flutter](https://flutter.dev)
- [Android Studio](https://developer.android.com/studio)