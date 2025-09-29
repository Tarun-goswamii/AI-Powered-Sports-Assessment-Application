import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class EnhancedSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    EnhancedSnackbarType type = EnhancedSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? action,
  }) {
    final snackBar = SnackBar(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getShadowColor(type).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getBackgroundColor(type).withOpacity(0.9),
                    _getBackgroundColor(type).withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _getBorderColor(type).withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getShadowColor(type).withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon with gradient background
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getIconColor(type).withOpacity(0.8),
                          _getIconColor(type).withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: _getIconColor(type).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getIcon(type),
                      size: 18,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Message text
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: _getTextColor(type),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Action button if provided
                  if (actionLabel != null && action != null) ...[
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: action,
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          actionLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getBackgroundColor(EnhancedSnackbarType type) {
    switch (type) {
      case EnhancedSnackbarType.success:
        return AppColors.neonGreen;
      case EnhancedSnackbarType.error:
        return AppColors.brightRed;
      case EnhancedSnackbarType.warning:
        return AppColors.warmOrange;
      case EnhancedSnackbarType.info:
      default:
        return AppColors.royalPurple;
    }
  }

  static Color _getBorderColor(EnhancedSnackbarType type) {
    switch (type) {
      case EnhancedSnackbarType.success:
        return AppColors.neonGreen;
      case EnhancedSnackbarType.error:
        return AppColors.brightRed;
      case EnhancedSnackbarType.warning:
        return AppColors.warmOrange;
      case EnhancedSnackbarType.info:
      default:
        return AppColors.electricBlue;
    }
  }

  static Color _getShadowColor(EnhancedSnackbarType type) {
    switch (type) {
      case EnhancedSnackbarType.success:
        return AppColors.neonGreen;
      case EnhancedSnackbarType.error:
        return AppColors.brightRed;
      case EnhancedSnackbarType.warning:
        return AppColors.warmOrange;
      case EnhancedSnackbarType.info:
      default:
        return AppColors.royalPurple;
    }
  }

  static Color _getIconColor(EnhancedSnackbarType type) {
    switch (type) {
      case EnhancedSnackbarType.success:
        return AppColors.neonGreen;
      case EnhancedSnackbarType.error:
        return AppColors.brightRed;
      case EnhancedSnackbarType.warning:
        return AppColors.warmOrange;
      case EnhancedSnackbarType.info:
      default:
        return AppColors.electricBlue;
    }
  }

  static Color _getTextColor(EnhancedSnackbarType type) {
    // High contrast white text for all types
    return Colors.white;
  }

  static IconData _getIcon(EnhancedSnackbarType type) {
    switch (type) {
      case EnhancedSnackbarType.success:
        return Icons.check_circle_rounded;
      case EnhancedSnackbarType.error:
        return Icons.error_rounded;
      case EnhancedSnackbarType.warning:
        return Icons.warning_rounded;
      case EnhancedSnackbarType.info:
      default:
        return Icons.info_rounded;
    }
  }

  static void showSuccess(BuildContext context, String message, {String? actionLabel, VoidCallback? action}) {
    show(context, message: message, type: EnhancedSnackbarType.success, actionLabel: actionLabel, action: action);
  }

  static void showError(BuildContext context, String message, {String? actionLabel, VoidCallback? action}) {
    show(context, message: message, type: EnhancedSnackbarType.error, actionLabel: actionLabel, action: action);
  }

  static void showWarning(BuildContext context, String message, {String? actionLabel, VoidCallback? action}) {
    show(context, message: message, type: EnhancedSnackbarType.warning, actionLabel: actionLabel, action: action);
  }

  static void showInfo(BuildContext context, String message, {String? actionLabel, VoidCallback? action}) {
    show(context, message: message, type: EnhancedSnackbarType.info, actionLabel: actionLabel, action: action);
  }
}

enum EnhancedSnackbarType {
  success,
  error,
  warning,
  info,
}
