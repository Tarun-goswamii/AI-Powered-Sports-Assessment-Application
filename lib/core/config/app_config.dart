import 'mobile_config.dart';

class AppConfig {
  static const String appName = 'Sports Assessment';
  static const String appVersion = '1.0.0';

  // Firebase Configuration
  static const String firebaseApiKey = 'AIzaSyAPifHu945t_OZ9HkFkLW9hlHRyFRy8Kug';
  static const String firebaseAuthDomain = 'ai-sport-assessment.firebaseapp.com';
  static const String firebaseProjectId = 'ai-sport-assessment';
  static const String firebaseStorageBucket = 'ai-sport-assessment.firebasestorage.app';
  static const String firebaseMessagingSenderId = '353205052706';
  static const String firebaseAppId = '1:353205052706:android:5815e7b99f14911b32317b';

  // CONVEX Configuration
  static const String convexUrl = 'https://fantastic-ibex-496.convex.cloud'; // Production URL
  static const String convexDevUrl = 'https://pleasant-mandrill-295.convex.cloud'; // Dev URL
  static const String convexApiKey = 'dev:pleasant-mandrill-295|eyJ2MiI6IjcyNzA4NGI5MDVjYTQyYzg5YmM2NDg1NmI2ZjNmYjViIn0=';
  static const String convexToken = 'dev:pleasant-mandrill-295|eyJ2MiI6IjcyNzA4NGI5MDVjYTQyYzg5YmM2NDg1NmI2ZjNmYjViIn0=';
  static const String convexHttpActionUrl = 'https://fantastic-ibex-496.convex.site';
  static const bool enableConvexBackend = true;

  // Vercel Configuration
  static const String vercelUrl = String.fromEnvironment('VERCEL_URL', defaultValue: 'localhost:3000');
  static String get apiBaseUrl => isProduction || vercelUrl.isNotEmpty 
    ? 'https://$vercelUrl/api' 
    : 'http://localhost:3000/api';

  // ML SERVER Configuration
  static const String mlServerUrlLocal = 'http://localhost:5001';
  static const String mlServerUrlProd = 'https://sports-assessment-ml.railway.app'; // Replace with your deployed URL
  
  // Mobile-specific ML server URL detection
  static Future<String> getMlServerUrlAsync() async {
    if (isProduction) {
      return mlServerUrlProd;
    } else {
      // For development, use MobileConfig to detect network
      return await MobileConfig.getMlServerUrl();
    }
  }
  
  static String get mlServerUrl {
    if (isProduction) {
      return mlServerUrlProd;
    } else {
      // Synchronous fallback
      return MobileConfig.getMlServerUrlSync();
    }
  }
  
  static const bool enableMLAnalysis = true;

  // RESEND Configuration
  static const String resendApiKey = 're_gUTc5fg4_WoqiCG2N7BvgaUyhyUKW7gLU';
  static const bool enableResendEmails = true;

  // VAPI AI Configuration (Currently using fallback mode)
  static const String vapiApiKey = 'fe20c242-7427-4e70-832e-cc576834fae2'; // Your actual VAPI public key
  static const String vapiBaseUrl = 'https://api.vapi.ai';
  static const String vapiAssistantId = 'sports_coach_assistant';

  // Environment flags
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool enableLogging = !isProduction;

  // API endpoints
  static const String baseApiUrl = 'https://api.sportsassessment.com';

  // App constants
  static const int sessionTimeoutMinutes = 30;
  static const int maxRetryAttempts = 3;
  static const Duration apiTimeout = Duration(seconds: 30);

  // Feature flags
  static const bool enableAIChat = true;
  static const bool enableVapiChat = false; // Disabled - using fallback responses
  static const bool enableCameraTests = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
}
