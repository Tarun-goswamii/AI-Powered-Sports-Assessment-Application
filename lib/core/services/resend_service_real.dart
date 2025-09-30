import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

/// RESEND Service for Email Communications
/// Real implementation using RESEND API
class ResendService {
  static ResendService? _instance;
  final String _baseUrl = 'https://api.resend.com';
  final String _apiKey;

  static ResendService get instance {
    _instance ??= ResendService._();
    return _instance!;
  }

  ResendService._() : _apiKey = AppConfig.resendApiKey;

  /// Initialize RESEND client
  static Future<void> initialize() async {
    print('RESEND service initialized with real API');
  }

  /// Send email using RESEND API
  Future<void> _sendEmail({
    required String to,
    required String subject,
    required String html,
    String? from,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/emails'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': from ?? 'Sports Assessment <noreply@sportsassessment.com>',
          'to': [to],
          'subject': subject,
          'html': html,
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully to $to');
      } else {
        throw Exception('Failed to send email: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Failed to send email: $e');
      rethrow;
    }
  }

  /// Send welcome email to new users
  Future<void> sendWelcomeEmail({
    required String toEmail,
    required String userName,
  }) async {
    const subject = 'Welcome to Sports Assessment! 🎉';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Welcome to Sports Assessment</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #4F46E5; text-align: center;">Welcome to Sports Assessment!</h1>
        <p>Hi $userName,</p>
        <p>Welcome to the AI-Powered Sports Talent Assessment platform! We're excited to have you join our community of athletes and coaches.</p>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">Get Started:</h3>
          <ul style="padding-left: 20px;">
            <li>Complete your profile with body measurements</li>
            <li>Take your first talent assessment test</li>
            <li>Explore personalized training recommendations</li>
            <li>Connect with expert mentors</li>
          </ul>
        </div>

        <p>Ready to discover your athletic potential? Let's get started!</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app"
             style="background-color: #4F46E5; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Open App
          </a>
        </div>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send account registration confirmation email
  Future<void> sendAccountRegistrationEmail({
    required String toEmail,
    required String userName,
  }) async {
    const subject = 'Account Created Successfully! ✅';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Account Created</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #059669; text-align: center;">Account Created Successfully!</h1>
        <p>Hi $userName,</p>
        <p>Your Sports Assessment account has been created successfully! You can now access all features of our platform.</p>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #059669;">
          <h3 style="margin-top: 0; color: #065F46;">Your Account Details:</h3>
          <p><strong>Email:</strong> $toEmail</p>
          <p><strong>Registration Date:</strong> ${DateTime.now().toString().split(' ')[0]}</p>
        </div>

        <p>If you have any questions, feel free to contact our support team.</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app"
             style="background-color: #059669; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Start Assessment
          </a>
        </div>

        <p>Welcome to the team!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send test completion notification
  Future<void> sendTestCompletionEmail({
    required String toEmail,
    required String userName,
    required String testName,
    required double score,
  }) async {
    final subject = 'Test Completed: $testName - Score: ${score.toStringAsFixed(1)}';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Test Completed</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #7C3AED; text-align: center;">Test Completed! 🏆</h1>
        <p>Hi $userName,</p>
        <p>Congratulations on completing the <strong>$testName</strong> assessment!</p>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center;">
          <h2 style="margin-top: 0; color: #1F2937; font-size: 36px;">${score.toStringAsFixed(1)}</h2>
          <p style="margin-bottom: 0; color: #6B7280;">Your Score</p>
        </div>

        <p>Your results have been saved to your profile. You can view detailed analysis and personalized recommendations in the app.</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/results"
             style="background-color: #7C3AED; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            View Results
          </a>
        </div>

        <p>Keep up the great work!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send weekly progress report
  Future<void> sendWeeklyProgressEmail({
    required String toEmail,
    required String userName,
    required Map<String, dynamic> progressData,
  }) async {
    const subject = 'Your Weekly Progress Report 📊';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Weekly Progress Report</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #DC2626; text-align: center;">Weekly Progress Report</h1>
        <p>Hi $userName,</p>
        <p>Here's your progress summary for the past week:</p>

        <div style="background-color: #FEF2F2; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #991B1B;">This Week's Highlights:</h3>
          <ul style="padding-left: 20px;">
            <li><strong>Tests Completed:</strong> ${progressData['testsCompleted'] ?? 0}</li>
            <li><strong>Average Score:</strong> ${progressData['averageScore']?.toStringAsFixed(1) ?? 'N/A'}</li>
            <li><strong>Improvement:</strong> ${progressData['improvement'] ?? 'N/A'}</li>
            <li><strong>Goals Achieved:</strong> ${progressData['goalsAchieved'] ?? 0}</li>
          </ul>
        </div>

        <p>Continue your training and keep pushing your limits!</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/progress"
             style="background-color: #DC2626; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            View Full Report
          </a>
        </div>

        <p>Stay consistent!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send achievement unlocked notification
  Future<void> sendAchievementEmail({
    required String toEmail,
    required String userName,
    required String achievementName,
    required String achievementDescription,
  }) async {
    final subject = 'Achievement Unlocked: $achievementName 🏅';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Achievement Unlocked</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #D97706; text-align: center;">Achievement Unlocked! 🏅</h1>
        <p>Hi $userName,</p>
        <p>Congratulations! You've unlocked a new achievement:</p>

        <div style="background-color: #FFFBEB; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; border: 2px solid #D97706;">
          <h2 style="margin-top: 0; color: #92400E; font-size: 24px;">$achievementName</h2>
          <p style="margin-bottom: 0; color: #78350F;">$achievementDescription</p>
        </div>

        <p>This achievement has been added to your profile. Keep up the excellent work!</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/achievements"
             style="background-color: #D97706; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            View Achievements
          </a>
        </div>

        <p>Amazing work!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
  }) async {
    const subject = 'Password Reset Request 🔐';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Password Reset</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #2563EB; text-align: center;">Password Reset Request</h1>
        <p>Hi there,</p>
        <p>We received a request to reset your password for your Sports Assessment account.</p>

        <div style="background-color: #EFF6FF; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center;">
          <p style="margin-bottom: 0;">Click the button below to reset your password:</p>
          <a href="https://sportsassessment.com/reset-password?token=$resetToken"
             style="background-color: #2563EB; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold; display: inline-block; margin-top: 10px;">
            Reset Password
          </a>
        </div>

        <p>If you didn't request this password reset, please ignore this email. Your password will remain unchanged.</p>
        <p>This link will expire in 24 hours for security reasons.</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send mentor connection notification
  Future<void> sendMentorConnectionEmail({
    required String toEmail,
    required String userName,
    required String mentorName,
  }) async {
    final subject = 'Mentor Connection: $mentorName 🤝';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Mentor Connection</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #16A34A; text-align: center;">Mentor Connection Established! 🤝</h1>
        <p>Hi $userName,</p>
        <p>Great news! You've been connected with <strong>$mentorName</strong> as your mentor.</p>

        <div style="background-color: #F0FDF4; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #166534;">Your Mentor: $mentorName</h3>
          <p>$mentorName is now available to provide personalized guidance and support for your athletic development.</p>
          <ul style="padding-left: 20px;">
            <li>Get personalized training advice</li>
            <li>Receive performance analysis</li>
            <li>Access expert recommendations</li>
            <li>Schedule one-on-one sessions</li>
          </ul>
        </div>

        <p>You can now message your mentor and schedule sessions through the app.</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/mentors"
             style="background-color: #16A34A; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Contact Mentor
          </a>
        </div>

        <p>Best of luck with your training!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }

  /// Send order confirmation email
  Future<void> sendOrderConfirmationEmail({
    required String toEmail,
    required String userName,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    final subject = 'Order Confirmation: $orderId 🛒';
    final itemsHtml = items.map((item) => '''
      <tr>
        <td style="padding: 8px; border-bottom: 1px solid #E5E7EB;">${item['name']}</td>
        <td style="padding: 8px; border-bottom: 1px solid #E5E7EB; text-align: center;">${item['quantity'] ?? 1}</td>
        <td style="padding: 8px; border-bottom: 1px solid #E5E7EB; text-align: right;">${item['price']} credits</td>
      </tr>
    ''').join();

    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Order Confirmation</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #7C3AED; text-align: center;">Order Confirmed! 🛒</h1>
        <p>Hi $userName,</p>
        <p>Thank you for your order! Your purchase has been confirmed.</p>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">Order Details:</h3>
          <p><strong>Order ID:</strong> $orderId</p>
          <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
            <thead>
              <tr style="background-color: #E5E7EB;">
                <th style="padding: 8px; text-align: left; border-bottom: 1px solid #D1D5DB;">Item</th>
                <th style="padding: 8px; text-align: center; border-bottom: 1px solid #D1D5DB;">Qty</th>
                <th style="padding: 8px; text-align: right; border-bottom: 1px solid #D1D5DB;">Price</th>
              </tr>
            </thead>
            <tbody>
              $itemsHtml
            </tbody>
            <tfoot>
              <tr style="background-color: #E5E7EB; font-weight: bold;">
                <td colspan="2" style="padding: 8px; text-align: right;">Total:</td>
                <td style="padding: 8px; text-align: right;">$totalAmount credits</td>
              </tr>
            </tfoot>
          </table>
        </div>

        <p>Your order will be processed shortly. You can track your order status in the app.</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/orders"
             style="background-color: #7C3AED; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Track Order
          </a>
        </div>

        <p>Thank you for shopping with us!<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _sendEmail(to: toEmail, subject: subject, html: html);
  }
}

/// Riverpod provider for RESEND service
final resendServiceProvider = Provider<ResendService>((ref) {
  return ResendService.instance;
});
