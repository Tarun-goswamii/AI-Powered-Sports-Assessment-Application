// lib/core/providers/auth_state_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_persistence_service.dart';

// Auth state model
class AuthState {
  final bool isLoggedIn;
  final Map<String, dynamic>? userData;
  final String? authToken;
  final bool isLoading;

  const AuthState({
    required this.isLoggedIn,
    this.userData,
    this.authToken,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    Map<String, dynamic>? userData,
    String? authToken,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userData: userData ?? this.userData,
      authToken: authToken ?? this.authToken,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Auth state notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState(isLoggedIn: false)) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isLoggedIn = await AuthPersistenceService.isLoggedIn();
      final userData = await AuthPersistenceService.getUserData();
      final authToken = await AuthPersistenceService.getAuthToken();
      
      state = AuthState(
        isLoggedIn: isLoggedIn,
        userData: userData,
        authToken: authToken,
        isLoading: false,
      );
    } catch (e) {
      state = const AuthState(isLoggedIn: false, isLoading: false);
    }
  }

  Future<void> login({
    required Map<String, dynamic> userData,
    String? authToken,
    String? refreshToken,
  }) async {
    state = state.copyWith(isLoading: true);
    
    try {
      await AuthPersistenceService.createSession(
        userData: userData,
        authToken: authToken,
        refreshToken: refreshToken,
      );
      
      state = AuthState(
        isLoggedIn: true,
        userData: userData,
        authToken: authToken,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await AuthPersistenceService.logout();
      state = const AuthState(isLoggedIn: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    if (state.userData != null) {
      final updatedData = Map<String, dynamic>.from(state.userData!);
      updatedData.addAll(updates);
      
      await AuthPersistenceService.updateUserData(updates);
      state = state.copyWith(userData: updatedData);
    }
  }

  Future<bool> shouldShowDailyBonus() async {
    if (!state.isLoggedIn) return false;
    return await AuthPersistenceService.shouldShowDailyBonus();
  }

  Future<void> markDailyBonusShown() async {
    await AuthPersistenceService.setDailyBonusShown(true);
  }
}

// Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

// Helper providers
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoggedIn;
});

final currentUserProvider = Provider<Map<String, dynamic>?>((ref) {
  return ref.watch(authStateProvider).userData;
});

final authTokenProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).authToken;
});

final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).isLoading;
});