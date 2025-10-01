import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// RESEND Service for Email Communications
/// Real implementation using RESEND HTTP API
class ResendService {
  static const String apiKey = AppConfig.resendApiKey;
  static const String baseUrl = 'https://api.resend.com';

  static ResendService? _instance;

  static ResendService get instance {
    _instance ??= ResendService._();
    return _instance!;
  }

  ResendService._();

  /// Initialize RESEND client
  static Future<void> initialize() async {
    print('✅ RESEND service initialized with real API calls');
  }

  /// Instance method to send email
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String html,
  }) async {
    await _sendEmail(to: to, subject: subject, html: html);
  }

  /// Send welcome email to new users
  static Future<void> sendWelcomeEmail({
    required String toEmail,
    required String userName,
  }) async {
    await _sendEmail(
      to: toEmail,
      subject: 'Welcome to Sports Assessment!',
      html: '''
      <h1>Welcome, $userName!</h1>
      <p>Thank you for joining Sports Assessment. Your journey to athletic excellence starts now!</p>
      <p>Start your first test and discover your potential.</p>
      <p>Best regards,<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send account registration confirmation email
  static Future<void> sendAccountRegistrationEmail({
    required String toEmail,
    required String userName,
  }) async {
    await _sendEmail(
      to: toEmail,
      subject: 'Account Registration Confirmed',
      html: '''
      <h1>Account Registration Successful!</h1>
      <p>Hello $userName,</p>
      <p>Your account has been successfully created. You can now access all features.</p>
      <p>If you didn't create this account, please ignore this email.</p>
      <p>Best regards,<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send test completion notification
  static Future<void> sendTestCompletionEmail({
    required String toEmail,
    required String userName,
    required String testName,
    required double score,
  }) async {
    await _sendEmail(
      to: toEmail,
      subject: 'Test Completed: $testName',
      html: '''
      <h1>Congratulations on completing $testName!</h1>
      <p>Hello $userName,</p>
      <p>You scored $score on $testName. Great job!</p>
      <p>Check your results in the app for detailed analysis and recommendations.</p>
      <p>Keep pushing your limits!<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send weekly progress report
  static Future<void> sendWeeklyProgressEmail({
    required String toEmail,
    required String userName,
    required Map<String, dynamic> progressData,
  }) async {
    final totalTests = progressData['totalTests'] ?? 0;
    final averageScore = progressData['averageScore'] ?? 0.0;

    await _sendEmail(
      to: toEmail,
      subject: 'Your Weekly Progress Report',
      html: '''
      <h1>Weekly Progress Report</h1>
      <p>Hello $userName,</p>
      <p>This week you completed $totalTests tests with an average score of ${averageScore.toStringAsFixed(1)}.</p>
      <p>You're making great progress! Keep up the good work.</p>
      <p>View detailed stats in the app.<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send achievement unlocked notification
  static Future<void> sendAchievementEmail({
    required String toEmail,
    required String userName,
    required String achievementName,
    required String achievementDescription,
  }) async {
    await _sendEmail(
      to: toEmail,
      subject: 'Achievement Unlocked: $achievementName',
      html: '''
      <h1>Congratulations! 🎉</h1>
      <p>Hello $userName,</p>
      <h2>$achievementName</h2>
      <p>$achievementDescription</p>
      <p>Share this achievement with your friends and continue your journey!</p>
      <p>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
  }) async {
    final resetUrl = 'https://sportsassessment.com/reset-password?token=$resetToken';

    await _sendEmail(
      to: toEmail,
      subject: 'Password Reset Request',
      html: '''
      <h1>Password Reset</h1>
      <p>You requested a password reset for your Sports Assessment account.</p>
      <p>Click the link below to reset your password:</p>
      <a href="$resetUrl" style="background: #6A0DAD; color: white; padding: 12px 24px; text-decoration: none; border-radius: 8px;">Reset Password</a>
      <p>If you didn't request this, please ignore this email.</p>
      <p>The link will expire in 1 hour.<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send mentor connection notification
  static Future<void> sendMentorConnectionEmail({
    required String toEmail,
    required String userName,
    required String mentorName,
  }) async {
    await _sendEmail(
      to: toEmail,
      subject: 'New Mentor Connection',
      html: '''
      <h1>New Mentor Connection!</h1>
      <p>Hello $userName,</p>
      <p>You have been connected with $mentorName.</p>
      <p>Start your personalized training journey. Check the Mentors section for details.</p>
      <p>Best of luck!<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// Send order confirmation email
  static Future<void> sendOrderConfirmationEmail({
    required String toEmail,
    required String userName,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final itemsHtml = items.map((item) => '''
      <tr>
        <td>${item['name']}</td>
        <td>₹${item['price']}</td>
        <td>${item['quantity']}</td>
        <td>₹${(item['price'] * item['quantity']).toStringAsFixed(2)}</td>
      </tr>
    ''').join('');

    await _sendEmail(
      to: toEmail,
      subject: 'Order Confirmation #$orderId',
      html: '''
      <h1>Order Confirmed!</h1>
      <p>Hello $userName,</p>
      <p>Thank you for your purchase. Your order #$orderId has been confirmed.</p>
      <h3>Order Details</h3>
      <table style="border-collapse: collapse; width: 100%;">
        <tr style="background: #f5f5f5;">
          <th style="border: 1px solid #ddd; padding: 8px;">Item</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Price</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Qty</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Total</th>
        </tr>
        $itemsHtml
        <tr style="background: #f5f5f5;">
          <td colspan="3" style="text-align: right; padding: 8px;"><strong>Total Amount:</strong></td>
          <td style="border: 1px solid #ddd; padding: 8px;"><strong>₹${totalAmount.toStringAsFixed(2)}</strong></td>
        </tr>
      </table>
      <p>Your order will be processed shortly. Check your account for updates.</p>
      <p>Thank you for choosing Sports Assessment Store!<br>The Sports Assessment Team</p>
      ''',
    );
  }

  /// General static sendEmail method for custom emails
  static Future<void> sendCustomEmail({
    required String to,
    required String subject,
    required String html,
  }) async {
    await _sendEmail(
      to: to,
      subject: subject,
      html: html,
    );
  }

  /// Internal method to send email via RESEND API
  static Future<void> _sendEmail({
    required String to,
    required String subject,
    required String html,
  }) async {
    if (!AppConfig.enableResendEmails) {
      print('Mock RESEND: Sending email to $to - Subject: $subject');
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/emails');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': 'Sports Assessment <noreply@sportsassessment.com>',
          'to': [to],
          'subject': subject,
          'html': html,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ RESEND: Email sent successfully to $to');
      } else {
        throw Exception('Failed to send email: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ RESEND _sendEmail failed: $e');
      throw e;
    }
  }
}

/// Riverpod provider for RESEND service
final resendServiceProvider = Provider<ResendService>((ref) {
  return ResendService.instance;
});
