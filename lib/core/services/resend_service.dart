import 'package:resend_dart/resend_dart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

/// RESEND Service for Email Communications
class ResendService {
  static Resend? _client;

  static Resend get client {
    if (_client == null) {
      _client = Resend(apiKey: AppConfig.resendApiKey);
    }
    return _client!;
  }

  /// Initialize RESEND client
  static Future<void> initialize() async {
    // RESEND client is initialized lazily
    print('RESEND service initialized');
  }

  /// Send welcome email to new users
  static Future<void> sendWelcomeEmail({
    required String toEmail,
    required String userName,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <welcome@sportsassessment.app>',
        to: [toEmail],
        subject: 'Welcome to AI Sports Talent Assessment!',
        html: _buildWelcomeEmailHtml(userName),
      ));
    } catch (e) {
      print('Failed to send welcome email: $e');
      rethrow;
    }
  }

  /// Send test completion notification
  static Future<void> sendTestCompletionEmail({
    required String toEmail,
    required String userName,
    required String testName,
    required double score,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <results@sportsassessment.app>',
        to: [toEmail],
        subject: 'Your $testName Results Are Ready!',
        html: _buildTestCompletionEmailHtml(userName, testName, score),
      ));
    } catch (e) {
      print('Failed to send test completion email: $e');
      rethrow;
    }
  }

  /// Send weekly progress report
  static Future<void> sendWeeklyProgressEmail({
    required String toEmail,
    required String userName,
    required Map<String, dynamic> progressData,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <progress@sportsassessment.app>',
        to: [toEmail],
        subject: 'Your Weekly Sports Progress Report',
        html: _buildWeeklyProgressEmailHtml(userName, progressData),
      ));
    } catch (e) {
      print('Failed to send weekly progress email: $e');
      rethrow;
    }
  }

  /// Send achievement unlocked notification
  static Future<void> sendAchievementEmail({
    required String toEmail,
    required String userName,
    required String achievementName,
    required String achievementDescription,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <achievements@sportsassessment.app>',
        to: [toEmail],
        subject: '🏆 Achievement Unlocked: $achievementName',
        html: _buildAchievementEmailHtml(userName, achievementName, achievementDescription),
      ));
    } catch (e) {
      print('Failed to send achievement email: $e');
      rethrow;
    }
  }

  /// Send password reset email
  static Future<void> sendPasswordResetEmail({
    required String toEmail,
    required String resetToken,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <security@sportsassessment.app>',
        to: [toEmail],
        subject: 'Reset Your Password',
        html: _buildPasswordResetEmailHtml(resetToken),
      ));
    } catch (e) {
      print('Failed to send password reset email: $e');
      rethrow;
    }
  }

  /// Send mentor connection notification
  static Future<void> sendMentorConnectionEmail({
    required String toEmail,
    required String userName,
    required String mentorName,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <mentors@sportsassessment.app>',
        to: [toEmail],
        subject: 'You\'re Now Connected with $mentorName!',
        html: _buildMentorConnectionEmailHtml(userName, mentorName),
      ));
    } catch (e) {
      print('Failed to send mentor connection email: $e');
      rethrow;
    }
  }

  /// Send order confirmation email
  static Future<void> sendOrderConfirmationEmail({
    required String toEmail,
    required String userName,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    try {
      await client.emails.send(EmailSendRequest(
        from: 'Sports Assessment <orders@sportsassessment.app>',
        to: [toEmail],
        subject: 'Order Confirmation - Order #$orderId',
        html: _buildOrderConfirmationEmailHtml(userName, orderId, items, totalAmount),
      ));
    } catch (e) {
      print('Failed to send order confirmation email: $e');
      rethrow;
    }
  }

  // Email HTML templates
  static String _buildWelcomeEmailHtml(String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Welcome to Sports Assessment</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">Welcome to AI Sports Talent Assessment!</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Hi $userName! 👋</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          Welcome to the future of sports assessment! We're excited to help you unlock your athletic potential
          with our AI-powered analysis platform.
        </p>

        <div style="background: rgba(106, 13, 173, 0.1); padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="color: #6A0DAD; margin-top: 0;">What's Next?</h3>
          <ul style="color: #666; text-align: left;">
            <li>Complete your first fitness test</li>
            <li>Get AI-powered performance analysis</li>
            <li>Connect with expert mentors</li>
            <li>Earn credits and unlock achievements</li>
          </ul>
        </div>

        <a href="#" style="background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; display: inline-block; margin-top: 20px;">
          Start Your First Test
        </a>
      </div>

      <div style="text-align: center; color: #999; font-size: 14px;">
        <p>Need help? Contact our support team at support@sportsassessment.app</p>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildTestCompletionEmailHtml(String userName, String testName, double score) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Test Results Ready</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #00FFB2 0%, #007BFF 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">Your Results Are Ready! 🎯</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Hi $userName!</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          Your <strong>$testName</strong> test has been analyzed by our AI system.
        </p>

        <div style="background: rgba(0, 255, 178, 0.1); padding: 30px; border-radius: 12px; text-align: center; margin: 20px 0;">
          <h3 style="color: #00FFB2; margin: 0; font-size: 48px;">${score.toStringAsFixed(1)}</h3>
          <p style="color: #666; margin: 10px 0 0 0; font-size: 18px;">Performance Score</p>
        </div>

        <a href="#" style="background: linear-gradient(135deg, #00FFB2 0%, #007BFF 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; display: inline-block; margin-top: 20px;">
          View Detailed Analysis
        </a>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildWeeklyProgressEmailHtml(String userName, Map<String, dynamic> progressData) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Weekly Progress Report</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #FF7A00 0%, #6A0DAD 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">Weekly Progress Report 📊</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Hi $userName!</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          Here's your athletic progress summary for this week:
        </p>

        <div style="background: rgba(255, 122, 0, 0.1); padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="color: #FF7A00; margin-top: 0;">Key Metrics</h3>
          <ul style="color: #666;">
            <li>Tests Completed: ${progressData['testsCompleted'] ?? 0}</li>
            <li>Average Score: ${progressData['averageScore'] ?? 0}%</li>
            <li>Improvement: ${progressData['improvement'] ?? 0}%</li>
          </ul>
        </div>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildAchievementEmailHtml(String userName, String achievementName, String description) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Achievement Unlocked</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #FFD700 0%, #FF7A00 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">🏆 Achievement Unlocked!</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px; text-align: center;">
        <h2 style="color: #333; margin-top: 0;">Congratulations $userName!</h2>
        <div style="font-size: 48px; margin: 20px 0;">🎉</div>
        <h3 style="color: #FFD700; margin: 0;">$achievementName</h3>
        <p style="color: #666; margin: 10px 0;">$description</p>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildPasswordResetEmailHtml(String resetToken) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Reset Your Password</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #FF3B3B 0%, #6A0DAD 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">Password Reset</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Reset Your Password</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          We received a request to reset your password. Click the button below to create a new password:
        </p>

        <a href="#" style="background: linear-gradient(135deg, #FF3B3B 0%, #6A0DAD 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; display: inline-block; margin: 20px 0;">
          Reset Password
        </a>

        <p style="color: #999; font-size: 14px; margin-top: 20px;">
          If you didn't request this reset, please ignore this email.
        </p>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildMentorConnectionEmailHtml(String userName, String mentorName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Mentor Connection</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #6A0DAD 0%, #00FFB2 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">New Mentor Connection! 🤝</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Hi $userName!</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          Great news! You've been connected with <strong>$mentorName</strong>, one of our expert sports mentors.
        </p>

        <div style="background: rgba(106, 13, 173, 0.1); padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="color: #6A0DAD; margin-top: 0;">What happens next?</h3>
          <ul style="color: #666; text-align: left;">
            <li>$mentorName will review your recent test results</li>
            <li>You'll receive personalized training recommendations</li>
            <li>Schedule a video call to discuss your goals</li>
          </ul>
        </div>

        <a href="#" style="background: linear-gradient(135deg, #6A0DAD 0%, #00FFB2 100%); color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; display: inline-block; margin-top: 20px;">
          Message Your Mentor
        </a>
      </div>
    </body>
    </html>
    ''';
  }

  static String _buildOrderConfirmationEmailHtml(String userName, String orderId, List<Map<String, dynamic>> items, double totalAmount) {
    final itemsHtml = items.map((item) => '''
      <tr>
        <td style="padding: 10px; border-bottom: 1px solid #eee;">${item['name']}</td>
        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: center;">${item['quantity']}</td>
        <td style="padding: 10px; border-bottom: 1px solid #eee; text-align: right;">₹${item['price']}</td>
      </tr>
    ''').join();

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Order Confirmation</title>
    </head>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #007BFF 0%, #00FFB2 100%); padding: 40px; border-radius: 12px; text-align: center; margin-bottom: 30px;">
        <h1 style="color: white; margin: 0; font-size: 28px;">Order Confirmed! 🎉</h1>
      </div>

      <div style="background: #f8f9fa; padding: 30px; border-radius: 12px; margin-bottom: 20px;">
        <h2 style="color: #333; margin-top: 0;">Hi $userName!</h2>
        <p style="color: #666; line-height: 1.6; font-size: 16px;">
          Thank you for your order! Your order <strong>#$orderId</strong> has been confirmed and is being processed.
        </p>

        <div style="background: white; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="color: #333; margin-top: 0;">Order Details</h3>
          <table style="width: 100%; border-collapse: collapse;">
            <thead>
              <tr style="background: #f0f0f0;">
                <th style="padding: 10px; text-align: left; border-bottom: 2px solid #ddd;">Item</th>
                <th style="padding: 10px; text-align: center; border-bottom: 2px solid #ddd;">Qty</th>
                <th style="padding: 10px; text-align: right; border-bottom: 2px solid #ddd;">Price</th>
              </tr>
            </thead>
            <tbody>
              $itemsHtml
            </tbody>
            <tfoot>
              <tr style="background: #f0f0f0; font-weight: bold;">
                <td colspan="2" style="padding: 15px; text-align: right;">Total:</td>
                <td style="padding: 15px; text-align: right;">₹${totalAmount.toStringAsFixed(2)}</td>
              </tr>
            </tfoot>
          </table>
        </div>

        <p style="color: #666; font-size: 14px;">
          You'll receive another email when your order ships. Track your order status in the app.
        </p>
      </div>
    </body>
    </html>
    ''';
  }
}

/// Riverpod provider for RESEND service
final resendServiceProvider = Provider<ResendService>((ref) {
  return ResendService();
});

/// RESEND client provider
final resendClientProvider = Provider<Resend>((ref) {
  return ResendService.client;
});
