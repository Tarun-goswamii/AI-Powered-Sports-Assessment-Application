// lib/core/services/convex_http_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/test_result_model.dart';
import '../models/simple_user_model.dart';
import '../models/achievement_model.dart';
import '../models/mentor_model.dart';
import '../models/credit_transaction_model.dart';
import '../models/body_log_model.dart';

class ConvexHttpService {
  final Dio _dio;
  
  ConvexHttpService() : _dio = Dio() {
    _dio.options.baseUrl = AppConfig.convexHttpActionUrl;
    _dio.options.connectTimeout = AppConfig.apiTimeout;
    _dio.options.receiveTimeout = AppConfig.apiTimeout;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AppConfig.convexApiKey}',
    };
    
    // Add request/response interceptors for logging (only in development)
    if (!AppConfig.isProduction && AppConfig.enableLogging) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[Convex HTTP] $obj'),
      ));
    }
  }

  // User Management
  Future<SimpleUserModel?> createUser({
    required String email,
    required String name,
  }) async {
    try {
      final response = await _dio.post('/createUser', data: {
        'email': email,
        'name': name,
        'credits': 1000, // Starting credits
        'totalScore': 0,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      if (response.statusCode == 200) {
        return SimpleUserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error creating user: $e');
      return null;
    }
  }

  Future<SimpleUserModel?> getUserByEmail(String email) async {
    try {
      final response = await _dio.get('/getUserByEmail', queryParameters: {
        'email': email,
      });

      if (response.statusCode == 200 && response.data != null) {
        return SimpleUserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<bool> updateUserCredits(String userId, int credits) async {
    try {
      final response = await _dio.post('/updateUserCredits', data: {
        'userId': userId,
        'credits': credits,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating credits: $e');
      return false;
    }
  }

  // Test Results & ML Integration
  Future<List<SimpleUserModel>> getUsers() async {
    try {
      final response = await _dio.get('/getUsers');
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> usersData = response.data['users'] ?? [];
        return usersData.map((user) => SimpleUserModel.fromJson(user)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting users: $e');
      return [];
    }
  }

  Future<String?> submitTestResult({
    required String userId,
    required String testId,
    required double score,
    required Map<String, dynamic> mlAnalysis,
    required String videoUrl,
  }) async {
    try {
      final response = await _dio.post('/submitTestResultWithML', data: {
        'userId': userId,
        'testId': testId,
        'score': score,
        'mlAnalysis': {
          'cheatDetected': mlAnalysis['cheatDetected'] ?? false,
          'poseAccuracy': mlAnalysis['poseAccuracy'] ?? 0.0,
          'repetitions': mlAnalysis['repetitions'] ?? 0,
          'formScore': mlAnalysis['formScore'] ?? 0.0,
          'violations': mlAnalysis['violations'] ?? [],
          'keyPoints': mlAnalysis['keyPoints'] ?? {},
          'confidenceScore': mlAnalysis['confidenceScore'] ?? 0.0,
          'recommendations': mlAnalysis['recommendations'] ?? [],
        },
        'videoUrl': videoUrl,
        'completedAt': DateTime.now().millisecondsSinceEpoch,
      });

      if (response.statusCode == 200) {
        return response.data['id'];
      }
      return null;
    } catch (e) {
      print('Error submitting test result: $e');
      return null;
    }
  }

  Future<List<TestResultModel>> getUserTestResults(String userId) async {
    try {
      final response = await _dio.get('/getUserTestResults', queryParameters: {
        'userId': userId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data;
        return results.map((json) => TestResultModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting test results: $e');
      return [];
    }
  }

  // Leaderboard Management
  Future<bool> updateLeaderboard(String userId) async {
    try {
      final response = await _dio.post('/updateLeaderboard', data: {
        'userId': userId,
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating leaderboard: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({
    required int limit,
    String? testType,
  }) async {
    try {
      final response = await _dio.get('/getLeaderboard', queryParameters: {
        'limit': limit,
        if (testType != null) 'testType': testType,
      });

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  // Community Features
  Future<List<Map<String, dynamic>>> getCommunityPosts({int limit = 20}) async {
    try {
      final response = await _dio.get('/getCommunityPosts', queryParameters: {
        'limit': limit,
      });

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      }
      return [];
    } catch (e) {
      print('Error getting community posts: $e');
      return [];
    }
  }

  Future<String?> createCommunityPost({
    required String userId,
    required String content,
    String? type,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post('/createCommunityPost', data: {
        'userId': userId,
        'content': content,
        'type': type ?? 'general',
        'imageUrl': imageUrl,
      });

      if (response.statusCode == 200) {
        return response.data['postId'];
      }
      return null;
    } catch (e) {
      print('Error creating community post: $e');
      return null;
    }
  }

  // Mentor System
  Future<List<MentorModel>> getMentors() async {
    try {
      final response = await _dio.get('/getMentors');

      if (response.statusCode == 200 && response.data != null) {
        // Handle both array response and object with mentors key
        final List<dynamic> mentorsData = response.data is List 
          ? response.data 
          : (response.data['mentors'] as List? ?? []);
        
        print('✅ Loaded ${mentorsData.length} mentors from Convex');
        return mentorsData.map((json) => MentorModel.fromJson(json)).toList();
      }
      print('⚠️ No mentors found or invalid response');
      return [];
    } catch (e) {
      print('❌ Error getting mentors: $e');
      return [];
    }
  }

  Future<String?> bookMentorSession({
    required String mentorId,
    required String userId,
    required String topic,
    required DateTime scheduledAt,
    required String type,
  }) async {
    try {
      final response = await _dio.post('/bookMentorSession', data: {
        'mentorId': mentorId,
        'userId': userId,
        'topic': topic,
        'scheduledAt': scheduledAt.millisecondsSinceEpoch,
        'type': type,
        'status': 'upcoming',
      });

      if (response.statusCode == 200) {
        return response.data['sessionId'];
      }
      return null;
    } catch (e) {
      print('Error booking mentor session: $e');
      return null;
    }
  }

  // Achievements
  Future<List<AchievementModel>> getUserAchievements(String userId) async {
    try {
      final response = await _dio.get('/getUserAchievements', queryParameters: {
        'userId': userId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> achievements = response.data;
        return achievements.map((json) => AchievementModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting achievements: $e');
      return [];
    }
  }

  Future<bool> unlockAchievement(String userId, String achievementId) async {
    try {
      final response = await _dio.post('/unlockAchievement', data: {
        'userId': userId,
        'achievementId': achievementId,
      });

      return response.statusCode == 200;
    } catch (e) {
      print('Error unlocking achievement: $e');
      return false;
    }
  }

  // Body Logs
  Future<String?> createBodyLog({
    required String userId,
    required DateTime date,
    double? weight,
    double? height,
    double? bodyFat,
    double? muscleMass,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/createBodyLog', data: {
        'userId': userId,
        'date': date.millisecondsSinceEpoch,
        'weight': weight,
        'height': height,
        'bodyFat': bodyFat,
        'muscleMass': muscleMass,
        'notes': notes,
      });

      if (response.statusCode == 200) {
        return response.data['logId'];
      }
      return null;
    } catch (e) {
      print('Error creating body log: $e');
      return null;
    }
  }

  Future<List<BodyLogModel>> getUserBodyLogs(String userId) async {
    try {
      final response = await _dio.get('/getUserBodyLogs', queryParameters: {
        'userId': userId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> logs = response.data;
        return logs.map((json) => BodyLogModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting body logs: $e');
      return [];
    }
  }

  // Credit Transactions
  Future<String?> createCreditTransaction({
    required String userId,
    required int amount,
    required String type,
    required String description,
  }) async {
    try {
      final response = await _dio.post('/createCreditTransaction', data: {
        'userId': userId,
        'amount': amount,
        'type': type,
        'description': description,
      });

      if (response.statusCode == 200) {
        return response.data['transactionId'];
      }
      return null;
    } catch (e) {
      print('Error creating credit transaction: $e');
      return null;
    }
  }

  Future<List<CreditTransactionModel>> getUserCreditTransactions(String userId) async {
    try {
      final response = await _dio.get('/getUserCreditTransactions', queryParameters: {
        'userId': userId,
      });

      if (response.statusCode == 200) {
        final List<dynamic> transactions = response.data;
        return transactions.map((json) => CreditTransactionModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error getting credit transactions: $e');
      return [];
    }
  }

  // Real-time subscriptions (using polling for now)
  Stream<List<Map<String, dynamic>>> subscribeToLeaderboard() async* {
    while (true) {
      try {
        final leaderboard = await getLeaderboard(limit: 50);
        yield leaderboard;
        await Future.delayed(const Duration(seconds: 30));
      } catch (e) {
        print('Error in leaderboard subscription: $e');
        await Future.delayed(const Duration(seconds: 60));
      }
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToCommunityPosts() async* {
    while (true) {
      try {
        final posts = await getCommunityPosts(limit: 50);
        yield posts;
        await Future.delayed(const Duration(seconds: 15));
      } catch (e) {
        print('Error in community posts subscription: $e');
        await Future.delayed(const Duration(seconds: 30));
      }
    }
  }
}

// Provider for Convex service
final convexHttpServiceProvider = Provider<ConvexHttpService>((ref) {
  return ConvexHttpService();
});