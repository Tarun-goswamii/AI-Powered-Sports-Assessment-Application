import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'resend_service_real.dart';
import '../models/simple_user_model.dart';
import '../models/test_result_model.dart';

/// Email Workflow Manager for handling different types of email communications
class EmailWorkflows {
  final ResendService _resendService;

  EmailWorkflows(this._resendService);

  /// USER ONBOARDING FLOWS
  /// ======================

  /// Send welcome email series for new users
  Future<void> sendWelcomeSeries(SimpleUserModel user) async {
    try {
      // Immediate welcome email
      await _resendService.sendWelcomeEmail(
        toEmail: user.email,
        userName: user.name,
      );

      // Schedule follow-up emails (would be handled by a job scheduler in production)
      // For now, just log the intent
      print('📧 Scheduled: Getting Started Guide (24h) for ${user.email}');
      print('📧 Scheduled: Feature Introduction (72h) for ${user.email}');
      print('📧 Scheduled: First Test Reminder (1 week) for ${user.email}');
    } catch (e) {
      print('Failed to send welcome series: $e');
      rethrow;
    }
  }

  /// Send getting started guide
  Future<void> sendGettingStartedGuide(String email, String userName) async {
    const subject = 'Your Complete Getting Started Guide 🗺️';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Getting Started Guide</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #4F46E5; text-align: center;">Your Complete Getting Started Guide</h1>
        <p>Hi $userName,</p>
        <p>Welcome to your journey of athletic excellence! Here's your step-by-step guide to get the most out of Sports Assessment.</p>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">🚀 Quick Start Steps:</h3>
          <ol style="padding-left: 20px;">
            <li><strong>Complete Your Profile:</strong> Add your body measurements for personalized insights</li>
            <li><strong>Take Your First Test:</strong> Start with the Basic Fitness Assessment</li>
            <li><strong>Connect with Mentors:</strong> Get expert guidance for your goals</li>
            <li><strong>Join Challenges:</strong> Compete with athletes worldwide</li>
            <li><strong>Track Progress:</strong> Monitor your improvement over time</li>
          </ol>
        </div>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #059669;">
          <h3 style="margin-top: 0; color: #065F46;">💡 Pro Tips:</h3>
          <ul style="padding-left: 20px;">
            <li>Take tests in a quiet environment for best results</li>
            <li>Complete body logs regularly for accurate progress tracking</li>
            <li>Check your email for weekly progress reports</li>
            <li>Engage with the community for motivation and support</li>
          </ul>
        </div>

        <p>Ready to begin your transformation? Let's start with your first assessment!</p>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/tests"
             style="background-color: #4F46E5; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Take Your First Test
          </a>
        </div>

        <p>Need help? Contact our support team anytime.</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// Send feature introduction email
  Future<void> sendFeatureIntroduction(String email, String userName) async {
    const subject = 'Discover All Features - Your Sports Assessment Toolkit 🛠️';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Feature Introduction</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #7C3AED; text-align: center;">Your Complete Sports Assessment Toolkit</h1>
        <p>Hi $userName,</p>
        <p>Now that you're familiar with the basics, let's explore all the powerful features available to you:</p>

        <div style="display: flex; flex-wrap: wrap; gap: 20px; margin: 20px 0;">
          <div style="flex: 1; min-width: 250px; background-color: #F3F4F6; padding: 15px; border-radius: 8px;">
            <h4 style="margin-top: 0; color: #1F2937;">🏃‍♂️ Test Library</h4>
            <p>Access 20+ specialized tests for speed, strength, agility, and endurance assessment.</p>
          </div>

          <div style="flex: 1; min-width: 250px; background-color: #F3F4F6; padding: 15px; border-radius: 8px;">
            <h4 style="margin-top: 0; color: #1F2937;">📊 Progress Analytics</h4>
            <p>Detailed charts and insights showing your improvement over time.</p>
          </div>

          <div style="flex: 1; min-width: 250px; background-color: #F3F4F6; padding: 15px; border-radius: 8px;">
            <h4 style="margin-top: 0; color: #1F2937;">🎯 Personalized Plans</h4>
            <p>AI-generated training and nutrition plans based on your results.</p>
          </div>

          <div style="flex: 1; min-width: 250px; background-color: #F3F4F6; padding: 15px; border-radius: 8px;">
            <h4 style="margin-top: 0; color: #1F2937;">👥 Community</h4>
            <p>Connect with athletes, share achievements, and join challenges.</p>
          </div>
        </div>

        <div style="background-color: #FEF3C7; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #92400E;">🎁 Special Offer for New Users</h3>
          <p>Get <strong>50 bonus credits</strong> when you complete your first 3 tests this week!</p>
          <p style="margin-bottom: 0;">Use credits to unlock premium features and mentor sessions.</p>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/features"
             style="background-color: #7C3AED; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Explore All Features
          </a>
        </div>

        <p>Questions? We're here to help!</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// TEST RESULT NOTIFICATIONS
  /// =========================

  /// Send test completion notification with detailed results
  Future<void> sendTestCompletionNotification(TestResultModel result, SimpleUserModel user) async {
    final subject = 'Test Results: ${result.testName} - ${result.score.toStringAsFixed(1)} Points 🏆';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Test Results</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #059669; text-align: center;">Test Completed Successfully!</h1>
        <p>Hi ${user.name},</p>
        <p>Congratulations on completing the <strong>${result.testName}</strong> assessment!</p>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; border: 2px solid #059669;">
          <h2 style="margin-top: 0; color: #065F46; font-size: 48px;">${result.score.toStringAsFixed(1)}</h2>
          <p style="margin-bottom: 0; color: #047857; font-size: 18px;">Your Score</p>
          <p style="margin-bottom: 0; color: #065F46;">Completed on ${result.completedAt.toString().split(' ')[0]}</p>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">📈 Performance Analysis:</h3>
          <div style="display: flex; justify-content: space-between; margin: 10px 0;">
            <span>Strengths:</span>
            <span style="color: #059669; font-weight: bold;">${result.strengths?.join(', ') ?? 'N/A'}</span>
          </div>
          <div style="display: flex; justify-content: space-between; margin: 10px 0;">
            <span>Areas for Improvement:</span>
            <span style="color: #DC2626; font-weight: bold;">${result.weaknesses?.join(', ') ?? 'N/A'}</span>
          </div>
          <div style="display: flex; justify-content: space-between; margin: 10px 0;">
            <span>Credits Earned:</span>
            <span style="color: #7C3AED; font-weight: bold;">${result.creditsEarned ?? 0}</span>
          </div>
        </div>

        <div style="background-color: #FEF3C7; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #92400E;">🎯 Recommendations:</h3>
          <ul style="padding-left: 20px;">
            ${result.recommendations?.map((rec) => '<li>$rec</li>').join('') ?? '<li>Keep up the great work!</li>'}
          </ul>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/results/${result.id}"
             style="background-color: #059669; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold; margin-right: 10px;">
            View Detailed Results
          </a>
          <a href="https://sportsassessment.com/app/tests"
             style="background-color: #4F46E5; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Take Another Test
          </a>
        </div>

        <p>Your results have been saved to your profile. Keep pushing your limits!</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: user.email, subject: subject, html: html);
  }

  /// ACHIEVEMENT CELEBRATIONS
  /// ========================

  /// Send achievement unlocked celebration
  Future<void> sendAchievementCelebration(String email, String userName, Map<String, dynamic> achievement) async {
    final subject = '🎉 Achievement Unlocked: ${achievement['name']}';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Achievement Unlocked</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #D97706; text-align: center;">🎉 Achievement Unlocked!</h1>
        <p>Hi $userName,</p>
        <p><strong>Congratulations!</strong> You've unlocked a new achievement:</p>

        <div style="background: linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%); padding: 30px; border-radius: 12px; margin: 20px 0; text-align: center; border: 3px solid #D97706;">
          <div style="font-size: 64px; margin-bottom: 10px;">🏆</div>
          <h2 style="margin-top: 0; color: #92400E; font-size: 32px;">${achievement['name']}</h2>
          <p style="margin-bottom: 0; color: #78350F; font-size: 18px; font-style: italic;">${achievement['description']}</p>
          <div style="background-color: #92400E; color: white; padding: 8px 16px; border-radius: 20px; display: inline-block; margin-top: 15px; font-weight: bold;">
            ${achievement['rarity'] ?? 'Common'} Achievement
          </div>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">🏅 Achievement Details:</h3>
          <ul style="padding-left: 20px;">
            <li><strong>Unlocked:</strong> ${DateTime.now().toString().split(' ')[0]}</li>
            <li><strong>Reward:</strong> ${achievement['reward'] ?? 'Special Badge'}</li>
            <li><strong>Progress:</strong> ${achievement['progress'] ?? '100%'}</li>
          </ul>
        </div>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #059669;">
          <h3 style="margin-top: 0; color: #065F46;">🎯 Keep Going!</h3>
          <p>You're making amazing progress! Here are some achievements you can unlock next:</p>
          <ul style="padding-left: 20px;">
            <li>Complete 5 different tests</li>
            <li>Score above 90 in any test</li>
            <li>Maintain a 7-day streak</li>
            <li>Share results with friends</li>
          </ul>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/achievements"
             style="background-color: #D97706; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            View All Achievements
          </a>
        </div>

        <p>Amazing work! Keep pushing your athletic boundaries! 💪</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// MARKETING CAMPAIGNS
  /// ===================

  /// Send weekly newsletter with tips and updates
  Future<void> sendWeeklyNewsletter(String email, String userName, Map<String, dynamic> content) async {
    const subject = 'Weekly Sports Insights & Training Tips 💪';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Weekly Newsletter</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #4F46E5; text-align: center;">Weekly Sports Insights</h1>
        <p>Hi $userName,</p>
        <p>Here's your weekly dose of sports science, training tips, and community highlights!</p>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">🏃‍♂️ Featured Training Tip:</h3>
          <h4>${content['tipTitle'] ?? 'Dynamic Warm-ups for Better Performance'}</h4>
          <p>${content['tipContent'] ?? 'Research shows that dynamic warm-ups can improve performance by up to 15%. Try incorporating arm circles, leg swings, and torso twists into your routine.'}</p>
        </div>

        <div style="background-color: #FEF3C7; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #92400E;">🏆 Community Spotlight:</h3>
          <p>Congratulations to this week's top performers!</p>
          <ul style="padding-left: 20px;">
            <li><strong>Most Improved:</strong> Rahul Sharma (+12 points)</li>
            <li><strong>Highest Score:</strong> Priya Patel (95.5 points)</li>
            <li><strong>Longest Streak:</strong> Amit Kumar (14 days)</li>
          </ul>
        </div>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #065F46;">📈 This Week's Challenge:</h3>
          <p><strong>${content['challengeTitle'] ?? 'Speed Endurance Challenge'}</strong></p>
          <p>${content['challengeDescription'] ?? 'Complete 3 sprint tests this week and track your improvement. Winner gets 100 bonus credits!'}</p>
          <div style="text-align: center; margin-top: 15px;">
            <a href="https://sportsassessment.com/app/challenges"
               style="background-color: #059669; color: white; padding: 10px 20px;
                      text-decoration: none; border-radius: 6px; font-weight: bold;">
              Join Challenge
            </a>
          </div>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app"
             style="background-color: #4F46E5; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Open App
          </a>
        </div>

        <p>Stay consistent, stay strong! 💪</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
        <p style="font-size: 12px; color: #6B7280; text-align: center;">
          Want to unsubscribe? <a href="#" style="color: #6B7280;">Click here</a>
        </p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// Send promotional campaign email
  Future<void> sendPromotionalCampaign(String email, String userName, Map<String, dynamic> campaign) async {
    final subject = campaign['subject'] ?? '🎁 Special Offer: Limited Time Deal!';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Special Offer</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #DC2626; text-align: center;">🎁 Special Offer!</h1>
        <p>Hi $userName,</p>
        <p>We have an exclusive offer just for you!</p>

        <div style="background: linear-gradient(135deg, #FEE2E2 0%, #FECACA 100%); padding: 30px; border-radius: 12px; margin: 20px 0; text-align: center; border: 3px solid #DC2626;">
          <div style="font-size: 48px; margin-bottom: 10px;">${campaign['emoji'] ?? '🔥'}</div>
          <h2 style="margin-top: 0; color: #991B1B; font-size: 28px;">${campaign['title'] ?? 'Flash Sale!'}</h2>
          <p style="margin-bottom: 0; color: #7F1D1D; font-size: 18px;">${campaign['description'] ?? 'Get 50% off premium features for a limited time!'}</p>
          <div style="background-color: #DC2626; color: white; padding: 15px 30px; border-radius: 25px; display: inline-block; margin-top: 20px; font-weight: bold; font-size: 18px;">
            ${campaign['discount'] ?? '50% OFF'}
          </div>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">⏰ Limited Time Offer:</h3>
          <ul style="padding-left: 20px;">
            <li><strong>Valid until:</strong> ${campaign['expiry'] ?? 'End of this week'}</li>
            <li><strong>Code:</strong> ${campaign['code'] ?? 'FLASH50'}</li>
            <li><strong>Minimum purchase:</strong> ${campaign['minPurchase'] ?? 'Required'}</li>
          </ul>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/app/store?promo=${campaign['code'] ?? 'FLASH50'}"
             style="background-color: #DC2626; color: white; padding: 15px 30px;
                    text-decoration: none; border-radius: 8px; font-weight: bold; font-size: 16px;">
            Claim Your Discount
          </a>
        </div>

        <p style="font-size: 14px; color: #6B7280; text-align: center;">
          *Terms and conditions apply. Offer valid for new purchases only.
        </p>

        <p>Don't miss out on this amazing deal! ⏰</p>

        <p>Best regards,<br>The Sports Assessment Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// CUSTOMER SUPPORT COMMUNICATIONS
  /// ===============================

  /// Send support ticket confirmation
  Future<void> sendSupportTicketConfirmation(String email, String userName, String ticketId, String issue) async {
    final subject = 'Support Ticket Created: $ticketId 🎫';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Support Ticket Created</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #2563EB; text-align: center;">Support Ticket Created</h1>
        <p>Hi $userName,</p>
        <p>Thank you for contacting Sports Assessment support. We've received your request and created a support ticket.</p>

        <div style="background-color: #EFF6FF; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #2563EB;">
          <h3 style="margin-top: 0; color: #1E40AF;">Ticket Details:</h3>
          <p><strong>Ticket ID:</strong> $ticketId</p>
          <p><strong>Issue:</strong> $issue</p>
          <p><strong>Status:</strong> <span style="color: #059669; font-weight: bold;">Open</span></p>
          <p><strong>Created:</strong> ${DateTime.now().toString().split(' ')[0]}</p>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">What happens next?</h3>
          <ol style="padding-left: 20px;">
            <li>Our support team will review your ticket within 24 hours</li>
            <li>You'll receive an email when we respond</li>
            <li>You can add updates to this ticket anytime</li>
            <li>We'll keep you updated on the resolution progress</li>
          </ol>
        </div>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #065F46;">💡 Quick Solutions:</h3>
          <p>While waiting for our response, you might find these helpful:</p>
          <ul style="padding-left: 20px;">
            <li>Check our <a href="https://sportsassessment.com/help" style="color: #059669;">Help Center</a> for common questions</li>
            <li>Watch our <a href="https://sportsassessment.com/tutorials" style="color: #059669;">video tutorials</a></li>
            <li>Visit our <a href="https://sportsassessment.com/community" style="color: #059669;">Community Forum</a></li>
          </ul>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/support/ticket/$ticketId"
             style="background-color: #2563EB; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            View Ticket
          </a>
        </div>

        <p>If you have additional information or urgent concerns, please reply to this email.</p>

        <p>Thank you for your patience!</p>

        <p>Best regards,<br>The Sports Assessment Support Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// Send support response notification
  Future<void> sendSupportResponse(String email, String userName, String ticketId, String response) async {
    final subject = 'Support Update: Ticket $ticketId 📝';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Support Response</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #059669; text-align: center;">Support Response Received</h1>
        <p>Hi $userName,</p>
        <p>We've responded to your support ticket. Here's our latest update:</p>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #059669;">
          <h3 style="margin-top: 0; color: #065F46;">Response from Support Team:</h3>
          <div style="background-color: white; padding: 15px; border-radius: 6px; margin: 10px 0;">
            $response
          </div>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">Ticket Information:</h3>
          <p><strong>Ticket ID:</strong> $ticketId</p>
          <p><strong>Status:</strong> <span style="color: #059669; font-weight: bold;">In Progress</span></p>
          <p><strong>Last Updated:</strong> ${DateTime.now().toString().split(' ')[0]}</p>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/support/ticket/$ticketId"
             style="background-color: #059669; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold; margin-right: 10px;">
            Reply to Ticket
          </a>
          <a href="https://sportsassessment.com/support"
             style="background-color: #6B7280; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Contact Support
          </a>
        </div>

        <p>If this resolves your issue, please let us know by updating the ticket status.</p>

        <p>Best regards,<br>The Sports Assessment Support Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }

  /// Send ticket resolution notification
  Future<void> sendTicketResolution(String email, String userName, String ticketId, String resolution) async {
    final subject = 'Ticket Resolved: $ticketId ✅';
    final html = '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>Ticket Resolved</title>
    </head>
    <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
      <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h1 style="color: #059669; text-align: center;">🎉 Ticket Resolved!</h1>
        <p>Hi $userName,</p>
        <p>Great news! Your support ticket has been successfully resolved.</p>

        <div style="background-color: #ECFDF5; padding: 20px; border-radius: 8px; margin: 20px 0; border-left: 4px solid #059669;">
          <h3 style="margin-top: 0; color: #065F46;">Final Resolution:</h3>
          <div style="background-color: white; padding: 15px; border-radius: 6px; margin: 10px 0;">
            $resolution
          </div>
        </div>

        <div style="background-color: #F3F4F6; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #1F2937;">Ticket Summary:</h3>
          <p><strong>Ticket ID:</strong> $ticketId</p>
          <p><strong>Status:</strong> <span style="color: #059669; font-weight: bold;">Resolved</span></p>
          <p><strong>Resolved on:</strong> ${DateTime.now().toString().split(' ')[0]}</p>
        </div>

        <div style="background-color: #FEF3C7; padding: 20px; border-radius: 8px; margin: 20px 0;">
          <h3 style="margin-top: 0; color: #92400E;">📝 How was our support?</h3>
          <p>Help us improve by rating your experience:</p>
          <div style="text-align: center; margin: 15px 0;">
            <a href="https://sportsassessment.com/feedback?ticket=$ticketId&rating=5" style="color: #D97706; text-decoration: none; margin: 0 5px;">⭐</a>
            <a href="https://sportsassessment.com/feedback?ticket=$ticketId&rating=4" style="color: #D97706; text-decoration: none; margin: 0 5px;">⭐</a>
            <a href="https://sportsassessment.com/feedback?ticket=$ticketId&rating=3" style="color: #D97706; text-decoration: none; margin: 0 5px;">⭐</a>
            <a href="https://sportsassessment.com/feedback?ticket=$ticketId&rating=2" style="color: #D97706; text-decoration: none; margin: 0 5px;">⭐</a>
            <a href="https://sportsassessment.com/feedback?ticket=$ticketId&rating=1" style="color: #D97706; text-decoration: none; margin: 0 5px;">⭐</a>
          </div>
        </div>

        <div style="text-align: center; margin: 30px 0;">
          <a href="https://sportsassessment.com/support"
             style="background-color: #059669; color: white; padding: 12px 24px;
                    text-decoration: none; border-radius: 6px; font-weight: bold;">
            Contact Support Again
          </a>
        </div>

        <p>Thank you for choosing Sports Assessment. We hope to see you back soon!</p>

        <p>Best regards,<br>The Sports Assessment Support Team</p>
      </div>
    </body>
    </html>
    ''';

    await _resendService._sendEmail(to: email, subject: subject, html: html);
  }
}

/// Riverpod provider for Email Workflows
final emailWorkflowsProvider = Provider<EmailWorkflows>((ref) {
  final resendService = ref.watch(resendServiceProvider);
  return EmailWorkflows(resendService);
});
