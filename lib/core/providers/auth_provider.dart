import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/service_manager.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;

  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(status: AuthStatus.initial)) {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Initialize with unauthenticated state
    // Auth is now handled through ConvexService and AuthService
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setAuthenticated(UserModel user) {
    state = AuthState(status: AuthStatus.authenticated, user: user);
  }

  void setUnauthenticated() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setLoading() {
    state = state.copyWith(status: AuthStatus.loading);
  }

  void setError(String message) {
    state = state.copyWith(status: AuthStatus.error, errorMessage: message);
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final convexService = ServiceManager.instance.convexService;
      final response = await convexService.query('users:getById', {'userId': userId});
      
      final user = UserModel.fromJson(response as Map<String, dynamic>);
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Failed to load user profile: $e',
      );
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final convexService = ServiceManager.instance.convexService;
      final response = await convexService.mutation('auth:signIn', {
        'email': email,
        'password': password,
      });

      if (response != null && response['userId'] != null) {
        await _loadUserProfile(response['userId'] as String);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final convexService = ServiceManager.instance.convexService;
      final response = await convexService.mutation('auth:signUp', {
        'email': email,
        'password': password,
        'name': name,
      });

      if (response != null && response['userId'] != null) {
        await _loadUserProfile(response['userId'] as String);
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> signOut() async {
    try {
      state = const AuthState(status: AuthStatus.unauthenticated);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Failed to sign out: $e',
      );
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    if (state.user == null) return;

    try {
      final convexService = ServiceManager.instance.convexService;
      await convexService.mutation('users:update', {
        'userId': state.user!.id,
        'name': updatedUser.name,
        'phone': updatedUser.phone,
        'dateOfBirth': updatedUser.dateOfBirth?.toIso8601String(),
        'gender': updatedUser.gender,
        'height': updatedUser.height,
        'weight': updatedUser.weight,
        'sport': updatedUser.sport,
        'level': updatedUser.level,
      });

      state = state.copyWith(user: updatedUser);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update profile: $e',
      );
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});
