# 🍎 iOS Build Guide - Sports Assessment App

**Last Updated:** October 3, 2025  
**Status:** iOS project configured and ready for build on macOS

---

## ⚠️ **IMPORTANT: iOS Builds Require macOS**

You are currently on **Windows**. iOS apps can only be built on macOS with Xcode installed.

---

## 📋 **Current iOS Project Status**

### ✅ **Configured:**
- Bundle Identifier: Ready (needs update in Xcode)
- App Name: "Sports Assessment App"
- Supported Orientations: Portrait, Landscape (iPhone & iPad)
- Info.plist: Configured
- Runner project: Ready

### ⚠️ **Needs Configuration (on Mac):**
- [ ] Apple Developer Account setup
- [ ] Code signing certificates
- [ ] Provisioning profiles
- [ ] App Store Connect setup
- [ ] Bundle identifier registration

---

## 🚀 **Method 1: Build on Mac (Recommended)**

### **Prerequisites:**
1. ✅ macOS 12.0 or later
2. ✅ Xcode 14.0 or later (from App Store)
3. ✅ CocoaPods installed: `sudo gem install cocoapods`
4. ✅ Apple Developer Account ($99/year for App Store)

### **Step-by-Step Build Process:**

#### **1. Transfer Project to Mac**
```bash
# Option A: Clone from GitHub
git clone https://github.com/Tarun-goswamii/AI-Powered-Sports-Assessment-Application.git
cd sports_assessment_app

# Option B: Copy via USB/Cloud
# Transfer the entire project folder to your Mac
```

#### **2. Setup Flutter on Mac**
```bash
# Install Flutter if not already installed
# Download from: https://flutter.dev/docs/get-started/install/macos

# Verify installation
flutter doctor

# Expected output should show:
# [✓] Flutter
# [✓] Xcode
# [✓] iOS toolchain
```

#### **3. Install Dependencies**
```bash
cd /path/to/sports_assessment_app

# Get Flutter packages
flutter pub get

# Install iOS pods
cd ios
pod install
cd ..
```

#### **4. Open in Xcode**
```bash
# Open iOS project in Xcode
open ios/Runner.xcworkspace
```

#### **5. Configure in Xcode**

**In Xcode:**
1. Select **Runner** in the project navigator
2. Go to **Signing & Capabilities** tab
3. **Team:** Select your Apple Developer team
4. **Bundle Identifier:** Change to `com.yourcompany.sports_assessment_app`
   - Must be unique on App Store
   - Use reverse domain notation
5. **Signing:** Enable "Automatically manage signing"

**Update Info.plist permissions:**
- Camera Usage: "We need camera access to record your fitness tests"
- Photo Library: "We need to save your test videos"
- Motion & Fitness: "We need to track your movement during tests"

#### **6. Build for Testing (Debug)**
```bash
# Build and run on simulator
flutter run -d "iPhone 15 Pro"

# Build and run on physical device
flutter run -d [device-id]
```

#### **7. Build Release IPA**
```bash
# Build IPA for App Store distribution
flutter build ipa --release

# Output location:
# build/ios/ipa/sports_assessment_app.ipa
```

#### **8. Alternative: Build Archive in Xcode**
1. In Xcode: **Product > Archive**
2. Wait for archive to complete
3. Window > Organizer opens
4. Select your archive
5. Click **Distribute App**
6. Choose distribution method:
   - **App Store Connect** - For App Store
   - **Ad Hoc** - For testing (max 100 devices)
   - **Enterprise** - For internal distribution
   - **Development** - For local testing

---

## 🌥️ **Method 2: Cloud Build (No Mac Required)**

### **Codemagic (Recommended)**

**Setup:**
1. **Sign up:** https://codemagic.io
2. **Connect GitHub:** Link your repository
3. **Configure Build:**
   ```yaml
   # codemagic.yaml
   workflows:
     ios-workflow:
       name: iOS Release
       max_build_duration: 60
       environment:
         flutter: stable
         xcode: latest
         cocoapods: default
       scripts:
         - name: Install dependencies
           script: flutter pub get
         - name: Build iOS
           script: flutter build ipa --release
       artifacts:
         - build/ios/ipa/*.ipa
       publishing:
         email:
           recipients:
             - your-email@example.com
   ```
4. **Trigger Build:** Push to main branch or manual trigger
5. **Download IPA:** From Codemagic dashboard

**Pricing:**
- Free: 500 build minutes/month
- Pro: $99/month unlimited builds

### **GitHub Actions**

Create `.github/workflows/ios-build.yml`:
```yaml
name: iOS Build

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.32.2'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Build iOS
      run: flutter build ios --release --no-codesign
    
    - name: Upload IPA
      uses: actions/upload-artifact@v3
      with:
        name: ios-build
        path: build/ios/iphoneos/Runner.app
```

**Note:** GitHub Actions macOS runners are free for public repos, paid for private.

---

## 📱 **App Store Submission Checklist**

### **Before Submission:**
- [ ] Apple Developer Account active ($99/year)
- [ ] App Store Connect app created
- [ ] Bundle ID registered
- [ ] App icons (all sizes)
- [ ] Screenshots (all required sizes)
- [ ] App description written
- [ ] Privacy policy URL
- [ ] Support URL
- [ ] Keywords researched
- [ ] Category selected
- [ ] Age rating completed
- [ ] Pricing set

### **Required Assets:**

**App Icons:**
- 1024x1024 (App Store)
- 180x180 (iPhone)
- 167x167 (iPad Pro)
- 152x152 (iPad)
- 120x120 (iPhone)
- 87x87 (iPhone small)
- 76x76 (iPad)
- 58x58 (Settings)
- 40x40 (Spotlight)
- 29x29 (Notification)

**Screenshots Required:**
- 6.7" Display (iPhone 15 Pro Max): 1290 x 2796
- 6.5" Display (iPhone 14 Plus): 1242 x 2688
- 5.5" Display (iPhone 8 Plus): 1242 x 2208
- iPad Pro (12.9"): 2048 x 2732

**Tip:** Use `flutter build ios --release` and run on simulators to capture screenshots.

---

## 🔐 **Code Signing Setup**

### **On Mac with Xcode:**

1. **Open Xcode Preferences:**
   - Xcode > Settings > Accounts
   - Add your Apple ID

2. **Manage Certificates:**
   - Click "Manage Certificates"
   - Click "+" and add:
     - Apple Development (for testing)
     - Apple Distribution (for App Store)

3. **Provisioning Profiles:**
   - Automatic: Xcode handles it (easier)
   - Manual: Create on developer.apple.com

### **For Cloud Builds:**

1. **Export Certificates from Mac:**
   ```bash
   # In Keychain Access on Mac
   # Export certificates as .p12 files
   ```

2. **Add to Cloud Service:**
   - Upload .p12 certificates
   - Add provisioning profiles
   - Enter bundle identifier

---

## 🛠️ **iOS-Specific Configurations**

### **Update Bundle Identifier:**

**In Xcode:**
1. Open `ios/Runner.xcworkspace`
2. Select Runner target
3. General tab > Bundle Identifier
4. Change to: `com.yourcompany.sportsassessment`

**Or manually in `ios/Runner.xcodeproj/project.pbxproj`:**
```
PRODUCT_BUNDLE_IDENTIFIER = com.yourcompany.sportsassessment;
```

### **Update Version & Build Number:**

**In `pubspec.yaml`:**
```yaml
version: 1.0.0+1
# Format: major.minor.patch+buildNumber
```

**Or in Xcode:**
- Version (CFBundleShortVersionString): 1.0.0
- Build (CFBundleVersion): 1

### **Add Required Permissions:**

**Edit `ios/Runner/Info.plist`:**
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to record your fitness tests and analyze your form</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>We need to save your test videos to your photo library</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need to save your test results</string>

<key>NSMotionUsageDescription</key>
<string>We need motion data to accurately track your fitness activities</string>

<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to find nearby fitness centers</string>
```

---

## 📊 **Build Outputs**

### **Debug Build:**
```bash
flutter build ios --debug
# Output: build/ios/iphoneos/Runner.app
# Can be run on simulators and physical devices with developer cert
```

### **Release Build:**
```bash
flutter build ios --release
# Output: build/ios/iphoneos/Runner.app
# Optimized, no debugging symbols
```

### **IPA for Distribution:**
```bash
flutter build ipa --release
# Output: build/ios/ipa/sports_assessment_app.ipa
# Ready for TestFlight or App Store
```

---

## 🧪 **Testing Options**

### **1. Simulator (Free)**
```bash
# List available simulators
flutter emulators

# Run on specific simulator
flutter run -d "iPhone 15 Pro"
```

### **2. Physical Device (Free, requires cable)**
```bash
# Connect iPhone via USB
# Trust computer on device

# Build and run
flutter run -d [device-name]
```

### **3. TestFlight (Free Beta Testing)**
1. Upload IPA to App Store Connect
2. Create TestFlight group
3. Add tester emails (up to 10,000 external)
4. Testers install TestFlight app
5. Receive build notification

### **4. Ad Hoc Distribution (100 devices max)**
1. Register device UDIDs
2. Create ad hoc provisioning profile
3. Build with profile
4. Distribute IPA file
5. Install via cable or OTA

---

## 💰 **Costs**

| Item | Cost | Frequency |
|------|------|-----------|
| Apple Developer Program | $99 | Annual |
| macOS Device (if buying) | $999+ | One-time |
| Codemagic Pro (optional) | $99 | Monthly |
| GitHub Actions (private repo) | $0.008/min | Per build |
| Mac Mini Cloud Rental | $30-50 | Monthly |

**Cheapest Option:** Use GitHub Actions for public repo (FREE)

---

## 📚 **Resources**

### **Official Documentation:**
- Flutter iOS Deployment: https://flutter.dev/docs/deployment/ios
- Apple Developer: https://developer.apple.com
- App Store Connect: https://appstoreconnect.apple.com

### **Tutorials:**
- Flutter iOS Release Build: https://docs.flutter.dev/deployment/ios
- TestFlight Setup: https://developer.apple.com/testflight
- App Store Submission: https://developer.apple.com/app-store/submissions

### **Tools:**
- Codemagic: https://codemagic.io
- Bitrise: https://bitrise.io
- Fastlane (automation): https://fastlane.tools

---

## ⚡ **Quick Commands Reference**

```bash
# Build debug
flutter build ios --debug

# Build release
flutter build ios --release

# Build IPA for App Store
flutter build ipa --release

# Build for specific flavor
flutter build ios --release --flavor production

# Clean build
flutter clean
cd ios
pod deintegrate
pod install
cd ..
flutter build ios --release

# Run on device
flutter run -d "iPhone"

# List devices
flutter devices

# Analyze project
flutter analyze

# Test
flutter test
```

---

## ✅ **Next Steps**

1. **If you have a Mac:**
   - Transfer project to Mac
   - Follow "Method 1: Build on Mac" above
   - Estimated time: 2-3 hours (first time)

2. **If you don't have a Mac:**
   - Set up Codemagic (20 minutes)
   - Configure GitHub Actions (30 minutes)
   - Or wait until Mac access available

3. **For App Store submission:**
   - Create Apple Developer account
   - Prepare all assets (screenshots, icons)
   - Write app description
   - Submit for review (1-2 days review time)

---

## 🎯 **Current Project Status**

✅ **Android Build:** COMPLETE
- Debug APK: Built successfully
- Release APK: Built successfully (91MB)

⏳ **iOS Build:** PENDING (requires macOS)
- Project configured
- Ready for build on Mac
- All dependencies in pubspec.yaml

✅ **Backend:** DEPLOYED
- Convex: https://fantastic-ibex-496.convex.cloud
- All functions operational

---

**Need help?** Reach out when you have Mac access or cloud build service set up!
