import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  // Sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
    Map<String, dynamic> userMetadata,
  ) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: userMetadata,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Get current session
  Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }

  // Listen to auth state changes
  Stream<AuthState> get onAuthStateChange {
    return _supabase.auth.onAuthStateChange;
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  // Update user metadata
  Future<UserResponse> updateUserMetadata(Map<String, dynamic> metadata) async {
    return await _supabase.auth.updateUser(
      UserAttributes(data: metadata),
    );
  }

  // Delete user account
  Future<void> deleteAccount() async {
    final user = getCurrentUser();
    if (user != null) {
      await _supabase.auth.admin.deleteUser(user.id);
    }
  }
}
