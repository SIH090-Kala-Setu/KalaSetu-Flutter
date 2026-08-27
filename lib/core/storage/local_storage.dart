import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  LocalStorage(this._secureStorage, this._prefs);

  static const String _keyToken = 'jwt_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyRole = 'user_role';
  static const String _keyUserName = 'user_full_name';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsVerified = 'is_verified';
  static const String _keyLanguage = 'selected_language';
  static const String _keyFirstLaunch = 'is_first_launch';

  // --- Secure Storage (Tokens & Auth) ---

  Future<void> saveTokens({required String accessToken, String? refreshToken}) async {
    await _secureStorage.write(key: _keyToken, value: accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _keyRefreshToken);
  }

  Future<void> saveUserSession({
    required String token,
    required String role,
    String? fullName,
    String? phone,
    bool isVerified = false,
  }) async {
    await _secureStorage.write(key: _keyToken, value: token);
    await _prefs.setString(_keyRole, role);
    if (fullName != null) await _prefs.setString(_keyUserName, fullName);
    if (phone != null) await _prefs.setString(_keyUserPhone, phone);
    await _prefs.setBool(_keyIsVerified, isVerified);
  }

  String? getUserRole() {
    return _prefs.getString(_keyRole);
  }

  String? getUserName() {
    return _prefs.getString(_keyUserName);
  }

  String? getUserPhone() {
    return _prefs.getString(_keyUserPhone);
  }

  bool isUserVerified() {
    return _prefs.getBool(_keyIsVerified) ?? false;
  }

  Future<void> clearAuthSession() async {
    await _secureStorage.delete(key: _keyToken);
    await _secureStorage.delete(key: _keyRefreshToken);
    await _prefs.remove(_keyRole);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserPhone);
    await _prefs.remove(_keyIsVerified);
  }

  // --- Shared Preferences (Preferences) ---

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_keyLanguage, languageCode);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'hi'; // Default to Hindi
  }

  Future<void> setFirstLaunchCompleted() async {
    await _prefs.setBool(_keyFirstLaunch, false);
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }
}
