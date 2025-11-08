import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static String? accessToken;
  static String? refreshToken;
  
  static const _storage = FlutterSecureStorage();
static const _accessTokenKey = 'ACCESS_TOKEN';
static const _refreshTokenKey = 'REFRESH_TOKEN';


  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';

  static Future<void> init() async {
    // Load tokens from secure storage
    accessToken = await _storage.read(key: _accessTokenKey);
    refreshToken = await _storage.read(key: _refreshTokenKey);
    print('🔹 Tokens loaded on startup:');
  print('   Access: $accessToken');
  print('   Refresh: $refreshToken');
  }

  static Future<void> saveTokens({
  required String accessToken,
  String? refreshToken,
}) async {
  print('💾 Saving Tokens...');
  print('   Access: $accessToken');
  print('   Refresh: $refreshToken');

  LocalData.accessToken = accessToken;
  LocalData.refreshToken = refreshToken;

  await _storage.write(key: _accessTokenKey, value: accessToken);
  if (refreshToken != null) {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // Check right after writing
  final verifyAccess = await _storage.read(key: _accessTokenKey);
  final verifyRefresh = await _storage.read(key: _refreshTokenKey);
  print('✅ Verified saved tokens:');
  print('   Access: $verifyAccess');
  print('   Refresh: $verifyRefresh');
}


  static Future<void> clear() async {
    LocalData.accessToken = null;
    LocalData.refreshToken = null;

    // Clear secure tokens
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    // ✅ FIX: Clear user data as well
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
  }

  // --- UserData methods can stay the same ---
  static Future<void> saveUserData({
    required String userId,
    required String userName,
    required String userEmail,
    required String userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userEmailKey, userEmail);
    await prefs.setString(_userRoleKey, userRole);
  }

  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'userName': prefs.getString(_userNameKey),
      'userEmail': prefs.getString(_userEmailKey),
      'userRole': prefs.getString(_userRoleKey),
    };
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  static Future<bool> hasPermission(List<String> allowedRoles) async {
    final role = await getUserRole();
    if (role == null) return false;
    return allowedRoles.map((r) => r.toLowerCase()).contains(role.toLowerCase());
  }
}