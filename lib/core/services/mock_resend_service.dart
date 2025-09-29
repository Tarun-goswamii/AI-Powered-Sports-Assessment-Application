import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock RESEND Service for Email Communications
/// This is a temporary implementation until the actual RESEND Dart package is available
class MockResendService {
  static final MockResendService _instance = MockResendService._internal();
  factory MockResendService() => _instance;
  MockResendService._internal();

  /// Initialize RESEND client
  Future<void> initialize() async {
    print('Mock RESEND service initialized');
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Send welcome email to new users
  Future<void> sendWelcomeEmail({
    required String toEmail,
    required String userName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    print('Mock RESEND: Welcome email sent to $toEmail for user $userName');
    print('Email content: Welcome to AI Sports Talent Assessment!');
  }

  /// Send test completion notification
  Future<void> sendTestCompletionEmail({
    required String toEmail,
    required String userName,
    required String testName,
    required double score,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    print('Mock RESEND: Test completion email sent to $toEmail');
    print('Test: $testName, Score: $score, User: $userName');
  }

  /// Send weekly progress report
  Future<void> sendWeeklyProgressEmail({
    required String toEmail,
    required String userName,
    required Map<String, dynamic> progressData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    print('Mock RESEND: Weekly progress email sent to $toEmail for $userName');
    print('Progress data: $progressData');
  }

  /// Send achievement unlocked notification
  Future<void> sendAchievementEmail({
    required String toEmail,
    required String userName,
    required String achievementName,
    required String achievementDescription,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Mock RESEND: Achievement email sent to $toEmail');
    print('Achievement: $achievementName - $achievementDescription');
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock RESEND: Password reset email sent to $toEmail');
    print('Reset token: $resetToken');
  }

  /// Send mentor connection notification
  Future<void> sendMentorConnectionEmail({
    required String toEmail,
    required String userName,
    required String mentorName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 550));
    print('Mock RESEND: Mentor connection email sent to $toEmail');
    print('Mentor: $mentorName, User: $userName');
  }

  /// Send order confirmation email
  Future<void> sendOrderConfirmationEmail({
    required String toEmail,
    required String userName,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    await Future.delayed(const Duration(milliseconds: 650));
    print('Mock RESEND: Order confirmation email sent to $toEmail');
    print('Order ID: $orderId, Total: ₹$totalAmount');
    print('Items: ${items.length} products');
  }

  /// Send promotional newsletter
  Future<void> sendNewsletterEmail({
    required List<String> toEmails,
    required String subject,
    required String content,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    print('Mock RESEND: Newsletter sent to ${toEmails.length} recipients');
    print('Subject: $subject');
  }

  /// Send system maintenance notification
  Future<void> sendMaintenanceEmail({
    required List<String> toEmails,
    required DateTime maintenanceTime,
    required Duration duration,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock RESEND: Maintenance notification sent to ${toEmails.length} users');
    print('Maintenance scheduled for: $maintenanceTime, Duration: ${duration.inHours} hours');
  }

  /// Send feedback request email
  Future<void> sendFeedbackEmail({
    required String toEmail,
    required String userName,
    required String testName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 450));
    print('Mock RESEND: Feedback request sent to $toEmail for $testName');
  }

  /// Send referral invitation email
  Future<void> sendReferralEmail({
    required String toEmail,
    required String referrerName,
    required String referralCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 520));
    print('Mock RESEND: Referral invitation sent to $toEmail');
    print('Referrer: $referrerName, Code: $referralCode');
  }

  /// Get email delivery statistics
  Future<Map<String, dynamic>> getEmailStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'totalSent': 1250,
      'delivered': 1180,
      'opened': 890,
      'clicked': 245,
      'bounced': 15,
      'complained': 2,
      'deliveryRate': 94.4,
      'openRate': 75.4,
      'clickRate': 27.5,
    };
  }

  /// Validate email address
  Future<bool> validateEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Simple email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Get email templates
  Future<List<Map<String, dynamic>>> getEmailTemplates() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      {
        'id': 'welcome',
        'name': 'Welcome Email',
        'subject': 'Welcome to AI Sports Talent Assessment!',
        'category': 'Onboarding',
      },
      {
        'id': 'test_completion',
        'name': 'Test Completion',
        'subject': 'Your Test Results Are Ready!',
        'category': 'Results',
      },
      {
        'id': 'achievement',
        'name': 'Achievement Unlocked',
        'subject': '🏆 Achievement Unlocked!',
        'category': 'Gamification',
      },
      {
        'id': 'weekly_report',
        'name': 'Weekly Progress Report',
        'subject': 'Your Weekly Sports Progress Report',
        'category': 'Reports',
      },
    ];
  }
}

/// Riverpod provider for Mock RESEND service
final mockResendServiceProvider = Provider<MockResendService>((ref) {
  return MockResendService();
});
