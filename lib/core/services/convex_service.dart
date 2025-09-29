import 'package:convex_flutter/convex.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

/// CONVEX Service for Real-time Database and Serverless Functions
class ConvexService {
  static ConvexClient? _client;

  static ConvexClient get client {
    if (_client == null) {
      _client = ConvexClient(AppConfig.convexUrl);
    }
    return _client!;
  }

  /// Initialize CONVEX client
  static Future<void> initialize() async {
    // CONVEX client is initialized lazily
    print('CONVEX service initialized');
  }

  /// Query functions
  static Future<List<dynamic>> getUsers() async {
    return await client.query('getUsers');
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    return await client.query('getUser', {'userId': userId});
  }

  static Future<List<dynamic>> getTests() async {
    return await client.query('getTests');
  }

  static Future<List<dynamic>> getTestResults(String userId) async {
    return await client.query('getTestResults', {'userId': userId});
  }

  static Future<List<dynamic>> getProducts() async {
    return await client.query('getProducts');
  }

  static Future<List<dynamic>> getLeaderboard() async {
    return await client.query('getLeaderboard');
  }

  /// Mutation functions
  static Future<void> createUser(Map<String, dynamic> userData) async {
    await client.mutation('createUser', userData);
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    await client.mutation('updateUser', {'userId': userId, ...userData});
  }

  static Future<void> saveTestResult(Map<String, dynamic> testResult) async {
    await client.mutation('saveTestResult', testResult);
  }

  static Future<void> updateCreditPoints(String userId, int points) async {
    await client.mutation('updateCreditPoints', {'userId': userId, 'points': points});
  }

  static Future<void> createPost(Map<String, dynamic> postData) async {
    await client.mutation('createPost', postData);
  }

  static Future<void> addToCart(String userId, String productId) async {
    await client.mutation('addToCart', {'userId': userId, 'productId': productId});
  }

  /// Real-time subscriptions
  static Stream<List<dynamic>> watchLeaderboard() {
    return client.subscribe('watchLeaderboard');
  }

  static Stream<List<dynamic>> watchUserPosts(String userId) {
    return client.subscribe('watchUserPosts', {'userId': userId});
  }

  static Stream<Map<String, dynamic>> watchUserProfile(String userId) {
    return client.subscribe('watchUserProfile', {'userId': userId});
  }

  static Stream<List<dynamic>> watchNotifications(String userId) {
    return client.subscribe('watchNotifications', {'userId': userId});
  }
}

/// Riverpod provider for CONVEX service
final convexServiceProvider = Provider<ConvexService>((ref) {
  return ConvexService();
});

/// CONVEX client provider
final convexClientProvider = Provider<ConvexClient>((ref) {
  return ConvexService.client;
});
