import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

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
  final SupabaseClient _supabase;

  AuthNotifier(this._supabase) : super(const AuthState(status: AuthStatus.initial)) {
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    _supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session?.user != null) {
        _loadUserProfile(session!.user.id);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated);
      }
    });

    // Check current session
    final currentUser = _supabase.auth.currentUser;
    if (currentUser != null) {
      _loadUserProfile(currentUser.id);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      final user = UserModel.fromJson(response);
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
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadUserProfile(response.user!.id);
      }
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
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
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user != null) {
        // Create user profile
        await _createUserProfile(response.user!.id, email, name);
        await _loadUserProfile(response.user!.id);
      }
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      );
    }
  }

  Future<void> _createUserProfile(String userId, String email, String name) async {
    final profileData = {
      'id': userId,
      'email': email,
      'name': name,
      'credits': 100, // Starting credits
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };

    await _supabase.from('profiles').insert(profileData);
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
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
      final updateData = {
        'name': updatedUser.name,
        'phone': updatedUser.phone,
        'date_of_birth': updatedUser.dateOfBirth?.toIso8601String(),
        'gender': updatedUser.gender,
        'height': updatedUser.height,
        'weight': updatedUser.weight,
        'sport': updatedUser.sport,
        'level': updatedUser.level,
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('profiles')
          .update(updateData)
          .eq('id', state.user!.id);

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
  final supabase = Supabase.instance.client;
  return AuthNotifier(supabase);
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authProvider);
  return authState.status == AuthStatus.authenticated;
});
