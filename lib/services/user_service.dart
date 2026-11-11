// lib/services/user_service.dart
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _currentUserKey = "current_user_id";

  /// Save current user ID
  static Future<void> setCurrentUser(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentUserKey, userId);
  }

  /// Get current user ID
  /// Returns null if no user is logged in
  static Future<int?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentUserKey);
  }

  /// Check if a user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_currentUserKey);
  }

  /// Log out current user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}
