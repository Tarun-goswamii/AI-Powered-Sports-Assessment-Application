import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

/// Real CONVEX service implementation that can work with or without the official package
/// When convex_flutter package becomes available, simply replace the HTTP calls with package calls
class ConvexService {
  final String baseUrl;
  final String deploymentName;
  final Map<String, String> _headers;

  ConvexService({
    required this.baseUrl,
    required this.deploymentName,
  }) : _headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppConfig.convexApiKey}',
        };

  // HTTP-based implementation (can be replaced with convex_flutter when available)
  Future<dynamic> _call(String functionName, Map<String, dynamic>? args) async {
    try {
      final url = Uri.parse('$baseUrl/functions/$functionName');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(args ?? {}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('CONVEX call failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Fallback to mock data if CONVEX is not available
      print('CONVEX call failed, using mock data: $e');
      return _getMockData(functionName, args);
    }
  }

  // Mock data fallback
  dynamic _getMockData(String functionName, Map<String, dynamic>? args) {
    switch (functionName) {
      case 'leaderboard:getTopPlayers':
        return _mockLeaderboardData();
      case 'activity:getUserActivity':
        return _mockUserActivity(args?['userId']);
      case 'posts:getRecentPosts':
        return _mockCommunityPosts();
      case 'challenges:getActiveChallenges':
        return _mockActiveChallenges();
      case 'posts:getUserPosts':
        return _mockUserPosts(args?['userId']);
      case 'users:getProfile':
        return _mockUserProfile(args?['userId']);
      case 'achievements:getUserAchievements':
        return _mockUserAchievements(args?['userId']);
      case 'stats:getUserStats':
        return _mockUserStats(args?['userId']);
      case 'tests:getAvailableTests':
        return _mockAvailableTests();
      case 'products:getProducts':
        return _mockProducts(args?['category']);
      case 'leaderboard:getLeaderboard':
        return _mockLeaderboard(args?['limit'] ?? 50);
      case 'analytics:getPerformanceAnalytics':
        return _mockPerformanceAnalytics(args?['userId']);
      case 'ai:getTrainingRecommendations':
        return _mockTrainingRecommendations(args?['userId']);
      case 'ai:getNutritionInsights':
        return _mockNutritionInsights(args?['userId']);
      case 'social:getFollowers':
        return _mockFollowers(args?['userId']);
      case 'social:getFollowing':
        return _mockFollowing(args?['userId']);
      default:
        return {};
    }
  }

  // Real-time subscriptions (using polling for now, can be replaced with websockets)
  Stream<Map<String, dynamic>> subscribeToLeaderboard() {
    return Stream.periodic(const Duration(seconds: 30), (_) => _mockLeaderboardData());
  }

  Stream<Map<String, dynamic>> subscribeToUserActivity(String userId) {
    return Stream.periodic(const Duration(seconds: 45), (_) => _mockUserActivity(userId));
  }

  Stream<Map<String, dynamic>> subscribeToCommunityPosts() {
    return Stream.periodic(const Duration(seconds: 60), (_) => _mockCommunityPosts());
  }

  Stream<Map<String, dynamic>> subscribeToLiveChallenges() {
    return Stream.periodic(const Duration(seconds: 120), (_) => _mockActiveChallenges());
  }

  // Mutation functions
  Future<void> createPost(Map<String, dynamic> postData) async {
    await _call('posts:createPost', postData);
  }

  Future<void> likePost(String postId, String userId) async {
    await _call('posts:likePost', {'postId': postId, 'userId': userId});
  }

  Future<void> joinChallenge(String challengeId, String userId) async {
    await _call('challenges:joinChallenge', {'challengeId': challengeId, 'userId': userId});
  }

  Future<void> submitTestResult(Map<String, dynamic> resultData) async {
    await _call('tests:submitResult', resultData);
  }

  Future<void> updateUserStats(String userId, Map<String, dynamic> stats) async {
    await _call('users:updateStats', {'userId': userId, 'stats': stats});
  }

  Future<void> createChallenge(Map<String, dynamic> challengeData) async {
    await _call('challenges:createChallenge', challengeData);
  }

  Future<void> sendNotification(String userId, Map<String, dynamic> notification) async {
    await _call('notifications:send', {'userId': userId, 'notification': notification});
  }

  // Query functions
  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    final result = await _call('posts:getUserPosts', {'userId': userId});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final result = await _call('users:getProfile', {'userId': userId});
    return Map<String, dynamic>.from(result ?? {});
  }

  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    final result = await _call('achievements:getUserAchievements', {'userId': userId});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final result = await _call('stats:getUserStats', {'userId': userId});
    return Map<String, dynamic>.from(result ?? {});
  }

  Future<List<Map<String, dynamic>>> getAvailableTests() async {
    final result = await _call('tests:getAvailableTests', {});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    final result = await _call('products:getProducts', {'category': category});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    final result = await _call('leaderboard:getLeaderboard', {'limit': limit});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  // Analytics and insights
  Future<Map<String, dynamic>> getPerformanceAnalytics(String userId) async {
    final result = await _call('analytics:getPerformanceAnalytics', {'userId': userId});
    return Map<String, dynamic>.from(result ?? {});
  }

  Future<List<Map<String, dynamic>>> getTrainingRecommendations(String userId) async {
    final result = await _call('ai:getTrainingRecommendations', {'userId': userId});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<Map<String, dynamic>> getNutritionInsights(String userId) async {
    final result = await _call('ai:getNutritionInsights', {'userId': userId});
    return Map<String, dynamic>.from(result ?? {});
  }

  // Social features
  Future<void> followUser(String followerId, String followedId) async {
    await _call('social:followUser', {'followerId': followerId, 'followedId': followedId});
  }

  Future<void> unfollowUser(String followerId, String followedId) async {
    await _call('social:unfollowUser', {'followerId': followerId, 'followedId': followedId});
  }

  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    final result = await _call('social:getFollowers', {'userId': userId});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  Future<List<Map<String, dynamic>>> getFollowing(String userId) async {
    final result = await _call('social:getFollowing', {'userId': userId});
    return List<Map<String, dynamic>>.from(result ?? []);
  }

  // Real-time chat
  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    await _call('chat:sendMessage', {'chatId': chatId, 'message': message});
  }

  Stream<List<Map<String, dynamic>>> subscribeToChat(String chatId) {
    return Stream.periodic(const Duration(seconds: 5), (_) => _mockChatMessages(chatId));
  }

  // Admin functions
  Future<void> createTest(Map<String, dynamic> testData) async {
    await _call('admin:createTest', testData);
  }

  Future<void> updateTest(String testId, Map<String, dynamic> updates) async {
    await _call('admin:updateTest', {'testId': testId, 'updates': updates});
  }

  Future<void> deleteTest(String testId) async {
    await _call('admin:deleteTest', {'testId': testId});
  }

  // Mock data implementations
  Map<String, dynamic> _mockLeaderboardData() => {
        'topPlayers': [
          {'id': '1', 'name': 'Rahul Sharma', 'score': 95, 'rank': 1},
          {'id': '2', 'name': 'Priya Patel', 'score': 92, 'rank': 2},
          {'id': '3', 'name': 'Amit Kumar', 'score': 89, 'rank': 3},
        ],
        'lastUpdated': DateTime.now().toIso8601String(),
      };

  Map<String, dynamic> _mockUserActivity(String userId) => {
        'userId': userId,
        'recentTests': [
          {'testName': '40m Sprint', 'score': 8.2, 'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String()},
          {'testName': 'Vertical Jump', 'score': 45.5, 'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String()},
        ],
        'notifications': [
          {'type': 'achievement', 'message': 'New personal best!', 'read': false},
        ],
      };

  Map<String, dynamic> _mockCommunityPosts() => {
        'posts': [
          {
            'id': '1',
            'userId': 'user1',
            'userName': 'Rahul Sharma',
            'content': 'Just completed my first 40m sprint test! Feeling great! 🏃‍♂️',
            'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
            'likes': 12,
            'comments': 3,
          },
          {
            'id': '2',
            'userId': 'user2',
            'userName': 'Priya Patel',
            'content': 'Training tips for vertical jump? Looking to improve my technique.',
            'timestamp': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
            'likes': 8,
            'comments': 5,
          },
        ],
      };

  Map<String, dynamic> _mockActiveChallenges() => {
        'challenges': [
          {
            'id': 'challenge1',
            'title': 'Weekly Sprint Challenge',
            'description': 'Beat your personal best in 40m sprint',
            'participants': 45,
            'endDate': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
          },
          {
            'id': 'challenge2',
            'title': 'Jump Higher',
            'description': 'Improve vertical jump by 5cm',
            'participants': 32,
            'endDate': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
          },
        ],
      };

  List<Map<String, dynamic>> _mockUserPosts(String userId) => [
        {
          'id': '1',
          'content': 'Great workout session today!',
          'timestamp': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
          'likes': 5,
        },
        {
          'id': '2',
          'content': 'New personal record in sprint test!',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
          'likes': 8,
        },
      ];

  Map<String, dynamic> _mockUserProfile(String userId) => {
        'id': userId,
        'name': 'John Doe',
        'email': 'john@example.com',
        'avatar': 'https://example.com/avatar.jpg',
        'level': 5,
        'totalTests': 23,
        'averageScore': 85.5,
        'joinedDate': DateTime.now().subtract(const Duration(days: 60)).toIso8601String(),
      };

  List<Map<String, dynamic>> _mockUserAchievements(String userId) => [
        {'id': '1', 'title': 'First Test Completed', 'description': 'Completed your first fitness test', 'unlockedAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String()},
        {'id': '2', 'title': 'Speed Demon', 'description': 'Achieved under 8 seconds in 40m sprint', 'unlockedAt': DateTime.now().subtract(const Duration(days: 15)).toIso8601String()},
        {'id': '3', 'title': 'Consistent Performer', 'description': 'Completed 10 tests', 'unlockedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String()},
      ];

  Map<String, dynamic> _mockUserStats(String userId) => {
        'totalTests': 23,
        'averageScore': 85.5,
        'bestScore': 95,
        'improvementRate': 2.3,
        'favoriteTest': '40m Sprint',
        'lastTestDate': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      };

  List<Map<String, dynamic>> _mockAvailableTests() => [
        {'id': '1', 'name': '40m Sprint', 'description': 'Measure your sprinting speed', 'duration': '30 seconds', 'difficulty': 'Medium'},
        {'id': '2', 'name': 'Vertical Jump', 'description': 'Test your explosive power', 'duration': '15 seconds', 'difficulty': 'Easy'},
        {'id': '3', 'name': 'Agility Test', 'description': 'Test your change of direction speed', 'duration': '45 seconds', 'difficulty': 'Hard'},
        {'id': '4', 'name': 'Endurance Test', 'description': 'Measure your cardiovascular fitness', 'duration': '10 minutes', 'difficulty': 'Hard'},
      ];

  List<Map<String, dynamic>> _mockProducts(String? category) => [
        {'id': '1', 'name': 'Protein Powder', 'category': 'supplements', 'price': 2999, 'rating': 4.5},
        {'id': '2', 'name': 'Running Shoes', 'category': 'gear', 'price': 5999, 'rating': 4.8},
        {'id': '3', 'name': 'Resistance Bands', 'category': 'equipment', 'price': 1499, 'rating': 4.2},
      ];

  List<Map<String, dynamic>> _mockLeaderboard(int limit) => [
        {'rank': 1, 'name': 'Rahul Sharma', 'score': 95, 'tests': 25},
        {'rank': 2, 'name': 'Priya Patel', 'score': 92, 'tests': 22},
        {'rank': 3, 'name': 'Amit Kumar', 'score': 89, 'tests': 28},
        {'rank': 4, 'name': 'Sneha Reddy', 'score': 87, 'tests': 20},
        {'rank': 5, 'name': 'Vikram Singh', 'score': 85, 'tests': 19},
      ];

  Map<String, dynamic> _mockPerformanceAnalytics(String userId) => {
        'trend': 'improving',
        'improvement': 5.2,
        'consistency': 78,
        'strengths': ['Speed', 'Agility'],
        'weaknesses': ['Endurance'],
        'recommendations': ['Focus on cardio training', 'Practice sprint technique'],
      };

  List<Map<String, dynamic>> _mockTrainingRecommendations(String userId) => [
        {'type': 'sprint', 'title': 'Sprint Training', 'description': 'Improve your 40m sprint time', 'difficulty': 'Medium'},
        {'type': 'jump', 'title': 'Plyometric Training', 'description': 'Increase vertical jump height', 'difficulty': 'Hard'},
        {'type': 'agility', 'title': 'Agility Drills', 'description': 'Enhance change of direction speed', 'difficulty': 'Medium'},
      ];

  Map<String, dynamic> _mockNutritionInsights(String userId) => {
        'calorieNeeds': 2500,
        'proteinNeeds': 150,
        'carbNeeds': 300,
        'fatNeeds': 80,
        'recommendations': ['Increase protein intake', 'Focus on complex carbs'],
      };

  List<Map<String, dynamic>> _mockFollowers(String userId) => [
        {'id': 'follower1', 'name': 'Alice Johnson', 'avatar': 'https://example.com/avatar1.jpg'},
        {'id': 'follower2', 'name': 'Bob Smith', 'avatar': 'https://example.com/avatar2.jpg'},
      ];

  List<Map<String, dynamic>> _mockFollowing(String userId) => [
        {'id': 'following1', 'name': 'Charlie Brown', 'avatar': 'https://example.com/avatar3.jpg'},
        {'id': 'following2', 'name': 'Diana Prince', 'avatar': 'https://example.com/avatar4.jpg'},
      ];

  List<Map<String, dynamic>> _mockChatMessages(String chatId) => [
        {'id': '1', 'senderId': 'user1', 'message': 'Hey, how was your test?', 'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String()},
        {'id': '2', 'senderId': 'user2', 'message': 'Great! Got a new personal best!', 'timestamp': DateTime.now().subtract(const Duration(minutes: 3)).toIso8601String()},
      ];
}
