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
  static const String convexUrl = 'https://pleasant-mandrill-295.convex.cloud';
  static const String convexApiKey = 'dev:pleasant-mandrill-295|eyJ2MiI6IjcyNzA4NGI5MDVjYTQyYzg5YmM2NDg1NmI2ZjNmYjViIn0=';
  static const String convexHttpActionUrl = 'https://pleasant-mandrill-295.convex.site';
  static const bool enableConvexBackend = true;

  // RESEND Configuration
  static const String resendApiKey = 're_gUTc5fg4_WoqiCG2N7BvgaUyhyUKW7gLU';
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
