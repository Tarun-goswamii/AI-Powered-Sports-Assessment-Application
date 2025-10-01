import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CustomSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    CustomSnackbarType type = CustomSnackbarType.info,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? action,
  }) {
    final snackBar = SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcon(type),
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 8,
      action: actionLabel != null && action != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.2),
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
        return AppColors.royalPurple;
    }
  }

  static IconData _getIcon(CustomSnackbarType type) {
    switch (type) {
      case CustomSnackbarType.success:
        return Icons.check_circle_outline;
      case CustomSnackbarType.error:
        return Icons.error_outline;
      case CustomSnackbarType.warning:
        return Icons.warning_amber_outlined;
      case CustomSnackbarType.info:
        return Icons.info_outline;
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
