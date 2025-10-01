// lib/core/services/auth_persistence_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthPersistenceService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';
  static const String _keyLastLoginDate = 'last_login_date';
  static const String _keyDailyBonusShown = 'daily_bonus_shown';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';

  static SharedPreferences? _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Authentication State Management
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    await init();
    await _prefs!.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    await init();
    return _prefs!.getBool(_keyIsLoggedIn) ?? false;
  }

  // User Data Management
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    await init();
    final userDataJson = json.encode(userData);
    await _prefs!.setString(_keyUserData, userDataJson);
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    await init();
    final userDataJson = _prefs!.getString(_keyUserData);
    if (userDataJson != null) {
      return json.decode(userDataJson) as Map<String, dynamic>;
    }
    return null;
  }

  // Token Management
  static Future<void> saveAuthToken(String token) async {
    await init();
    await _prefs!.setString(_keyAuthToken, token);
  }

  static Future<String?> getAuthToken() async {
    await init();
    return _prefs!.getString(_keyAuthToken);
  }

  static Future<void> saveRefreshToken(String token) async {
    await init();
    await _prefs!.setString(_keyRefreshToken, token);
  }

  static Future<String?> getRefreshToken() async {
    await init();
    return _prefs!.getString(_keyRefreshToken);
  }

  // Daily Login Bonus Management
  static Future<void> setLastLoginDate(DateTime date) async {
    await init();
    await _prefs!.setString(_keyLastLoginDate, date.toIso8601String());
  }

  static Future<DateTime?> getLastLoginDate() async {
    await init();
    final dateString = _prefs!.getString(_keyLastLoginDate);
    if (dateString != null) {
      return DateTime.parse(dateString);
    }
    return null;
  }

  static Future<bool> shouldShowDailyBonus() async {
    await init();
    
    final lastLoginDate = await getLastLoginDate();
    final today = DateTime.now();
    
    if (lastLoginDate == null) {
      // First time login - show bonus
      await setLastLoginDate(today);
      await setDailyBonusShown(true);
      return true;
    }
    
    // Check if it's a new day
    final isNewDay = !isSameDay(lastLoginDate, today);
    
    if (isNewDay) {
      await setLastLoginDate(today);
      await setDailyBonusShown(false); // Reset for new day
      return true;
    }
    
    // Same day - check if bonus already shown
    final bonusShown = await isDailyBonusShown();
    return !bonusShown;
  }

  static Future<void> setDailyBonusShown(bool shown) async {
    await init();
    await _prefs!.setBool(_keyDailyBonusShown, shown);
  }

  static Future<bool> isDailyBonusShown() async {
    await init();
    return _prefs!.getBool(_keyDailyBonusShown) ?? false;
  }

  // Helper method to check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  // Session Management
  static Future<void> createSession({
    required Map<String, dynamic> userData,
    String? authToken,
    String? refreshToken,
  }) async {
    await setLoggedIn(true);
    await saveUserData(userData);
    
    if (authToken != null) {
      await saveAuthToken(authToken);
    }
    
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    
    await setLastLoginDate(DateTime.now());
  }

  static Future<void> clearSession() async {
    await init();
    await _prefs!.remove(_keyIsLoggedIn);
    await _prefs!.remove(_keyUserData);
    await _prefs!.remove(_keyAuthToken);
    await _prefs!.remove(_keyRefreshToken);
    await _prefs!.remove(_keyLastLoginDate);
    await _prefs!.remove(_keyDailyBonusShown);
  }

  // Auto-login check
  static Future<bool> canAutoLogin() async {
    final isLoggedIn = await AuthPersistenceService.isLoggedIn();
    final userData = await getUserData();
    final authToken = await getAuthToken();
    
    // User must be logged in, have user data, and preferably have a valid token
    return isLoggedIn && userData != null && authToken != null;
  }

  // Logout
  static Future<void> logout() async {
    await clearSession();
  }

  // App settings related to login behavior
  static Future<void> setRememberMe(bool remember) async {
    await init();
    await _prefs!.setBool('remember_me', remember);
  }

  static Future<bool> getRememberMe() async {
    await init();
    return _prefs!.getBool('remember_me') ?? true; // Default to true
  }

  // Session validation
  static Future<bool> isSessionValid() async {
    if (!await isLoggedIn()) return false;
    
    final userData = await getUserData();
    if (userData == null) return false;
    
    // Additional validation can be added here
    // e.g., token expiry check, server validation, etc.
    
    return true;
  }

  // Update user data in session
  static Future<void> updateUserData(Map<String, dynamic> updates) async {
    final currentData = await getUserData();
    if (currentData != null) {
      currentData.addAll(updates);
      await saveUserData(currentData);
    }
  }

  // Get specific user field
  static Future<T?> getUserField<T>(String fieldName) async {
    final userData = await getUserData();
    return userData?[fieldName] as T?;
  }

  // Set specific user field
  static Future<void> setUserField(String fieldName, dynamic value) async {
    await updateUserData({fieldName: value});
  }
}