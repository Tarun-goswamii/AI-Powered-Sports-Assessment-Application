import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock CONVEX Service for Real-time Database and Serverless Functions
/// This is a temporary implementation until the actual CONVEX Flutter package is available
class MockConvexService {
  static final MockConvexService _instance = MockConvexService._internal();
  factory MockConvexService() => _instance;
  MockConvexService._internal();

  /// Initialize CONVEX client
  Future<void> initialize() async {
    print('Mock CONVEX service initialized');
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 1));
  }

  /// Query functions
  Future<List<Map<String, dynamic>>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'id': userId,
      'name': 'Current User',
      'email': 'user@example.com',
      'avatar': 'https://example.com/avatar.jpg',
      'level': 3,
      'credits': 150,
      'testsCompleted': 12,
      'averageScore': 8.4,
    };
  }

  Future<List<Map<String, dynamic>>> getTests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
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
  }

  Future<List<Map<String, dynamic>>> getTestResults(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
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
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      {
        'id': '1',
        'name': 'Premium Protein Powder',
        'description': 'High-quality whey protein for muscle recovery',
        'price': 2999,
        'category': 'Nutrition',
        'image': 'https://example.com/protein.jpg',
        'inStock': true,
      },
      {
        'id': '2',
        'name': 'Speed Training Shoes',
        'description': 'Lightweight sprinting shoes for optimal performance',
        'price': 8999,
        'category': 'Equipment',
        'image': 'https://example.com/shoes.jpg',
        'inStock': true,
      },
    ];
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
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
  }

  /// Mutation functions
  Future<void> createUser(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(milliseconds: 800));
    print('Mock CONVEX: Created user ${userData['name']}');
  }

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(milliseconds: 600));
    print('Mock CONVEX: Updated user $userId');
  }

  Future<void> saveTestResult(Map<String, dynamic> testResult) async {
    await Future.delayed(const Duration(milliseconds: 700));
    print('Mock CONVEX: Saved test result for user ${testResult['userId']}');
  }

  Future<void> updateCreditPoints(String userId, int points) async {
    await Future.delayed(const Duration(milliseconds: 400));
    print('Mock CONVEX: Updated credits for user $userId: +$points');
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('Mock CONVEX: Created post by user ${postData['userId']}');
  }

  Future<void> addToCart(String userId, String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Mock CONVEX: Added product $productId to cart for user $userId');
  }

  /// Real-time subscriptions (mock streams)
  Stream<List<Map<String, dynamic>>> watchLeaderboard() {
    return Stream.periodic(const Duration(seconds: 30), (_) => [
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
    ]);
  }

  Stream<List<Map<String, dynamic>>> watchUserPosts(String userId) {
    return Stream.periodic(const Duration(seconds: 20), (_) => [
      {
        'id': '1',
        'userId': userId,
        'content': 'Just completed my first 40m sprint test! Feeling great! 💪',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'likes': 12,
        'comments': 3,
      },
    ]);
  }

  Stream<Map<String, dynamic>> watchUserProfile(String userId) {
    return Stream.periodic(const Duration(seconds: 60), (_) => {
      'id': userId,
      'name': 'Current User',
      'email': 'user@example.com',
      'avatar': 'https://example.com/avatar.jpg',
      'level': 3,
      'credits': 150,
      'testsCompleted': 12,
      'averageScore': 8.4,
    });
  }

  Stream<List<Map<String, dynamic>>> watchNotifications(String userId) {
    return Stream.periodic(const Duration(seconds: 45), (_) => [
      {
        'id': '1',
        'type': 'achievement',
        'title': 'New Achievement Unlocked!',
        'message': 'You earned the "Speed Demon" badge',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        'read': false,
      },
    ]);
  }
}

/// Riverpod provider for Mock CONVEX service
final mockConvexServiceProvider = Provider<MockConvexService>((ref) {
  return MockConvexService();
});
