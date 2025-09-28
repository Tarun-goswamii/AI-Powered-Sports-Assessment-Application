import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    CustomSnackbarType type = CustomSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? action,
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      action: actionLabel != null && action != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: action,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getBackgroundColor(CustomSnackbarType type) {
    switch (type) {
      case CustomSnackbarType.success:
        return AppColors.neonGreen;
      case CustomSnackbarType.error:
        return AppColors.brightRed;
      case CustomSnackbarType.warning:
        return AppColors.warmOrange;
      case CustomSnackbarType.info:
      default:
        return AppColors.royalPurple;
    }
  }

  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: CustomSnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: CustomSnackbarType.error);
  }

  static void showWarning(BuildContext context, String message) {
    show(context, message: message, type: CustomSnackbarType.warning);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: CustomSnackbarType.info);
  }
}

enum CustomSnackbarType {
  success,
  error,
  warning,
  info,
}
