import '../utils/network_helper.dart';

class MobileConfig {
  // Network configuration for mobile devices
  static const String localNetworkIP = '192.168.1.100'; // Will be auto-detected
  static const int mlServerPort = 5001;
  
  // Development URLs (localhost for emulator, IP for real device)
  static const String mlServerUrlLocalhost = 'http://localhost:5001';
  static String get mlServerUrlMobile => 'http://$localNetworkIP:$mlServerPort';
  
  // Production URLs (these will be your deployed servers)
  static const String mlServerUrlProduction = 'https://your-ml-server.onrender.com';
  static const String convexUrlProduction = 'https://fantastic-ibex-496.convex.cloud';
  
  // Auto-detect environment
  static bool get isEmulator {
    // This will be detected at runtime
    return const bool.fromEnvironment('dart.vm.product') == false;
  }
  
  // Get the appropriate ML server URL based on environment
  static Future<String> getMlServerUrl() async {
    try {
      // Always try to get the actual network IP for mobile connectivity
      return await NetworkHelper.getMobileMLServerUrl(port: mlServerPort);
    } catch (e) {
      // Fallback to localhost
      return mlServerUrlLocalhost;
    }
  }
  
  // Synchronous version for immediate use
  static String getMlServerUrlSync() {
    return mlServerUrlLocalhost; // Fallback for sync operations
  }
  
  // Video recording settings for mobile
  static const Duration maxRecordingDuration = Duration(minutes: 2);
  static const String videoFormat = 'mp4';
  static const int videoQuality = 720; // 720p for mobile optimization
  
  // File upload settings
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const Duration uploadTimeout = Duration(minutes: 5);
  
  // Camera settings
  static const bool enableFrontCamera = true;
  static const bool enableBackCamera = true;
  static const bool defaultToBackCamera = true;
}