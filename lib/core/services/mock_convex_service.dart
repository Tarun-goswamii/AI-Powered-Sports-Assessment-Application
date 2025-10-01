import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

/// CONVEX Service with Real HTTP API Calls
/// Uses CONVEX HTTP Actions for queries and mutations
class ConvexService {
  static final ConvexService _instance = ConvexService._internal();
  factory ConvexService() => _instance;
  ConvexService._internal();

  final String baseUrl = AppConfig.apiBaseUrl;

  /// Initialize CONVEX client
  Future<void> initialize() async {
    print('✅ CONVEX service initialized with HTTP API calls');
    if (AppConfig.enableConvexBackend) {
      try {
        await _testConnection();
      } catch (e) {
        print('⚠️ CONVEX connection test failed, using fallback mode: $e');
      }
    }
  }

  /// Test CONVEX connection
  Future<void> _testConnection() async {
    final url = Uri.parse('$baseUrl/convex/getUserStats');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode != 200) {
      throw Exception('CONVEX health check failed: ${response.statusCode}');
    }
  }

  /// Helper method for JSON responses
  Map<String, String> _getHeaders({String? authToken}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    };
  }

  /// Query functions with real API calls

  Future<List<Map<String, dynamic>>> getUsers() async {
    if (!AppConfig.enableConvexBackend) return _getMockUsers();

    try {
      final url = Uri.parse('$baseUrl/api/users');
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['users'] ?? []);
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUsers failed: $e');
      return _getMockUsers();
    }
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUser(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getUser',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['value'];
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUser failed: $e');
      return _getMockUser(userId);
    }
  }

  Future<List<Map<String, dynamic>>> getTests() async {
    if (!AppConfig.enableConvexBackend) return _getMockTests();

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getTests',
          'args': [],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch tests: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getTests failed: $e');
      return _getMockTests();
    }
  }

  Future<List<Map<String, dynamic>>> getTestResults(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockTestResults(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getTestResults',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch test results: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getTestResults failed: $e');
      return _getMockTestResults(userId);
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    if (!AppConfig.enableConvexBackend) return _getMockLeaderboard();

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getLeaderboard',
          'args': [],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getLeaderboard failed: $e');
      return _getMockLeaderboard();
    }
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    if (!AppConfig.enableConvexBackend) return _getMockMessages();

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getMessages',
          'args': [],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getMessages failed: $e');
      return _getMockMessages();
    }
  }

  /// Mutation functions with real API calls

  Future<void> createUser(Map<String, dynamic> userData) async {
    if (!AppConfig.enableConvexBackend) {
      print('Mock CONVEX: Created user ${userData['name']}');
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/mutation');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'createUser',
          'args': [userData],
        }),
      );

      if (response.statusCode == 200) {
        print('✅ CONVEX: Created user ${userData['name']}');
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX createUser failed: $e');
      throw e;
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    if (!AppConfig.enableConvexBackend) {
      print('Mock CONVEX: Updated user $userId');
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/mutation');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'updateUser',
          'args': [userId, userData],
        }),
      );

      if (response.statusCode == 200) {
        print('✅ CONVEX: Updated user $userId');
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX updateUser failed: $e');
      throw e;
    }
  }

  Future<void> saveTestResult(Map<String, dynamic> testResult) async {
    if (!AppConfig.enableConvexBackend) {
      print('Mock CONVEX: Saved test result for user ${testResult['userId']}');
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/mutation');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'saveTestResult',
          'args': [testResult],
        }),
      );

      if (response.statusCode == 200) {
        print('✅ CONVEX: Saved test result for user ${testResult['userId']}');
      } else {
        throw Exception('Failed to save test result: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX saveTestResult failed: $e');
      throw e;
    }
  }

  Future<void> createMessage(Map<String, dynamic> messageData) async {
    if (!AppConfig.enableConvexBackend) {
      print('Mock CONVEX: Created message');
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/mutation');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'createMessage',
          'args': [messageData],
        }),
      );

      if (response.statusCode == 200) {
        print('✅ CONVEX: Created message');
      } else {
        throw Exception('Failed to create message: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX createMessage failed: $e');
      throw e;
    }
  }

  Future<void> updateCreditPoints(String userId, int points) async {
    if (!AppConfig.enableConvexBackend) {
      print('Mock CONVEX: Updated credits for user $userId: +$points');
      return;
    }

    try {
      final url = Uri.parse('$baseUrl/api/v1/mutation');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'updateCreditPoints',
          'args': [userId, points],
        }),
      );

      if (response.statusCode == 200) {
        print('✅ CONVEX: Updated credits for user $userId: +$points');
      } else {
        throw Exception('Failed to update credits: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX updateCreditPoints failed: $e');
      throw e;
    }
  }

  /// Real-time subscriptions (using polling for now since no WebSocket SDK)
  Stream<List<Map<String, dynamic>>> watchLeaderboard() {
    if (!AppConfig.enableConvexBackend) {
      return Stream.periodic(const Duration(seconds: 30), (_) => _getMockLeaderboard());
    }

    return Stream.periodic(const Duration(seconds: 30), (_) async {
      try {
        return await getLeaderboard();
      } catch (e) {
        print('❌ CONVEX watchLeaderboard failed: $e');
        return _getMockLeaderboard();
      }
    }).asyncMap((future) => future);
  }

  Stream<List<Map<String, dynamic>>> watchMessages() {
    if (!AppConfig.enableConvexBackend) {
      return Stream.periodic(const Duration(seconds: 20), (_) => _getMockMessages());
    }

    return Stream.periodic(const Duration(seconds: 20), (_) async {
      try {
        return await getMessages();
      } catch (e) {
        print('❌ CONVEX watchMessages failed: $e');
        return _getMockMessages();
      }
    }).asyncMap((future) => future);
  }

  /// Subscribe to leaderboard updates
  Stream<List<Map<String, dynamic>>> subscribeToLeaderboard() {
    return watchLeaderboard();
  }

  /// Get user stats with real API call
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUserStats(userId);

    try {
      final url = Uri.parse('$baseUrl/api/user-stats?userId=$userId');
      final response = await http.get(url, headers: _getHeaders());

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['stats'] ?? _getMockUserStats(userId);
      } else {
        throw Exception('Failed to fetch user stats: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUserStats failed: $e');
      return _getMockUserStats(userId);
    }
  }

  /// Mock data fallback methods
  List<Map<String, dynamic>> _getMockUsers() => [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'avatar': 'https://example.com/avatar1.jpg',
      'level': 5,
      'credits': 250,
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'avatar': 'https://example.com/avatar2.jpg',
      'level': 7,
      'credits': 450,
    },
  ];

  Map<String, dynamic>? _getMockUser(String userId) => {
    'id': userId,
    'name': 'Current User',
    'email': 'user@example.com',
    'avatar': 'https://example.com/avatar.jpg',
    'level': 3,
    'credits': 150,
    'testsCompleted': 12,
    'averageScore': 8.4,
  };

  List<Map<String, dynamic>> _getMockTests() => [
    {
      'id': '1',
      'name': '40m Sprint Test',
      'description': 'Measure your sprinting speed and acceleration',
      'category': 'Speed',
      'difficulty': 'Intermediate',
      'duration': 45,
      'points': 50,
    },
    {
      'id': '2',
      'name': 'Vertical Jump Test',
      'description': 'Test your explosive power',
      'category': 'Power',
      'difficulty': 'Beginner',
      'duration': 30,
      'points': 30,
    },
  ];

  List<Map<String, dynamic>> _getMockTestResults(String userId) => [
    {
      'id': '1',
      'testId': '1',
      'userId': userId,
      'score': 8.2,
      'result': '5.2s',
      'date': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'notes': 'Excellent acceleration, room for improvement in top speed',
    },
    {
      'id': '2',
      'testId': '2',
      'userId': userId,
      'score': 7.8,
      'result': '65cm',
      'date': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
      'notes': 'Good technique, focus on arm swing',
    },
  ];

  List<Map<String, dynamic>> _getMockLeaderboard() => [
    {
      'rank': 1,
      'userId': '1',
      'name': 'John Doe',
      'avatar': 'https://example.com/avatar1.jpg',
      'score': 95.2,
      'testsCompleted': 25,
    },
    {
      'rank': 2,
      'userId': '2',
      'name': 'Jane Smith',
      'avatar': 'https://example.com/avatar2.jpg',
      'score': 92.8,
      'testsCompleted': 22,
    },
  ];

  List<Map<String, dynamic>> _getMockMessages() => [
    {
      'id': '1',
      'text': 'Welcome to the sports assessment community!',
      'author': 'System',
      'createdAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    },
    {
      'id': '2',
      'text': 'Great job on completing your first test!',
      'author': 'Coach',
      'createdAt': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
    },
  ];

  Map<String, dynamic> _getMockUserStats(String userId) => {
    'totalTests': 15,
    'averageScore': 8.4,
    'bestScore': 95,
    'totalTime': 4500,
    'rank': 5,
    'achievements': ['speed_demon', 'consistency_master'],
  };

  // Mentor methods
  Future<List<Map<String, dynamic>>> getMentors() async {
    if (!AppConfig.enableConvexBackend) return _getMockMentors();

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getMentors',
          'args': [],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch mentors: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getMentors failed: $e');
      return _getMockMentors();
    }
  }

  Future<List<Map<String, dynamic>>> getUserMentorSessions(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUserMentorSessions(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getUserMentorSessions',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch mentor sessions: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUserMentorSessions failed: $e');
      return _getMockUserMentorSessions(userId);
    }
  }

  Future<List<Map<String, dynamic>>> getUserFavoriteMentors(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUserFavoriteMentors(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getUserFavoriteMentors',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch favorite mentors: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUserFavoriteMentors failed: $e');
      return _getMockUserFavoriteMentors(userId);
    }
  }

  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUserAchievements(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getUserAchievements',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch user achievements: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUserAchievements failed: $e');
      return _getMockUserAchievements(userId);
    }
  }

  Future<List<Map<String, dynamic>>> getUserBodyLogs(String userId) async {
    if (!AppConfig.enableConvexBackend) return _getMockUserBodyLogs(userId);

    try {
      final url = Uri.parse('$baseUrl/api/v1/query');
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          'functionName': 'getUserBodyLogs',
          'args': [userId],
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['value'] ?? []);
      } else {
        throw Exception('Failed to fetch body logs: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ CONVEX getUserBodyLogs failed: $e');
      return _getMockUserBodyLogs(userId);
    }
  }

  // Mock data for mentors
  List<Map<String, dynamic>> _getMockMentors() => [
    {
      'id': '1',
      'name': 'Coach Rajesh Kumar',
      'subtitle': 'Former National Sprinter',
      'specialty': 'Sprint Training Specialist',
      'description': 'Expert in sprint training with 15+ years of experience. Former national champion.',
      'rating': 4.9,
      'sessionsCount': 156,
      'price': '₹500/session',
      'categories': ['Sprint', 'Speed'],
      'isOnline': true,
      'avatarUrl': 'https://example.com/avatar1.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'name': 'Dr. Priya Sharma',
      'subtitle': 'Sports Nutritionist',
      'specialty': 'Nutrition & Diet Expert',
      'description': 'Certified sports nutritionist helping athletes optimize their diet for peak performance.',
      'rating': 4.8,
      'sessionsCount': 89,
      'price': '₹400/session',
      'categories': ['Nutrition'],
      'isOnline': false,
      'avatarUrl': 'https://example.com/avatar2.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'subtitle': 'Strength Coach',
      'specialty': 'Power & Conditioning',
      'description': 'Olympic weightlifting coach specializing in strength and conditioning programs.',
      'rating': 4.7,
      'sessionsCount': 203,
      'price': '₹600/session',
      'categories': ['Strength', 'Power'],
      'isOnline': true,
      'avatarUrl': 'https://example.com/avatar3.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '4',
      'name': 'Dr. Amit Patel',
      'subtitle': 'Sports Physiotherapist',
      'specialty': 'Injury Prevention & Recovery',
      'description': 'Experienced physiotherapist focused on injury prevention and rehabilitation.',
      'rating': 4.9,
      'sessionsCount': 127,
      'price': '₹550/session',
      'categories': ['Recovery', 'Physiotherapy'],
      'isOnline': false,
      'avatarUrl': 'https://example.com/avatar4.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];

  List<Map<String, dynamic>> _getMockUserMentorSessions(String userId) => [
    {
      'id': '1',
      'mentorId': '1',
      'userId': userId,
      'topic': 'Sprint Technique Analysis',
      'scheduledAt': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      'status': 'upcoming',
      'type': 'video_call',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'mentor': {
        'id': '1',
        'name': 'Coach Rajesh Kumar',
        'subtitle': 'Former National Sprinter',
        'specialty': 'Sprint Training Specialist',
        'rating': 4.9,
        'price': '₹500/session',
        'avatarUrl': 'https://example.com/avatar1.jpg',
      },
    },
    {
      'id': '2',
      'mentorId': '2',
      'userId': userId,
      'topic': 'Nutrition Plan Review',
      'scheduledAt': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      'status': 'upcoming',
      'type': 'chat_session',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'mentor': {
        'id': '2',
        'name': 'Dr. Priya Sharma',
        'subtitle': 'Sports Nutritionist',
        'specialty': 'Nutrition & Diet Expert',
        'rating': 4.8,
        'price': '₹400/session',
        'avatarUrl': 'https://example.com/avatar2.jpg',
      },
    },
    {
      'id': '3',
      'mentorId': '3',
      'userId': userId,
      'topic': 'Strength Training Program',
      'scheduledAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'status': 'completed',
      'type': 'video_call',
      'rating': 5.0,
      'review': 'Excellent session, very knowledgeable coach.',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'mentor': {
        'id': '3',
        'name': 'Mike Johnson',
        'subtitle': 'Strength Coach',
        'specialty': 'Power & Conditioning',
        'rating': 4.7,
        'price': '₹600/session',
        'avatarUrl': 'https://example.com/avatar3.jpg',
      },
    },
  ];

  List<Map<String, dynamic>> _getMockUserFavoriteMentors(String userId) => [
    {
      'id': '1',
      'name': 'Coach Rajesh Kumar',
      'subtitle': 'Former National Sprinter',
      'specialty': 'Sprint Training Specialist',
      'rating': 4.9,
      'sessionsCount': 156,
      'price': '₹500/session',
      'categories': ['Sprint', 'Speed'],
      'isOnline': true,
      'avatarUrl': 'https://example.com/avatar1.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'subtitle': 'Strength Coach',
      'specialty': 'Power & Conditioning',
      'rating': 4.7,
      'sessionsCount': 203,
      'price': '₹600/session',
      'categories': ['Strength', 'Power'],
      'isOnline': true,
      'avatarUrl': 'https://example.com/avatar3.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];

  List<Map<String, dynamic>> _getMockUserAchievements(String userId) => [
    {
      'id': '1',
      'achievementId': 'first_test',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
    },
    {
      'id': '2',
      'achievementId': 'speed_demon',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
    },
    {
      'id': '3',
      'achievementId': 'consistency_master',
      'unlockedAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
    },
  ];

  List<Map<String, dynamic>> _getMockUserBodyLogs(String userId) => [
    {
      'id': '1',
      'userId': userId,
      'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'weight': 75.5,
      'height': 175.0,
      'bodyFat': 12.5,
      'muscleMass': 65.0,
      'notes': 'Feeling good after the workout',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
    {
      'id': '2',
      'userId': userId,
      'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'weight': 76.0,
      'height': 175.0,
      'bodyFat': 13.0,
      'muscleMass': 64.5,
      'notes': 'Need to focus on diet',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];
}

/// Riverpod provider for CONVEX service
final convexServiceProvider = Provider<ConvexService>((ref) {
  return ConvexService();
});
