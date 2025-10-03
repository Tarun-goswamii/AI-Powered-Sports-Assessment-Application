# 📊 SETUP PROCESS FLOWCHART

**Visual Guide: From Clone to Running App**

---

## 🎯 **COMPLETE SETUP FLOW**

```
┌─────────────────────────────────────────────────────────────────┐
│                    START: Clone Repository                       │
│  git clone https://github.com/Tarun-goswamii/AI-Powered...     │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│               Install Flutter Dependencies                       │
│                  flutter pub get                                 │
│            ⏱️ Takes: 2-5 minutes                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│               Setup Convex Backend                               │
│               npx convex login                                   │
│               npx convex dev                                     │
│            ⏱️ Takes: 1-2 minutes                                 │
│            ✅ Get: https://your-project.convex.cloud            │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│            Configure Environment Variables                       │
│            Create .env file                                      │
│            Add CONVEX_DEPLOYMENT_URL                            │
│            Add Firebase config                                   │
│            ⏱️ Takes: 2-3 minutes                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              Setup Firebase (Optional)                           │
│       Download google-services.json                              │
│       Place in android/app/                                      │
│            ⏱️ Takes: 3-5 minutes                                 │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              Connect Device/Emulator                             │
│                                                                  │
│  ┌──────────────┐           ┌──────────────┐                   │
│  │   Physical    │    OR     │   Emulator   │                   │
│  │    Device     │           │  /Simulator  │                   │
│  │  (USB Cable)  │           │  (Virtual)   │                   │
│  └──────────────┘           └──────────────┘                   │
│                                                                  │
│       flutter devices (to verify)                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                  RUN THE APP!                                    │
│                  flutter run                                     │
│            ⏱️ First build: 3-5 minutes                           │
│            ⏱️ Hot reload: < 1 second                             │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   🎉 SUCCESS!                                    │
│              App running on your phone!                          │
│                                                                  │
│   Features Available:                                            │
│   ✅ AI Fitness Assessments                                      │
│   ✅ Real-time Leaderboards                                      │
│   ✅ Voice AI Coach                                              │
│   ✅ Community Feed                                              │
│   ✅ Performance Analytics                                       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 **TROUBLESHOOTING DECISION TREE**

```
                    ❌ App Not Running?
                           │
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
  Build Failed?    Device Not Found?   Backend Error?
        │                  │                  │
        ▼                  ▼                  ▼
  flutter clean      adb devices        Check Convex
  flutter pub get    USB debugging      npx convex dev
  flutter run        enabled?           running?
        │                  │                  │
        ▼                  ▼                  ▼
    Retry Build      Connect Device    Restart Backend
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                           ▼
                    ✅ Problem Solved!
```

---

## 📱 **DEVICE CONNECTION FLOW**

```
        Choose Your Platform
                │
        ┌───────┴────────┐
        │                │
        ▼                ▼
    ANDROID            iOS
        │                │
        │                │
┌───────┴────────┐   ┌──┴───────────┐
│                │   │              │
▼                ▼   ▼              ▼
Physical      Emulator   Physical    Simulator
Device                   Device
│                │   │              │
│                │   │              │
1. Enable USB    │   1. USB Cable   │
   Debugging     │   2. Trust Mac   │
2. Connect USB   │   3. Open Xcode  │
3. Allow Debug   │   4. Setup Team  │
                 │                  │
                 │                  │
flutter devices  │   flutter devices│
                 │                  │
                 │                  │
flutter run -d   │   flutter run    │
<device-id>      │                  │
                 │                  │
                 │                  │
    ✅ App Running on Device!       │
```

---

## 🎯 **BUILD TYPE DECISION**

```
        What do you need?
                │
        ┌───────┼───────┐
        │       │       │
        ▼       ▼       ▼
    Testing  Friends  Store
        │       │       │
        ▼       ▼       ▼
   Debug   Release   Bundle
   Build    APK      (AAB)
        │       │       │
        │       │       │
flutter  │flutter │flutter
run      │build   │build
         │apk     │appbundle
         │--debug │--release
         │        │
         ▼        ▼
    Hot Reload   Production
    Enabled      Optimized
    Larger Size  Smaller Size
    Slower       Faster
    (50-100MB)   (30-50MB)
```

---

## 🔐 **CONFIGURATION PRIORITY**

```
                Required First
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
    Flutter      Convex       Device
     Deps        Backend      Connected
        │             │             │
        │             │             │
   flutter       npx convex    flutter
   pub get         dev         devices
        │             │             │
        └─────────────┼─────────────┘
                      │
                      ▼
              Can Run Basic App
                      │
                      │
              Optional Later
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
    Firebase      Resend        VAPI
      Auth        Email         Voice
        │             │             │
   For User    For Email    For Voice
   Accounts    Notifications   Chat
        │             │             │
   google-     API Key in   API Key
   services    .env file    in .env
   .json
```

---

## 📊 **TIME ESTIMATES**

| Task | First Time | Subsequent |
|------|-----------|------------|
| Clone Repo | 2-5 min | N/A |
| Install Deps | 2-5 min | 30 sec |
| Setup Convex | 2-3 min | 10 sec |
| Config Files | 3-5 min | N/A |
| Setup Firebase | 5-10 min | N/A |
| First Build | 3-5 min | N/A |
| Hot Reload | N/A | < 1 sec |
| Clean Build | 3-5 min | 3-5 min |
| Release APK | 1-2 min | 1-2 min |
| **TOTAL SETUP** | **20-30 min** | **1-2 min** |

---

## 🎯 **SUCCESS INDICATORS**

```
✅ Dependencies Installed
   → "flutter pub get" completes without errors
   → No red error messages

✅ Convex Backend Live
   → Terminal shows: "✔ Deployed Convex functions"
   → Dashboard accessible at convex.cloud

✅ Device Connected
   → "flutter devices" shows your device
   → Device name appears in list

✅ App Compiled
   → "flutter run" completes
   → "Running Gradle task" succeeds

✅ App Launched
   → App icon appears on phone
   → Splash screen shows
   → Home screen loads

✅ Backend Connected
   → Data loads in app
   → Leaderboards show
   → No "network error" messages

✅ Hot Reload Works
   → Press 'r' in terminal
   → UI updates instantly
   → No full rebuild needed
```

---

## 🚀 **OPTIMIZATION PATH**

```
        Basic Setup Complete
                │
                ▼
        ┌───────────────┐
        │  Test on 1    │
        │   Device      │
        └───────┬───────┘
                │
                ▼
        Works? ──→ Yes ──→ Add More Devices
                │
                No
                │
                ▼
        Debug Issues
                │
        ┌───────┴───────┐
        │               │
        ▼               ▼
    Check Logs    Clean Build
        │               │
        └───────┬───────┘
                │
                ▼
            Fix & Retry
                │
                ▼
        ┌───────────────┐
        │  All Devices  │
        │    Working    │
        └───────┬───────┘
                │
                ▼
        Build Release
                │
                ▼
        Share with Friends!
```

---

## 📱 **DISTRIBUTION OPTIONS**

```
        App Built Successfully
                │
        ┌───────┼────────────────┐
        │       │                │
        ▼       ▼                ▼
    Share    Play Store    App Store
    APK      (Android)     (iOS)
        │       │                │
        │       │                │
    USB     App Bundle      IPA File
    Email   (AAB)
    Cloud   │                │
        │   flutter          flutter
        │   build            build
        │   appbundle        ipa
        │       │                │
        ▼       ▼                ▼
    Quick   Official      Official
    Test    Release       Release
```

---

## 💡 **PRO TIPS FLOWCHART**

```
                Development Mode
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
    Use Hot       Keep Convex      Multiple
    Reload       Dev Running      Terminals
        │               │               │
    Press 'r'     Background      1. Convex Dev
    After         Terminal        2. Flutter Run
    Changes                       3. Logs
        │               │               │
        └───────────────┼───────────────┘
                        │
                        ▼
                Faster Development!
```

---

**Need more help?** Check the main [README.md](./README.md) for detailed instructions!

*Last Updated: October 3, 2025*
