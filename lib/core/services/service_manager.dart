import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'mock_convex_service.dart';
import 'mock_resend_service.dart';
import '../config/app_config.dart';

/// Service Manager to handle all external services
class ServiceManager {
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  late final MockConvexService _convexService;
  late final MockResendService _resendService;

  MockConvexService get convex => _convexService;
  MockResendService get resend => _resendService;

  /// Initialize all services
  Future<void> initialize() async {
    print('🔧 Initializing Service Manager...');

    // Initialize CONVEX service
    if (AppConfig.enableConvexBackend) {
      _convexService = MockConvexService();
      await _convexService.initialize();
      print('✅ CONVEX service initialized');
    }

    // Initialize RESEND service
    if (AppConfig.enableResendEmails) {
      _resendService = MockResendService();
      await _resendService.initialize();
      print('✅ RESEND service initialized');
    }

    print('🎉 All services initialized successfully!');
  }

  /// Get service health status
  Future<Map<String, bool>> getServiceHealth() async {
    return {
      'convex': AppConfig.enableConvexBackend,
      'resend': AppConfig.enableResendEmails,
    };
  }
}

/// Riverpod provider for Service Manager
final serviceManagerProvider = Provider<ServiceManager>((ref) {
  return ServiceManager();
});

/// CONVEX service provider
final convexServiceProvider = Provider<MockConvexService>((ref) {
  return ServiceManager().convex;
});

/// RESEND service provider
final resendServiceProvider = Provider<MockResendService>((ref) {
  return ServiceManager().resend;
});
