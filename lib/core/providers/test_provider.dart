import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/test_model.dart';
import '../models/test_result_model.dart';

class TestState {
  final List<TestModel> availableTests;
  final List<TestResultModel> testResults;
  final bool isLoading;
  final String? errorMessage;

  const TestState({
    required this.availableTests,
    required this.testResults,
    this.isLoading = false,
    this.errorMessage,
  });

  TestState copyWith({
    List<TestModel>? availableTests,
    List<TestResultModel>? testResults,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TestState(
      availableTests: availableTests ?? this.availableTests,
      testResults: testResults ?? this.testResults,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TestNotifier extends StateNotifier<TestState> {
  final SupabaseClient _supabase;

  TestNotifier(this._supabase)
      : super(const TestState(availableTests: [], testResults: []));

  Future<void> loadAvailableTests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase
          .from('tests')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final tests = response
          .map((json) => TestModel.fromJson(json))
          .toList();

      state = state.copyWith(
        availableTests: tests,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load tests: $e',
      );
    }
  }

  Future<void> loadUserTestResults(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase
          .from('test_results')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: false);

      final results = response
          .map((json) => TestResultModel.fromJson(json))
          .toList();

      state = state.copyWith(
        testResults: results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load test results: $e',
      );
    }
  }

  Future<void> startTest(String userId, String testId) async {
    try {
      final testResult = TestResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        testId: testId,
        status: TestResultStatus.pending,
        rawData: {},
        processedData: {},
        recommendations: [],
        startedAt: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final resultData = testResult.toJson();
      resultData.remove('id'); // Let Supabase generate the ID

      await _supabase.from('test_results').insert(resultData);

      // Reload user test results
      await loadUserTestResults(userId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start test: $e');
    }
  }

  Future<void> completeTest({
    required String resultId,
    required Map<String, dynamic> rawData,
    required Map<String, dynamic> processedData,
    double? score,
    String? grade,
    int? percentile,
    String? feedback,
    required List<String> recommendations,
  }) async {
    try {
      final updateData = {
        'status': TestResultStatus.completed.index,
        'raw_data': rawData,
        'processed_data': processedData,
        'score': score,
        'grade': grade,
        'percentile': percentile,
        'feedback': feedback,
        'recommendations': recommendations,
        'completed_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('test_results')
          .update(updateData)
          .eq('id', resultId);

      // Reload test results
      final currentUserId = _supabase.auth.currentUser?.id;
      if (currentUserId != null) {
        await loadUserTestResults(currentUserId);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to complete test: $e');
    }
  }

  TestModel? getTestById(String testId) {
    return state.availableTests
        .where((test) => test.id == testId)
        .firstOrNull;
  }

  TestResultModel? getTestResultById(String resultId) {
    return state.testResults
        .where((result) => result.id == resultId)
        .firstOrNull;
  }

  List<TestResultModel> getTestResultsByTestId(String testId) {
    return state.testResults
        .where((result) => result.testId == testId)
        .toList();
  }

  int getCompletedTestsCount() {
    return state.testResults
        .where((result) => result.status == TestResultStatus.completed)
        .length;
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final testProvider = StateNotifierProvider<TestNotifier, TestState>((ref) {
  final supabase = Supabase.instance.client;
  return TestNotifier(supabase);
});

final availableTestsProvider = Provider<List<TestModel>>((ref) {
  return ref.watch(testProvider).availableTests;
});

final testResultsProvider = Provider<List<TestResultModel>>((ref) {
  return ref.watch(testProvider).testResults;
});

final completedTestsCountProvider = Provider<int>((ref) {
  return ref.watch(testProvider.notifier).getCompletedTestsCount();
});
