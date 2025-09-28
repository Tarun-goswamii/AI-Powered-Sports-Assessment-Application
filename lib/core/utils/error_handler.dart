// lib/core/utils/error_handler.dart
import 'package:flutter/foundation.dart';

class ErrorHandler {
  static void handleFlutterError(FlutterErrorDetails details) {
    // Log error details
    if (kDebugMode) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    }

    // In production, you might want to send this to a logging service
    // like Sentry, Firebase Crashlytics, etc.
  }

  static void handleError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
    }

    // Handle different types of errors
    if (error is Exception) {
      // Handle specific exceptions
    }
  }
}
