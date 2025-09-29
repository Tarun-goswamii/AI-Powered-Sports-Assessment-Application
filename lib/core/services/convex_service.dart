import 'package:convex_flutter/convex.dart';
import '../config/app_config.dart';

class ConvexService {
  late ConvexClient _client;

  ConvexService() {
    _client = ConvexClient(AppConfig.convexUrl);
  }

  ConvexClient get client => _client;

  // Real-time subscriptions
  Stream<Map<String, dynamic>> subscribeToLeaderboard() {
    return _client.subscribe('leaderboard:getTopPlayers');
  }

  Stream<Map<String, dynamic>> subscribeToUserActivity(String userId) {
    return _client.subscribe('activity:getUserActivity', {'userId': userId});
  }

  Stream<Map<String, dynamic>> subscribeToCommunityPosts() {
    return _client.subscribe('posts:getRecentPosts');
  }

  Stream<Map<String, dynamic>> subscribeToLiveChallenges() {
    return _client.subscribe('challenges:getActiveChallenges');
  }

  // Mutation functions
  Future<void> createPost(Map<String, dynamic> postData) async {
    await _client.mutation('posts:createPost', postData);
  }

  Future<void> likePost(String postId, String userId) async {
    await _client.mutation('posts:likePost', {'postId': postId, 'userId': userId});
  }

  Future<void> joinChallenge(String challengeId, String userId) async {
    await _client.mutation('challenges:joinChallenge', {'challengeId': challengeId, 'userId': userId});
  }

  Future<void> submitTestResult(Map<String, dynamic> resultData) async {
    await _client.mutation('tests:submitResult', resultData);
  }

  Future<void> updateUserStats(String userId, Map<String, dynamic> stats) async {
    await _client.mutation('users:updateStats', {'userId': userId, 'stats': stats});
  }

  Future<void> createChallenge(Map<String, dynamic> challengeData) async {
    await _client.mutation('challenges:createChallenge', challengeData);
  }

  Future<void> sendNotification(String userId, Map<String, dynamic> notification) async {
    await _client.mutation('notifications:send', {'userId': userId, 'notification': notification});
  }

  // Query functions
  Future<List<Map<String, dynamic>>> getUserPosts(String userId) async {
    final result = await _client.query('posts:getUserPosts', {'userId': userId});
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    final result = await _client.query('users:getProfile', {'userId': userId});
    return Map<String, dynamic>.from(result);
  }

  Future<List<Map<String, dynamic>>> getUserAchievements(String userId) async {
    final result = await _client.query('achievements:getUserAchievements', {'userId': userId});
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final result = await _client.query('stats:getUserStats', {'userId': userId});
    return Map<String, dynamic>.from(result);
  }

  Future<List<Map<String, dynamic>>> getAvailableTests() async {
    final result = await _client.query('tests:getAvailableTests');
    return List<Map<String, dynamic>>.from(result);
  }

  Future<List<Map<String, dynamic>>> getProducts({String? category}) async {
    final result = await _client.query('products:getProducts', {'category': category});
    return List<Map<String, dynamic>>.from(result);
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    final result = await _client.query('leaderboard:getLeaderboard', {'limit': limit});
    return List<Map<String, dynamic>>.from(result);
  }

  // Analytics and insights
  Future<Map<String, dynamic>> getPerformanceAnalytics(String userId) async {
    final result = await _client.query('analytics:getPerformanceAnalytics', {'userId': userId});
    return Map<String, dynamic>.from(result);
  }

  Future<List<Map<String, dynamic>>> getTrainingRecommendations(String userId) async {
    final result = await _client.query('ai:getTrainingRecommendations', {'userId': userId});
    return List<Map<String, dynamic>>.from(result);
  }

  Future<Map<String, dynamic>> getNutritionInsights(String userId) async {
    final result = await _client.query('ai:getNutritionInsights', {'userId': userId});
    return Map<String, dynamic>.from(result);
  }

  // Social features
  Future<void> followUser(String followerId, String followedId) async {
    await _client.mutation('social:followUser', {'followerId': followerId, 'followedId': followedId});
  }

  Future<void> unfollowUser(String followerId, String followedId) async {
    await _client.mutation('social:unfollowUser', {'followerId': followerId, 'followedId': followedId});
  }

  Future<List<Map<String, dynamic>>> getFollowers(String userId) async {
    final result = await _client.query('social:getFollowers', {'userId': userId});
    return List<Map<String, dynamic>>.from(result);
  }

  Future<List<Map<String, dynamic>>> getFollowing(String userId) async {
    final result = await _client.query('social:getFollowing', {'userId': userId});
    return List<Map<String, dynamic>>.from(result);
  }

  // Real-time chat (if implemented)
  Future<void> sendMessage(String chatId, Map<String, dynamic> message) async {
    await _client.mutation('chat:sendMessage', {'chatId': chatId, 'message': message});
  }

  Stream<List<Map<String, dynamic>>> subscribeToChat(String chatId) {
    return _client.subscribe('chat:getMessages', {'chatId': chatId});
  }

  // Admin functions (if needed)
  Future<void> createTest(Map<String, dynamic> testData) async {
    await _client.mutation('admin:createTest', testData);
  }

  Future<void> updateTest(String testId, Map<String, dynamic> updates) async {
    await _client.mutation('admin:updateTest', {'testId': testId, 'updates': updates});
  }

  Future<void> deleteTest(String testId) async {
    await _client.mutation('admin:deleteTest', {'testId': testId});
  }
}
