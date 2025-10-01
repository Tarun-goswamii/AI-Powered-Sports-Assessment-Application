// lib/core/services/resend_email_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResendEmailService {
  final Dio _dio;
  static const String baseUrl = 'https://api.resend.com';
  static const String apiKey = 'your-resend-api-key'; // Replace with actual API key
  
  ResendEmailService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }

  // Welcome email for new users
  Future<bool> sendWelcomeEmail({
    required String userEmail,
    required String userName,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <onboarding@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Welcome to Sports Assessment App! 🏆',
        'html': _getWelcomeEmailTemplate(userName),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending welcome email: $e');
      return false;
    }
  }

  // Test completion notification
  Future<bool> sendTestCompletionEmail({
    required String userEmail,
    required String userName,
    required String testName,
    required double score,
    required int rank,
    required Map<String, dynamic> analysis,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <results@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Your $testName Results are Ready! 📊',
        'html': _getTestResultsEmailTemplate(
          userName, testName, score, rank, analysis
        ),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending test completion email: $e');
      return false;
    }
  }

  // Achievement unlock notification
  Future<bool> sendAchievementEmail({
    required String userEmail,
    required String userName,
    required String achievementName,
    required String achievementDescription,
    required int creditsEarned,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <achievements@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Achievement Unlocked: $achievementName! 🏅',
        'html': _getAchievementEmailTemplate(
          userName, achievementName, achievementDescription, creditsEarned
        ),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending achievement email: $e');
      return false;
    }
  }

  // Mentor session confirmation
  Future<bool> sendMentorSessionEmail({
    required String userEmail,
    required String userName,
    required String mentorName,
    required DateTime sessionTime,
    required String sessionType,
    required String meetingLink,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <mentors@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Mentor Session Confirmed with $mentorName 👨‍🏫',
        'html': _getMentorSessionEmailTemplate(
          userName, mentorName, sessionTime, sessionType, meetingLink
        ),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending mentor session email: $e');
      return false;
    }
  }

  // Weekly progress report
  Future<bool> sendWeeklyProgressEmail({
    required String userEmail,
    required String userName,
    required Map<String, dynamic> weeklyStats,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <progress@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Your Weekly Progress Report 📈',
        'html': _getWeeklyProgressEmailTemplate(userName, weeklyStats),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending weekly progress email: $e');
      return false;
    }
  }

  // Community post notification
  Future<bool> sendCommunityNotificationEmail({
    required String userEmail,
    required String userName,
    required String notificationType,
    required Map<String, dynamic> notificationData,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <community@sportsassessment.app>',
        'to': [userEmail],
        'subject': _getCommunityEmailSubject(notificationType),
        'html': _getCommunityEmailTemplate(userName, notificationType, notificationData),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending community notification email: $e');
      return false;
    }
  }

  // Password reset email
  Future<bool> sendPasswordResetEmail({
    required String userEmail,
    required String resetToken,
  }) async {
    try {
      final response = await _dio.post('/emails', data: {
        'from': 'Sports Assessment App <security@sportsassessment.app>',
        'to': [userEmail],
        'subject': 'Reset Your Password 🔑',
        'html': _getPasswordResetEmailTemplate(resetToken),
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }

  // Email templates
  String _getWelcomeEmailTemplate(String userName) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Welcome to Sports Assessment App</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .header { text-align: center; margin-bottom: 30px; }
            .logo { width: 80px; height: 80px; margin: 0 auto 20px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 32px; }
            .title { font-size: 28px; font-weight: 700; color: #ffffff; margin: 0; }
            .subtitle { font-size: 16px; color: #B0B0B0; margin: 10px 0 0; }
            .content { margin: 30px 0; }
            .feature { display: flex; align-items: center; margin: 20px 0; padding: 20px; background: rgba(255, 255, 255, 0.03); border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.1); }
            .feature-icon { width: 40px; height: 40px; margin-right: 15px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
            .feature-purple { background: rgba(106, 13, 173, 0.2); color: #9D4EDD; }
            .feature-blue { background: rgba(0, 123, 255, 0.2); color: #4FC3F7; }
            .feature-green { background: rgba(0, 255, 178, 0.2); color: #00FFB2; }
            .cta { text-align: center; margin: 40px 0; }
            .button { display: inline-block; padding: 16px 32px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 0 20px rgba(106, 13, 173, 0.3); }
            .footer { text-align: center; margin-top: 40px; color: #888888; font-size: 14px; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <div class="logo">🏆</div>
                <h1 class="title">Welcome to Sports Assessment!</h1>
                <p class="subtitle">Hi $userName, ready to unlock your athletic potential?</p>
            </div>
            
            <div class="content">
                <p>Welcome to India's most advanced AI-powered sports talent assessment platform! Here's what you can do:</p>
                
                <div class="feature">
                    <div class="feature-icon feature-purple">📊</div>
                    <div>
                        <h3 style="margin: 0; color: #ffffff;">AI-Powered Analysis</h3>
                        <p style="margin: 5px 0 0; color: #B0B0B0;">Get detailed performance insights from our ML models</p>
                    </div>
                </div>
                
                <div class="feature">
                    <div class="feature-icon feature-blue">🏃‍♂️</div>
                    <div>
                        <h3 style="margin: 0; color: #ffffff;">Standardized Tests</h3>
                        <p style="margin: 5px 0 0; color: #B0B0B0;">Complete vertical jump, shuttle run, and endurance assessments</p>
                    </div>
                </div>
                
                <div class="feature">
                    <div class="feature-icon feature-green">👥</div>
                    <div>
                        <h3 style="margin: 0; color: #ffffff;">Community & Mentors</h3>
                        <p style="margin: 5px 0 0; color: #B0B0B0;">Connect with athletes and expert coaches across India</p>
                    </div>
                </div>
                
                <p>You've started with <strong>1000 credit points</strong> to explore all features!</p>
            </div>
            
            <div class="cta">
                <a href="https://sportsassessment.app/dashboard" class="button">Start Your First Test</a>
            </div>
            
            <div class="footer">
                <p>Questions? Reply to this email or visit our help center.</p>
                <p>Sports Assessment App Team</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getTestResultsEmailTemplate(String userName, String testName, double score, int rank, Map<String, dynamic> analysis) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Test Results Ready</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .header { text-align: center; margin-bottom: 30px; }
            .score-card { background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); border-radius: 16px; padding: 30px; text-align: center; margin: 20px 0; }
            .score { font-size: 48px; font-weight: 700; color: #ffffff; margin: 0; }
            .rank { font-size: 20px; color: #E0E0E0; margin: 10px 0 0; }
            .analysis { background: rgba(255, 255, 255, 0.03); border-radius: 12px; padding: 20px; margin: 20px 0; border: 1px solid rgba(255, 255, 255, 0.1); }
            .metric { display: flex; justify-content: space-between; align-items: center; margin: 15px 0; }
            .metric-label { color: #B0B0B0; }
            .metric-value { color: #ffffff; font-weight: 600; }
            .cta { text-align: center; margin: 40px 0; }
            .button { display: inline-block; padding: 16px 32px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 0 20px rgba(106, 13, 173, 0.3); }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>Your $testName Results</h1>
                <p>Great job, $userName! Your test analysis is ready.</p>
            </div>
            
            <div class="score-card">
                <div class="score">${score.toStringAsFixed(1)}</div>
                <div class="rank">Ranked #$rank globally</div>
            </div>
            
            <div class="analysis">
                <h3>Performance Analysis</h3>
                <div class="metric">
                    <span class="metric-label">Form Accuracy:</span>
                    <span class="metric-value">${(analysis['formScore'] ?? 0.0).toStringAsFixed(1)}%</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Repetitions:</span>
                    <span class="metric-value">${analysis['repetitions'] ?? 0}</span>
                </div>
                <div class="metric">
                    <span class="metric-label">Pose Accuracy:</span>
                    <span class="metric-value">${(analysis['poseAccuracy'] ?? 0.0).toStringAsFixed(1)}%</span>
                </div>
            </div>
            
            <div class="cta">
                <a href="https://sportsassessment.app/results" class="button">View Detailed Results</a>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getAchievementEmailTemplate(String userName, String achievementName, String description, int credits) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Achievement Unlocked</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .achievement { text-align: center; background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%); border-radius: 16px; padding: 40px; margin: 20px 0; color: #000000; }
            .badge { font-size: 64px; margin-bottom: 20px; }
            .achievement-name { font-size: 24px; font-weight: 700; margin: 0; }
            .credits { background: rgba(0, 255, 178, 0.2); border-radius: 12px; padding: 20px; text-align: center; margin: 20px 0; border: 1px solid rgba(0, 255, 178, 0.3); }
        </style>
    </head>
    <body>
        <div class="container">
            <h1 style="text-align: center;">Achievement Unlocked!</h1>
            
            <div class="achievement">
                <div class="badge">🏅</div>
                <div class="achievement-name">$achievementName</div>
                <p>$description</p>
            </div>
            
            <div class="credits">
                <h3 style="margin: 0; color: #00FFB2;">+$credits Credits Earned!</h3>
                <p style="margin: 5px 0 0; color: #B0B0B0;">Keep up the great work, $userName!</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getMentorSessionEmailTemplate(String userName, String mentorName, DateTime sessionTime, String sessionType, String meetingLink) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Mentor Session Confirmed</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .session-card { background: rgba(106, 13, 173, 0.2); border-radius: 16px; padding: 30px; margin: 20px 0; border: 1px solid rgba(106, 13, 173, 0.3); }
            .datetime { font-size: 24px; font-weight: 700; color: #9D4EDD; margin: 0; }
            .button { display: inline-block; padding: 16px 32px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 0 20px rgba(106, 13, 173, 0.3); }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Mentor Session Confirmed</h1>
            <p>Hi $userName, your session with $mentorName is confirmed!</p>
            
            <div class="session-card">
                <h3>Session Details</h3>
                <div class="datetime">${sessionTime.toString()}</div>
                <p>Type: $sessionType</p>
                <p>Mentor: $mentorName</p>
            </div>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="$meetingLink" class="button">Join Session</a>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getWeeklyProgressEmailTemplate(String userName, Map<String, dynamic> stats) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Weekly Progress Report</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0; }
            .stat-card { background: rgba(255, 255, 255, 0.03); border-radius: 12px; padding: 20px; text-align: center; border: 1px solid rgba(255, 255, 255, 0.1); }
            .stat-value { font-size: 32px; font-weight: 700; color: #00FFB2; margin: 0; }
            .stat-label { font-size: 14px; color: #B0B0B0; margin: 5px 0 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Your Weekly Progress</h1>
            <p>Hi $userName, here's how you performed this week:</p>
            
            <div class="stat-grid">
                <div class="stat-card">
                    <div class="stat-value">${stats['testsCompleted'] ?? 0}</div>
                    <div class="stat-label">Tests Completed</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${stats['creditsEarned'] ?? 0}</div>
                    <div class="stat-label">Credits Earned</div>
                </div>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getCommunityEmailSubject(String type) {
    switch (type) {
      case 'mention': return 'You were mentioned in a community post';
      case 'like': return 'Your post received a new like';
      case 'comment': return 'New comment on your post';
      default: return 'Community update';
    }
  }

  String _getCommunityEmailTemplate(String userName, String type, Map<String, dynamic> data) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Community Update</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .button { display: inline-block; padding: 16px 32px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 0 20px rgba(106, 13, 173, 0.3); }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Community Update</h1>
            <p>Hi $userName, you have a new community notification!</p>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="https://sportsassessment.app/community" class="button">View in App</a>
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  String _getPasswordResetEmailTemplate(String resetToken) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8">
        <title>Reset Your Password</title>
        <style>
            body { font-family: 'Inter', Arial, sans-serif; background: linear-gradient(135deg, #121212 0%, #1a1a1a 100%); color: #ffffff; margin: 0; padding: 20px; }
            .container { max-width: 600px; margin: 0 auto; background: rgba(255, 255, 255, 0.05); border-radius: 16px; padding: 40px; backdrop-filter: blur(10px); border: 1px solid rgba(255, 255, 255, 0.1); }
            .button { display: inline-block; padding: 16px 32px; background: linear-gradient(135deg, #6A0DAD 0%, #007BFF 100%); color: #ffffff; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 16px; box-shadow: 0 0 20px rgba(106, 13, 173, 0.3); }
            .warning { background: rgba(255, 193, 7, 0.2); border-radius: 12px; padding: 20px; margin: 20px 0; border: 1px solid rgba(255, 193, 7, 0.3); }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Reset Your Password</h1>
            <p>Click the button below to reset your password. This link expires in 1 hour.</p>
            
            <div style="text-align: center; margin: 30px 0;">
                <a href="https://sportsassessment.app/reset-password?token=$resetToken" class="button">Reset Password</a>
            </div>
            
            <div class="warning">
                <p><strong>Security Notice:</strong> If you didn't request this reset, please ignore this email and your password will remain unchanged.</p>
            </div>
        </div>
    </body>
    </html>
    ''';
  }
}

// Provider for Resend service
final resendEmailServiceProvider = Provider<ResendEmailService>((ref) {
  return ResendEmailService();
});