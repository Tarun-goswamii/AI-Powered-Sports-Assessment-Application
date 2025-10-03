# 🚀 QUICK START REFERENCE CARD

**AI Sports Talent Assessment Platform**  
*Get up and running in 10 minutes!*

---

## 📦 **ONE-COMMAND SETUP** (If you have everything installed)

```bash
# Clone, setup, and run
git clone https://github.com/Tarun-goswamii/AI-Powered-Sports-Assessment-Application.git && \
cd AI-Powered-Sports-Assessment-Application/src/FLUTTER\ KA\ CODEBASE/sports_assessment_app && \
flutter pub get && \
npx convex dev &
flutter run
```

---

## ⚡ **ESSENTIAL COMMANDS**

### **Setup (One Time)**
```bash
# Install dependencies
flutter pub get

# Deploy Convex backend
npx convex dev

# Check everything is ready
flutter doctor
```

### **Run App**
```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot
```

### **Build APK**
```bash
# Debug APK (testing)
flutter build apk --debug

# Release APK (production)
flutter build apk --release

# Location: build/app/outputs/flutter-apk/
```

### **Troubleshooting**
```bash
# Clean build
flutter clean && flutter pub get

# List devices
flutter devices

# Check logs
flutter logs

# Restart ADB (Android)
adb kill-server && adb start-server
```

---

## 🔑 **QUICK SETUP CHECKLIST**

- [ ] Flutter SDK installed (`flutter --version`)
- [ ] Android Studio / Xcode installed
- [ ] Node.js installed (`node --version`)
- [ ] Git installed (`git --version`)
- [ ] Repository cloned
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Convex backend running (`npx convex dev`)
- [ ] Device connected (`flutter devices`)
- [ ] App running! (`flutter run`)

---

## 🔗 **IMPORTANT LINKS**

- **Main README**: [README.md](./README.md)
- **Full Setup Guide**: See "Getting Started" section in README.md
- **iOS Build**: [IOS_BUILD_GUIDE.md](./IOS_BUILD_GUIDE.md)
- **Troubleshooting**: [ERROR_SUMMARY_REPORT.md](./ERROR_SUMMARY_REPORT.md)
- **Deployment**: [FINAL_DEPLOYMENT_VERIFICATION_COMPLETE.md](./FINAL_DEPLOYMENT_VERIFICATION_COMPLETE.md)

---

## 🆘 **COMMON ISSUES**

| Problem | Solution |
|---------|----------|
| "flutter: command not found" | Add Flutter to PATH |
| "No connected devices" | Enable USB debugging on phone |
| "Gradle build failed" | Run `flutter clean` then retry |
| "Convex not loading" | Keep `npx convex dev` running |
| Package conflicts | Run `flutter pub upgrade` |

---

## 📱 **DOWNLOAD READY APKs**

If you just want to test the app without building:

1. **Android Debug APK**: `build/app/outputs/flutter-apk/app-debug.apk`
2. **Android Release APK**: `build/app/outputs/flutter-apk/app-release.apk` (91MB)

**Install on Phone:**
1. Copy APK to phone
2. Enable "Install from Unknown Sources"
3. Tap APK to install

---

## 🎯 **WHAT YOU GET**

✅ Full-featured sports assessment app  
✅ AI pose detection and analysis  
✅ Real-time leaderboards  
✅ Voice AI coach  
✅ Community features  
✅ Performance tracking  
✅ Achievement system  

---

**Need detailed help?** See the full [Getting Started Guide](./README.md#getting-started---run-the-app-on-your-phone) in README.md!

**Got it working?** Give us a star! ⭐  
**Having issues?** Open an issue on GitHub!

---

*Last Updated: October 3, 2025*
