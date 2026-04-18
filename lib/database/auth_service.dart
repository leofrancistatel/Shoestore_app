import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const _keyEmail = "email";
  static const _keyPassword = "password";
  static const _keyName = "name";
  static const _keyLoggedIn = "loggedIn";

  /// REGISTER USER
  static Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);
  }

  /// SAVE LOGIN STATE
  static Future<void> saveLogin({
    required String email,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPassword);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }
}
