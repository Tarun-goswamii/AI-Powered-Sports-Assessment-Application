// lib/core/providers/dynamic_data_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/integrated_service_manager.dart';
import '../models/test_result_model.dart';
import '../models/simple_user_model.dart';
import '../models/achievement_model.dart';
import '../models/mentor_model.dart';
import '../models/body_log_model.dart';
import '../models/credit_transaction_model.dart';

// Real-time Leaderboard Provider
final leaderboardProvider = StreamProvider.family<List<Map<String, dynamic>>, int>((ref, limit) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return serviceManager.getLeaderboardStream();
});

// Real-time Community Posts Provider
final communityPostsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return serviceManager.getCommunityPostsStream();
});

// User-specific data providers
final userProvider = StateProvider<SimpleUserModel?>((ref) => null);

final userTestResultsProvider = FutureProvider.family<List<TestResultModel>, String>((ref, userId) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getUserTestResults(userId);
});

final userAchievementsProvider = FutureProvider.family<List<AchievementModel>, String>((ref, userId) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getUserAchievements(userId);
});

final userCreditTransactionsProvider = FutureProvider.family<List<CreditTransactionModel>, String>((ref, userId) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getUserCreditTransactions(userId);
});

final userBodyLogsProvider = FutureProvider.family<List<BodyLogModel>, String>((ref, userId) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getUserBodyLogs(userId);
});

// Mentors data providers
final mentorsProvider = FutureProvider<List<MentorModel>>((ref) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getMentors();
});

// Global leaderboard provider (cached)
final globalLeaderboardProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, limit) async {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return await serviceManager.convexService.getLeaderboard(limit: limit);
});

// Test submission state provider
class TestSubmissionState {
  final bool isSubmitting;
  final String? currentStep;
  final double? progress;
  final String? error;
  final TestResultModel? result;

  TestSubmissionState({
    this.isSubmitting = false,
    this.currentStep,
    this.progress,
    this.error,
    this.result,
  });

  TestSubmissionState copyWith({
    bool? isSubmitting,
    String? currentStep,
    double? progress,
    String? error,
    TestResultModel? result,
  }) {
    return TestSubmissionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      currentStep: currentStep ?? this.currentStep,
      progress: progress ?? this.progress,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }
}

class TestSubmissionNotifier extends StateNotifier<TestSubmissionState> {
  final IntegratedServiceManager _serviceManager;

  TestSubmissionNotifier(this._serviceManager) : super(TestSubmissionState());

  Future<void> submitTest({
    required String userId,
    required String testId,
    required String videoPath,
    required Duration videoDuration,
    required String userEmail,
    required String userName,
  }) async {
    state = state.copyWith(isSubmitting: true, currentStep: 'Initializing...', progress: 0.0);

    try {
      // Step 1: ML Analysis
      state = state.copyWith(currentStep: 'Analyzing video with AI...', progress: 0.2);
      
      // Step 2: Backend submission
      state = state.copyWith(currentStep: 'Submitting results...', progress: 0.4);
      
      // Step 3: Leaderboard update
      state = state.copyWith(currentStep: 'Updating leaderboard...', progress: 0.6);
      
      // Step 4: Achievement check
      state = state.copyWith(currentStep: 'Checking achievements...', progress: 0.8);
      
      // Step 5: Email notification
      state = state.copyWith(currentStep: 'Sending notifications...', progress: 0.9);

      final result = await _serviceManager.submitCompleteTestResult(
        userId: userId,
        testId: testId,
        videoPath: videoPath,
        videoDuration: videoDuration,
        userEmail: userEmail,
        userName: userName,
      );

      if (result != null) {
        state = state.copyWith(
          isSubmitting: false,
          currentStep: 'Complete!',
          progress: 1.0,
          result: result,
          error: null,
        );
      } else {
        state = state.copyWith(
          isSubmitting: false,
          error: 'Failed to submit test result',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = TestSubmissionState();
  }
}

final testSubmissionProvider = StateNotifierProvider<TestSubmissionNotifier, TestSubmissionState>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return TestSubmissionNotifier(serviceManager);
});

// Community interaction providers
class CommunityState {
  final List<Map<String, dynamic>> posts;
  final bool isLoading;
  final String? error;
  final bool isCreatingPost;

  CommunityState({
    this.posts = const [],
    this.isLoading = false,
    this.error,
    this.isCreatingPost = false,
  });

  CommunityState copyWith({
    List<Map<String, dynamic>>? posts,
    bool? isLoading,
    String? error,
    bool? isCreatingPost,
  }) {
    return CommunityState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isCreatingPost: isCreatingPost ?? this.isCreatingPost,
    );
  }
}

class CommunityNotifier extends StateNotifier<CommunityState> {
  final IntegratedServiceManager _serviceManager;

  CommunityNotifier(this._serviceManager) : super(CommunityState()) {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    state = state.copyWith(isLoading: true);
    try {
      final posts = await _serviceManager.convexService.getCommunityPosts();
      state = state.copyWith(posts: posts, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createPost({
    required String userId,
    required String content,
    String? type,
    String? imageUrl,
  }) async {
    state = state.copyWith(isCreatingPost: true);
    try {
      final postId = await _serviceManager.createCommunityPostWithNotifications(
        userId: userId,
        content: content,
        type: type,
        imageUrl: imageUrl,
      );

      if (postId != null) {
        // Refresh posts
        await _loadPosts();
        state = state.copyWith(isCreatingPost: false);
      } else {
        state = state.copyWith(isCreatingPost: false, error: 'Failed to create post');
      }
    } catch (e) {
      state = state.copyWith(isCreatingPost: false, error: e.toString());
    }
  }

  void refresh() {
    _loadPosts();
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, CommunityState>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return CommunityNotifier(serviceManager);
});

// Mentor booking provider
class MentorBookingState {
  final bool isBooking;
  final String? error;
  final bool bookingSuccess;

  MentorBookingState({
    this.isBooking = false,
    this.error,
    this.bookingSuccess = false,
  });

  MentorBookingState copyWith({
    bool? isBooking,
    String? error,
    bool? bookingSuccess,
  }) {
    return MentorBookingState(
      isBooking: isBooking ?? this.isBooking,
      error: error ?? this.error,
      bookingSuccess: bookingSuccess ?? this.bookingSuccess,
    );
  }
}

class MentorBookingNotifier extends StateNotifier<MentorBookingState> {
  final IntegratedServiceManager _serviceManager;

  MentorBookingNotifier(this._serviceManager) : super(MentorBookingState());

  Future<void> bookSession({
    required String mentorId,
    required String userId,
    required String userEmail,
    required String userName,
    required String mentorName,
    required String topic,
    required DateTime scheduledAt,
    required String type,
  }) async {
    state = state.copyWith(isBooking: true, error: null);

    try {
      final success = await _serviceManager.bookMentorSessionWithEmail(
        mentorId: mentorId,
        userId: userId,
        userEmail: userEmail,
        userName: userName,
        mentorName: mentorName,
        topic: topic,
        scheduledAt: scheduledAt,
        type: type,
      );

      state = state.copyWith(
        isBooking: false,
        bookingSuccess: success,
        error: success ? null : 'Failed to book session',
      );
    } catch (e) {
      state = state.copyWith(
        isBooking: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = MentorBookingState();
  }
}

final mentorBookingProvider = StateNotifierProvider<MentorBookingNotifier, MentorBookingState>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return MentorBookingNotifier(serviceManager);
});

// User registration provider
class UserRegistrationState {
  final bool isRegistering;
  final String? error;
  final SimpleUserModel? user;

  UserRegistrationState({
    this.isRegistering = false,
    this.error,
    this.user,
  });

  UserRegistrationState copyWith({
    bool? isRegistering,
    String? error,
    SimpleUserModel? user,
  }) {
    return UserRegistrationState(
      isRegistering: isRegistering ?? this.isRegistering,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

class UserRegistrationNotifier extends StateNotifier<UserRegistrationState> {
  final IntegratedServiceManager _serviceManager;

  UserRegistrationNotifier(this._serviceManager) : super(UserRegistrationState());

  Future<void> registerUser({
    required String email,
    required String name,
  }) async {
    state = state.copyWith(isRegistering: true, error: null);

    try {
      final user = await _serviceManager.registerUserWithWelcome(
        email: email,
        name: name,
      );

      state = state.copyWith(
        isRegistering: false,
        user: user,
        error: user == null ? 'Failed to register user' : null,
      );
    } catch (e) {
      state = state.copyWith(
        isRegistering: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = UserRegistrationState();
  }
}

final userRegistrationProvider = StateNotifierProvider<UserRegistrationNotifier, UserRegistrationState>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return UserRegistrationNotifier(serviceManager);
});

// Body log provider
class BodyLogState {
  final List<BodyLogModel> logs;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  BodyLogState({
    this.logs = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  BodyLogState copyWith({
    List<BodyLogModel>? logs,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return BodyLogState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
    );
  }
}

class BodyLogNotifier extends StateNotifier<BodyLogState> {
  final IntegratedServiceManager _serviceManager;

  BodyLogNotifier(this._serviceManager) : super(BodyLogState());

  Future<void> loadLogs(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final logs = await _serviceManager.convexService.getUserBodyLogs(userId);
      state = state.copyWith(logs: logs, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createLog({
    required String userId,
    required DateTime date,
    double? weight,
    double? height,
    double? bodyFat,
    double? muscleMass,
    String? notes,
  }) async {
    state = state.copyWith(isCreating: true);
    try {
      final logId = await _serviceManager.convexService.createBodyLog(
        userId: userId,
        date: date,
        weight: weight,
        height: height,
        bodyFat: bodyFat,
        muscleMass: muscleMass,
        notes: notes,
      );

      if (logId != null) {
        // Refresh logs
        await loadLogs(userId);
        state = state.copyWith(isCreating: false);
      } else {
        state = state.copyWith(isCreating: false, error: 'Failed to create log');
      }
    } catch (e) {
      state = state.copyWith(isCreating: false, error: e.toString());
    }
  }
}

final bodyLogProvider = StateNotifierProvider<BodyLogNotifier, BodyLogState>((ref) {
  final serviceManager = ref.watch(integratedServiceManagerProvider);
  return BodyLogNotifier(serviceManager);
});