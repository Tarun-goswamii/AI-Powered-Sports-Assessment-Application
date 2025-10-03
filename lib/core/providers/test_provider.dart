import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_model.dart';
import '../models/test_result_model.dart';
import '../services/service_manager.dart';

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
  final ConvexService _convexService;

  TestNotifier(this._convexService)
      : super(const TestState(availableTests: [], testResults: []));

  Future<void> loadAvailableTests() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Fetch available tests from Convex
      final response = await _convexService.query('tests:list', {});
      
      final tests = (response as List)
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
      final response = await _convexService.query('testResults:getByUser', {'userId': userId});
      
      final results = (response['results'] as List? ?? [])
          .map((json) => TestResultModel.fromJson(json as Map<String, dynamic>))
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
      await _convexService.mutation('testResults:create', {
        'userId': userId,
        'testId': testId,
        'status': 'pending',
        'rawData': {},
        'processedData': {},
        'recommendations': [],
      });

      // Reload user test results
      await loadUserTestResults(userId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to start test: $e');
    }
  }

  Future<void> completeTest({
    required String resultId,
    required String userId,
    required Map<String, dynamic> rawData,
    required Map<String, dynamic> processedData,
    double? score,
    String? grade,
    int? percentile,
    String? feedback,
    required List<String> recommendations,
  }) async {
    try {
      await _convexService.mutation('testResults:complete', {
        'resultId': resultId,
        'status': 'completed',
        'rawData': rawData,
        'processedData': processedData,
        'score': score,
        'grade': grade,
        'percentile': percentile,
        'feedback': feedback,
        'recommendations': recommendations,
      });

      // Reload test results
      await loadUserTestResults(userId);
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
  final convexService = ServiceManager.instance.convexService;
  return TestNotifier(convexService);
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
