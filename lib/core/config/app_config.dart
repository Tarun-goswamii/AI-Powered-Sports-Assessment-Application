// lib/core/config/app_config.dart
class AppConfig {
  static const String appName = 'Sports Assessment';
  static const String appVersion = '1.0.0';

  // Supabase Configuration (replace with your values)
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Environment flags
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool enableLogging = !isProduction;

  // API endpoints
  static const String baseApiUrl = supabaseUrl;

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
