// lib/core/services/integrated_service_manager.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'convex_http_service.dart';
import 'resend_email_service.dart';
import 'ml_model_service.dart';
import '../models/test_result_model.dart';
import '../models/simple_user_model.dart';
import '../models/achievement_model.dart';

class IntegratedServiceManager {
  final ConvexHttpService _convexService;
  final ResendEmailService _emailService;
  final MLModelService _mlService;

  IntegratedServiceManager({
    required ConvexHttpService convexService,
    required ResendEmailService emailService,
    required MLModelService mlService,
  })  : _convexService = convexService,
        _emailService = emailService,
        _mlService = mlService;

  // Expose services for provider access
  ConvexHttpService get convexService => _convexService;
  ResendEmailService get emailService => _emailService;
  MLModelService get mlService => _mlService;

  // Initialize all services
  Future<bool> initializeServices() async {
    try {
      // Initialize ML models
      await _mlService.initializeModels();
      
      print('All services initialized successfully');
      return true;
    } catch (e) {
      print('Error initializing services: $e');
      return false;
    }
  }

  // Complete test submission workflow with ML analysis and email notifications
  Future<TestResultModel?> submitCompleteTestResult({
    required String userId,
    required String testId,
    required String videoPath,
    required Duration videoDuration,
    required String userEmail,
    required String userName,
  }) async {
    try {
      // Step 1: Analyze video with ML models
      print('Analyzing video with ML models...');
      final mlAnalysis = await _mlService.analyzeTestVideo(
        videoPath: videoPath,
        testType: testId,
        videoDuration: videoDuration,
      );

      // Step 2: Calculate final score based on ML analysis
      final finalScore = _calculateFinalScore(mlAnalysis, testId);

      // Step 3: Submit result to Convex backend
      print('Submitting result to backend...');
      final resultId = await _convexService.submitTestResult(
        userId: userId,
        testId: testId,
        score: finalScore,
        mlAnalysis: mlAnalysis.toJson(),
        videoUrl: videoPath, // In production, this would be uploaded to cloud storage
      );

      if (resultId == null) {
        throw Exception('Failed to submit test result');
      }

      // Step 4: Get updated leaderboard position
      final leaderboard = await _convexService.getLeaderboard(limit: 1000);
      final userRank = _findUserRankInLeaderboard(leaderboard, userId);

      // Step 5: Check for new achievements
      await _checkAndUnlockAchievements(userId, testId, finalScore, mlAnalysis);

      // Step 6: Send email notification
      print('Sending email notification...');
      await _emailService.sendTestCompletionEmail(
        userEmail: userEmail,
        userName: userName,
        testName: _getTestDisplayName(testId),
        score: finalScore,
        rank: userRank,
        analysis: mlAnalysis.toJson(),
      );

      // Step 7: Award credits for test completion
      await _awardTestCompletionCredits(userId, testId, finalScore, mlAnalysis);

      // Step 8: Create TestResultModel object to return
      final testResult = TestResultModel(
        id: resultId,
        userId: userId,
        testId: testId,
        status: TestResultStatus.completed,
        rawData: mlAnalysis.toJson(),
        processedData: {'finalScore': finalScore},
        score: finalScore,
        recommendations: mlAnalysis.recommendations,
        startedAt: DateTime.now().subtract(videoDuration),
        completedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('Test submission completed successfully');
      return testResult;
    } catch (e) {
      print('Error in complete test submission: $e');
      return null;
    }
  }

  // Calculate final score based on ML analysis and test type
  double _calculateFinalScore(MLAnalysisResult mlAnalysis, String testId) {
    double baseScore = 0.0;

    switch (testId.toLowerCase()) {
      case 'sit-ups':
        baseScore = mlAnalysis.repetitions * 2.0; // Base: 2 points per rep
        break;
      case 'push-ups':
        baseScore = mlAnalysis.repetitions * 2.5; // Base: 2.5 points per rep
        break;
      case 'squats':
        baseScore = mlAnalysis.repetitions * 2.0; // Base: 2 points per rep
        break;
      case 'vertical-jump':
        final jumpHeight = mlAnalysis.keyPoints['jump_height'] ?? 0.0;
        baseScore = jumpHeight * 1.5; // Base: 1.5 points per cm
        break;
      case 'shuttle-run':
        baseScore = mlAnalysis.repetitions * 5.0; // Base: 5 points per lap
        break;
      default:
        baseScore = 50.0; // Default base score
    }

    // Apply form score multiplier
    final formMultiplier = mlAnalysis.formScore / 100.0;
    final formAdjustedScore = baseScore * formMultiplier;

    // Apply pose accuracy bonus
    final poseBonus = mlAnalysis.poseAccuracy > 80 ? formAdjustedScore * 0.1 : 0.0;

    // Apply cheat detection penalty
    final cheatPenalty = mlAnalysis.cheatDetected ? formAdjustedScore * 0.2 : 0.0;

    final finalScore = formAdjustedScore + poseBonus - cheatPenalty;
    return finalScore.clamp(0.0, 1000.0); // Cap at 1000 points
  }

  // Find user's rank in leaderboard
  int _findUserRankInLeaderboard(List<Map<String, dynamic>> leaderboard, String userId) {
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i]['userId'] == userId) {
        return i + 1;
      }
    }
    return leaderboard.length + 1; // User not found, place at end
  }

  // Check and unlock achievements
  Future<void> _checkAndUnlockAchievements(
    String userId,
    String testId,
    double score,
    MLAnalysisResult mlAnalysis,
  ) async {
    try {
      final userResults = await _convexService.getUserTestResults(userId);
      final user = await _convexService.getUserByEmail(''); // Would need email lookup

      // Check various achievement conditions
      final achievements = <String>[];

      // First test completion
      if (userResults.length == 1) {
        achievements.add('first_test');
      }

      // High score achievements
      if (score >= 100) {
        achievements.add('century_score');
      }
      if (score >= 200) {
        achievements.add('double_century');
      }

      // Perfect form achievement
      if (mlAnalysis.formScore >= 95 && !mlAnalysis.cheatDetected) {
        achievements.add('perfect_form');
      }

      // Test-specific achievements
      switch (testId.toLowerCase()) {
        case 'sit-ups':
          if (mlAnalysis.repetitions >= 50) {
            achievements.add('sit_up_master');
          }
          break;
        case 'push-ups':
          if (mlAnalysis.repetitions >= 30) {
            achievements.add('push_up_champion');
          }
          break;
        case 'vertical-jump':
          final jumpHeight = mlAnalysis.keyPoints['jump_height'] ?? 0.0;
          if (jumpHeight >= 60) {
            achievements.add('high_jumper');
          }
          break;
      }

      // Unlock achievements
      for (final achievementId in achievements) {
        await _convexService.unlockAchievement(userId, achievementId);
        
        // Send achievement email if user exists
        if (user != null) {
          await _emailService.sendAchievementEmail(
            userEmail: user.email,
            userName: user.name,
            achievementName: _getAchievementName(achievementId),
            achievementDescription: _getAchievementDescription(achievementId),
            creditsEarned: _getAchievementCredits(achievementId),
          );
        }
      }
    } catch (e) {
      print('Error checking achievements: $e');
    }
  }

  // Award credits for test completion
  Future<void> _awardTestCompletionCredits(
    String userId,
    String testId,
    double score,
    MLAnalysisResult mlAnalysis,
  ) async {
    try {
      int baseCredits = 50; // Base credits for test completion
      int bonusCredits = 0;

      // Performance bonuses
      if (score >= 100) bonusCredits += 25;
      if (score >= 200) bonusCredits += 50;
      if (mlAnalysis.formScore >= 90) bonusCredits += 20;
      if (!mlAnalysis.cheatDetected) bonusCredits += 10;

      final totalCredits = baseCredits + bonusCredits;

      // Create credit transaction
      await _convexService.createCreditTransaction(
        userId: userId,
        amount: totalCredits,
        type: 'test_completion',
        description: 'Completed ${_getTestDisplayName(testId)} - Score: ${score.toStringAsFixed(1)}',
      );

      // Update user's total credits
      final user = await _convexService.getUserByEmail(''); // Would need proper lookup
      if (user != null) {
        await _convexService.updateUserCredits(userId, user.credits + totalCredits);
      }
    } catch (e) {
      print('Error awarding credits: $e');
    }
  }

  // User registration with welcome email
  Future<SimpleUserModel?> registerUserWithWelcome({
    required String email,
    required String name,
  }) async {
    try {
      // Create user in Convex
      final user = await _convexService.createUser(email: email, name: name);
      
      if (user != null) {
        // Send welcome email
        await _emailService.sendWelcomeEmail(
          userEmail: email,
          userName: name,
        );

        // Award welcome bonus credits
        await _convexService.createCreditTransaction(
          userId: user.id,
          amount: 1000,
          type: 'welcome_bonus',
          description: 'Welcome bonus for new user registration',
        );

        return user;
      }
      return null;
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }

  // Book mentor session with confirmation email
  Future<bool> bookMentorSessionWithEmail({
    required String mentorId,
    required String userId,
    required String userEmail,
    required String userName,
    required String mentorName,
    required String topic,
    required DateTime scheduledAt,
    required String type,
  }) async {
    try {
      // Book session in Convex
      final sessionId = await _convexService.bookMentorSession(
        mentorId: mentorId,
        userId: userId,
        topic: topic,
        scheduledAt: scheduledAt,
        type: type,
      );

      if (sessionId != null) {
        // Send confirmation email
        await _emailService.sendMentorSessionEmail(
          userEmail: userEmail,
          userName: userName,
          mentorName: mentorName,
          sessionTime: scheduledAt,
          sessionType: type,
          meetingLink: 'https://sportsassessment.app/mentor-session/$sessionId',
        );

        return true;
      }
      return false;
    } catch (e) {
      print('Error booking mentor session: $e');
      return false;
    }
  }

  // Create community post with notifications
  Future<String?> createCommunityPostWithNotifications({
    required String userId,
    required String content,
    String? type,
    String? imageUrl,
  }) async {
    try {
      // Create post in Convex
      final postId = await _convexService.createCommunityPost(
        userId: userId,
        content: content,
        type: type,
        imageUrl: imageUrl,
      );

      if (postId != null) {
        // TODO: Send notifications to followers/community members
        // This would involve getting user's followers and sending targeted notifications
        
        return postId;
      }
      return null;
    } catch (e) {
      print('Error creating community post: $e');
      return null;
    }
  }

  // Send weekly progress reports
  Future<void> sendWeeklyProgressReports() async {
    try {
      // This would typically be called by a background job/cron
      // Get all users
      // For each user, calculate weekly stats
      // Send progress email
      print('Weekly progress reports feature - would be implemented with user iteration');
    } catch (e) {
      print('Error sending weekly progress reports: $e');
    }
  }

  // Real-time data streams
  Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
    return _convexService.subscribeToLeaderboard();
  }

  Stream<List<Map<String, dynamic>>> getCommunityPostsStream() {
    return _convexService.subscribeToCommunityPosts();
  }

  // Helper methods
  String _getTestDisplayName(String testId) {
    switch (testId.toLowerCase()) {
      case 'sit-ups':
        return 'Sit-ups Test';
      case 'push-ups':
        return 'Push-ups Test';
      case 'squats':
        return 'Squats Test';
      case 'vertical-jump':
        return 'Vertical Jump Test';
      case 'shuttle-run':
        return 'Shuttle Run Test';
      default:
        return 'Fitness Test';
    }
  }

  String _getAchievementName(String achievementId) {
    switch (achievementId) {
      case 'first_test':
        return 'First Steps';
      case 'century_score':
        return 'Century Club';
      case 'double_century':
        return 'Double Century';
      case 'perfect_form':
        return 'Perfect Form';
      case 'sit_up_master':
        return 'Sit-up Master';
      case 'push_up_champion':
        return 'Push-up Champion';
      case 'high_jumper':
        return 'High Jumper';
      default:
        return 'Achievement Unlocked';
    }
  }

  String _getAchievementDescription(String achievementId) {
    switch (achievementId) {
      case 'first_test':
        return 'Completed your first fitness test';
      case 'century_score':
        return 'Scored 100 points or more in a test';
      case 'double_century':
        return 'Scored 200 points or more in a test';
      case 'perfect_form':
        return 'Achieved perfect form with no violations';
      case 'sit_up_master':
        return 'Completed 50 or more sit-ups';
      case 'push_up_champion':
        return 'Completed 30 or more push-ups';
      case 'high_jumper':
        return 'Jumped 60cm or higher';
      default:
        return 'You unlocked a special achievement';
    }
  }

  int _getAchievementCredits(String achievementId) {
    switch (achievementId) {
      case 'first_test':
        return 100;
      case 'century_score':
        return 150;
      case 'double_century':
        return 300;
      case 'perfect_form':
        return 200;
      case 'sit_up_master':
        return 250;
      case 'push_up_champion':
        return 250;
      case 'high_jumper':
        return 250;
      default:
        return 100;
    }
  }

  void dispose() {
    _mlService.dispose();
  }
}

// Provider for integrated service manager
final integratedServiceManagerProvider = Provider<IntegratedServiceManager>((ref) {
  final convexService = ref.watch(convexHttpServiceProvider);
  final emailService = ref.watch(resendEmailServiceProvider);
  final mlService = ref.watch(mlModelServiceProvider);

  return IntegratedServiceManager(
    convexService: convexService,
    emailService: emailService,
    mlService: mlService,
  );
});