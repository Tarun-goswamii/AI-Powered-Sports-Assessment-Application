class AppConfig {
  static const String appName = 'Sports Assessment';
  static const String appVersion = '1.0.0';

  // Firebase Configuration (replace with your values)
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String firebaseAuthDomain = 'YOUR_FIREBASE_AUTH_DOMAIN';
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  static const String firebaseStorageBucket = 'YOUR_FIREBASE_STORAGE_BUCKET';
  static const String firebaseMessagingSenderId = 'YOUR_FIREBASE_MESSAGING_SENDER_ID';
  static const String firebaseAppId = 'YOUR_FIREBASE_APP_ID';

  // CONVEX Configuration
  static const String convexUrl = 'YOUR_CONVEX_URL';
  static const bool enableConvexBackend = true;

  // RESEND Configuration
  static const String resendApiKey = 'YOUR_RESEND_API_KEY';
  static const bool enableResendEmails = true;

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
  static const bool enableCameraTests = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
}
