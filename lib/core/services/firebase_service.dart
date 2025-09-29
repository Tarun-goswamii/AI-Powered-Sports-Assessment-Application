import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/test_model.dart';
import '../models/test_result_model.dart';
import '../models/product_model.dart';
import '../models/credit_points_model.dart';
import '../models/simple_user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Collection references
  CollectionReference get _users => _firestore.collection('users');
  CollectionReference get _tests => _firestore.collection('tests');
  CollectionReference get _testResults => _firestore.collection('test_results');
  CollectionReference get _products => _firestore.collection('products');
  CollectionReference get _creditTransactions => _firestore.collection('credit_transactions');
  CollectionReference get _leaderboard => _firestore.collection('leaderboard');
  CollectionReference get _communityPosts => _firestore.collection('community_posts');
  CollectionReference get _challenges => _firestore.collection('challenges');

  // User Profile Operations
  Future<void> createUserProfile(SimpleUserModel user) async {
    await _users.doc(user.id).set(user.toJson());
  }

  Future<SimpleUserModel?> getUserProfile(String userId) async {
    final doc = await _users.doc(userId).get();
    if (doc.exists) {
      return SimpleUserModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _users.doc(userId).update({
      ...data,
      'updatedAt': DateTime.now(),
    });
  }

  // Test Operations
  Future<List<TestModel>> getAvailableTests() async {
    final snapshot = await _tests.where('isActive', isEqualTo: true).get();
    return snapshot.docs
        .map((doc) => TestModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<TestModel?> getTestById(String testId) async {
    final doc = await _tests.doc(testId).get();
    if (doc.exists) {
      return TestModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Test Results Operations
  Future<void> saveTestResult(TestResultModel result) async {
    await _testResults.doc(result.id).set(result.toJson());

    // Update user's test history
    await _users.doc(result.userId).update({
      'completedTests': FieldValue.arrayUnion([result.testId]),
      'totalTestsCompleted': FieldValue.increment(1),
      'lastTestDate': result.completedAt,
      'updatedAt': DateTime.now(),
    });
  }

  Future<List<TestResultModel>> getUserTestResults(String userId) async {
    final snapshot = await _testResults
        .where('userId', isEqualTo: userId)
        .orderBy('completedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TestResultModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<TestResultModel?> getTestResult(String resultId) async {
    final doc = await _testResults.doc(resultId).get();
    if (doc.exists) {
      return TestResultModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Leaderboard Operations
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    final snapshot = await _leaderboard
        .orderBy('totalScore', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> updateLeaderboardEntry(String userId, Map<String, dynamic> data) async {
    await _leaderboard.doc(userId).set(data, SetOptions(merge: true));
  }

  // Product Operations
  Future<List<ProductModel>> getProducts({String? category}) async {
    Query query = _products.where('isActive', isEqualTo: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _products.doc(productId).get();
    if (doc.exists) {
      return ProductModel.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Credit Points Operations
  Future<int> getUserCredits(String userId) async {
    final doc = await _users.doc(userId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      return data['credits'] ?? 0;
    }
    return 0;
  }

  Future<void> updateUserCredits(String userId, int amount, String reason) async {
    final transaction = CreditTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      amount: amount,
      type: amount > 0 ? CreditTransactionType.earned : CreditTransactionType.spent,
      reason: reason,
      timestamp: DateTime.now(),
    );

    // Add transaction record
    await _creditTransactions.doc(transaction.id).set(transaction.toJson());

    // Update user credits
    await _users.doc(userId).update({
      'credits': FieldValue.increment(amount),
      'updatedAt': DateTime.now(),
    });
  }

  Future<List<CreditTransactionModel>> getCreditTransactions(String userId, {int limit = 20}) async {
    final snapshot = await _creditTransactions
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map((doc) => CreditTransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Community Operations
  Future<void> createCommunityPost(Map<String, dynamic> post) async {
    await _communityPosts.add({
      ...post,
      'createdAt': DateTime.now(),
      'likes': 0,
      'comments': [],
    });
  }

  Future<List<Map<String, dynamic>>> getCommunityPosts({int limit = 20}) async {
    final snapshot = await _communityPosts
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }

  Future<void> likePost(String postId, String userId) async {
    await _communityPosts.doc(postId).update({
      'likes': FieldValue.increment(1),
      'likedBy': FieldValue.arrayUnion([userId]),
    });
  }

  // Challenge Operations
  Future<List<Map<String, dynamic>>> getActiveChallenges() async {
    final snapshot = await _challenges
        .where('isActive', isEqualTo: true)
        .where('endDate', isGreaterThan: DateTime.now())
        .get();

    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>
    }).toList();
  }

  Future<void> joinChallenge(String challengeId, String userId) async {
    await _challenges.doc(challengeId).update({
      'participants': FieldValue.arrayUnion([userId]),
      'participantCount': FieldValue.increment(1),
    });
  }

  // Real-time listeners
  Stream<List<Map<String, dynamic>>> getLeaderboardStream() {
    return _leaderboard
        .orderBy('totalScore', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  Stream<List<Map<String, dynamic>>> getCommunityPostsStream() {
    return _communityPosts
        .orderBy('createdAt', descending: true)
        .limit(20)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {
              'id': doc.id,
              ...doc.data()
            }).toList());
  }

  Stream<int> getUserCreditsStream(String userId) {
    return _users.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['credits'] ?? 0;
      }
      return 0;
    });
  }

  // File Upload Operations
  Future<String> uploadFile(String path, String fileName, dynamic file) async {
    final ref = _storage.ref().child(path).child(fileName);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> deleteFile(String url) async {
    final ref = _storage.refFromURL(url);
    await ref.delete();
  }

  // Analytics and Stats
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final testResults = await getUserTestResults(userId);
    final credits = await getUserCredits(userId);

    return {
      'totalTests': testResults.length,
      'averageScore': testResults.isEmpty ? 0 :
          testResults.map((r) => r.score).reduce((a, b) => a + b) / testResults.length,
      'credits': credits,
      'lastTestDate': testResults.isEmpty ? null : testResults.first.completedAt,
    };
  }

  // Batch operations for efficiency
  Future<void> batchUpdateUserStats(String userId, Map<String, dynamic> stats) async {
    final batch = _firestore.batch();

    final userRef = _users.doc(userId);
    batch.update(userRef, {
      ...stats,
      'updatedAt': DateTime.now(),
    });

    await batch.commit();
  }
}

// Provider for Firebase Service
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});
