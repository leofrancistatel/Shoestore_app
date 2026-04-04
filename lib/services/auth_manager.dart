import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  static const String _keyLoggedIn = "logged_in";
  static const String _keyEmail = "email";
  static const String _keyName = "name";
  static const String _keyPassword = "password";

  static SharedPreferences? _prefs;

  static Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// =========================
  /// REGISTER USER (Sign Up)
  /// =========================
  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await _getPrefs();

    final existingEmail = prefs.getString(_keyEmail);

    if (existingEmail != null && existingEmail == email) {
      // User already exists
      return false;
    }

    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyPassword, password);

    return true;
  }

  /// =========================
  /// LOGIN USER
  /// =========================
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await _getPrefs();

    final storedEmail = prefs.getString(_keyEmail);
    final storedPassword = prefs.getString(_keyPassword);

    if (email == storedEmail && password == storedPassword) {
      await prefs.setBool(_keyLoggedIn, true);
      return true;
    }

    return false;
  }

  /// =========================
  /// SAVE LOGIN (Used after successful login)
  /// =========================
  static Future<void> saveLogin({
    required String email,
    required String name,
  }) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyLoggedIn, true);
    await prefs.setString(_keyEmail, email);
    await prefs.setString(_keyName, name);
  }

  /// =========================
  /// LOGOUT
  /// =========================
  static Future<void> logout() async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyLoggedIn, false);
  }

  /// =========================
  /// CHECK LOGIN STATUS
  /// =========================
  static Future<bool> isLoggedIn() async {
    final prefs = await _getPrefs();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<String?> getEmail() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getName() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyName);
  }

  static Future<String?> getPassword() async {
    final prefs = await _getPrefs();
    return prefs.getString(_keyPassword);
  }

  /// First name only
  static Future<String?> getFirstName() async {
    final name = await getName();
    if (name == null || name.trim().isEmpty) return null;
    return name.trim().split(" ").first;
  }
}
