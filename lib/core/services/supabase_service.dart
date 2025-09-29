import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _supabase;

  SupabaseService(this._supabase);

  // Generic CRUD operations
  Future<List<Map<String, dynamic>>> select({
    required String table,
    String? select,
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    var query = _supabase.from(table).select(select ?? '*');

    // Apply filters
    if (filters != null) {
      filters.forEach((key, value) {
        query = query.eq(key, value);
      });
    }

    // Apply ordering
    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    }

    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> selectSingle({
    required String table,
    String? select,
    required Map<String, dynamic> filters,
  }) async {
    var query = _supabase.from(table).select(select ?? '*');

    filters.forEach((key, value) {
      query = query.eq(key, value);
    });

    return await query.single();
  }

  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    await _supabase.from(table).insert(data);
  }

  Future<void> update({
    required String table,
    required Map<String, dynamic> data,
    required Map<String, dynamic> filters,
  }) async {
    var query = _supabase.from(table).update(data);

    filters.forEach((key, value) {
      query = query.eq(key, value);
    });

    await query;
  }

  Future<void> delete({
    required String table,
    required Map<String, dynamic> filters,
  }) async {
    var query = _supabase.from(table).delete();

    filters.forEach((key, value) {
      query = query.eq(key, value);
    });

    await query;
  }

  // User profile operations
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    return await selectSingle(
      table: 'profiles',
      filters: {'id': userId},
    );
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await update(
      table: 'profiles',
      data: {...data, 'updated_at': DateTime.now().toIso8601String()},
      filters: {'id': userId},
    );
  }

  Future<void> createUserProfile(Map<String, dynamic> profileData) async {
    await insert(table: 'profiles', data: profileData);
  }

  // Test operations
  Future<List<Map<String, dynamic>>> getAvailableTests() async {
    return await select(
      table: 'tests',
      filters: {'is_active': true},
      orderBy: 'created_at',
      ascending: false,
    );
  }

  Future<Map<String, dynamic>> getTestById(String testId) async {
    return await selectSingle(
      table: 'tests',
      filters: {'id': testId},
    );
  }

  // Test results operations
  Future<List<Map<String, dynamic>>> getUserTestResults(String userId) async {
    return await select(
      table: 'test_results',
      filters: {'user_id': userId},
      orderBy: 'completed_at',
      ascending: false,
    );
  }

  Future<void> createTestResult(Map<String, dynamic> resultData) async {
    await insert(table: 'test_results', data: resultData);
  }

  Future<void> updateTestResult(String resultId, Map<String, dynamic> data) async {
    await update(
      table: 'test_results',
      data: {...data, 'updated_at': DateTime.now().toIso8601String()},
      filters: {'id': resultId},
    );
  }

  // Credit points operations
  Future<List<Map<String, dynamic>>> getUserCreditTransactions(String userId) async {
    return await select(
      table: 'credit_transactions',
      filters: {'user_id': userId},
      orderBy: 'created_at',
      ascending: false,
    );
  }

  Future<void> createCreditTransaction(Map<String, dynamic> transactionData) async {
    await insert(table: 'credit_transactions', data: transactionData);
  }

  // Product operations
  Future<List<Map<String, dynamic>>> getAvailableProducts() async {
    return await select(
      table: 'products',
      filters: {'is_available': true},
      orderBy: 'created_at',
      ascending: false,
    );
  }

  Future<Map<String, dynamic>> getProductById(String productId) async {
    return await selectSingle(
      table: 'products',
      filters: {'id': productId},
    );
  }

  // Store operations
  Future<List<Map<String, dynamic>>> getNearbyStores(double lat, double lng, double radiusKm) async {
    // This would require a more complex query with PostGIS or similar
    // For now, return all stores
    return await select(
      table: 'stores',
      orderBy: 'name',
    );
  }

  // Community operations
  Future<List<Map<String, dynamic>>> getCommunityPosts({int limit = 20}) async {
    return await select(
      table: 'community_posts',
      orderBy: 'created_at',
      ascending: false,
      limit: limit,
    );
  }

  Future<void> createCommunityPost(Map<String, dynamic> postData) async {
    await insert(table: 'community_posts', data: postData);
  }

  // Leaderboard operations
  Future<List<Map<String, dynamic>>> getLeaderboard({String? category, int limit = 50}) async {
    var filters = <String, dynamic>{};
    if (category != null) {
      filters['category'] = category;
    }

    return await select(
      table: 'leaderboard',
      filters: filters,
      orderBy: 'score',
      ascending: false,
      limit: limit,
    );
  }

  // File upload operations
  Future<String> uploadFile({
    required String bucket,
    required String path,
    required dynamic file,
    String? contentType,
  }) async {
    final response = await _supabase.storage.from(bucket).upload(
      path,
      file,
      fileOptions: FileOptions(
        contentType: contentType,
      ),
    );
    return response;
  }

  Future<String> getPublicUrl(String bucket, String path) async {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  Future<void> deleteFile(String bucket, String path) async {
    await _supabase.storage.from(bucket).remove([path]);
  }

  // Real-time subscriptions
  RealtimeChannel subscribeToTable({
    required String table,
    required String event,
    required Function(dynamic payload) callback,
  }) {
    return _supabase
        .channel('public:$table')
        .on(
          RealtimeListenTypes.postgresChanges,
          ChannelFilter(event: event, schema: 'public', table: table),
          callback,
        )
        .subscribe();
  }

  // Batch operations
  Future<void> batchInsert(String table, List<Map<String, dynamic>> data) async {
    await _supabase.from(table).insert(data);
  }

  Future<void> batchUpdate(
    String table,
    List<Map<String, dynamic>> updates,
    String filterKey,
  ) async {
    for (final update in updates) {
      final filterValue = update[filterKey];
      final updateData = Map<String, dynamic>.from(update)..remove(filterKey);

      await update(
        table: table,
        data: updateData,
        filters: {filterKey: filterValue},
      );
    }
  }
}
