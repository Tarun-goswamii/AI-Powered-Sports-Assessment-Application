import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_convex_service.dart';
import 'resend_service.dart';
import 'auth_service.dart';
import 'firebase_auth_service.dart';
import 'firebase_service.dart';
import 'vapi_ai_service.dart';
import '../config/app_config.dart';

/// Service Manager to handle all external services
class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  late final ConvexService _convexService;
  late final ResendService _resendService;

  ConvexService get convex => _convexService;
  ResendService get resend => _resendService;

  /// Initialize all services
  Future<void> initialize() async {
    print('🔧 Initializing Service Manager...');

    // Initialize CONVEX service (real API implementation)
    if (AppConfig.enableConvexBackend) {
      _convexService = ConvexService();
      await _convexService.initialize();
      print('✅ CONVEX service initialized with real API calls');
    }

    // Initialize RESEND service
    if (AppConfig.enableResendEmails) {
      _resendService = ResendService.instance;
      await ResendService.initialize();
      print('✅ RESEND service initialized with real API calls');
    }

    // Initialize VAPI AI service
    await VapiAiService.initialize();

    print('🎉 All services initialized successfully!');
  }

  /// Get service health status
  Future<Map<String, bool>> getServiceHealth() async {
    return {
      'convex': AppConfig.enableConvexBackend,
      'resend': AppConfig.enableResendEmails,
      'vapi_ai': AppConfig.enableVapiChat,
    };
  }
}

/// Riverpod provider for Service Manager
final serviceManagerProvider = Provider<ServiceManager>((ref) {
  return ServiceManager();
});

/// CONVEX service provider
final convexServiceProvider = Provider<ConvexService>((ref) {
  return ServiceManager().convex;
});

/// RESEND service provider
final resendServiceProvider = Provider<ResendService>((ref) {
  return ServiceManager().resend;
});

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Firebase Auth service provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

/// Firebase service provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// VAPI AI service provider
final vapiAiServiceProvider = Provider<VapiAiService>((ref) {
  return VapiAiService.instance;
});
