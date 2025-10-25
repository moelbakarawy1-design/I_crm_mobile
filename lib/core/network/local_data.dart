import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static String? accessToken;
  static String? refreshToken;

  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userRoleKey = 'user_role';

  // Initialize from SharedPreferences
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(_accessTokenKey);
    refreshToken = prefs.getString(_refreshTokenKey);
  }

  // Save tokens
  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    LocalData.accessToken = accessToken;
    LocalData.refreshToken = refreshToken;

    await prefs.setString(_accessTokenKey, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  // Clear tokens (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    LocalData.accessToken = null;
    LocalData.refreshToken = null;
  }
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

  // ✅ الحصول على بيانات المستخدم
  static Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'userName': prefs.getString(_userNameKey),
      'userEmail': prefs.getString(_userEmailKey),
      'userRole': prefs.getString(_userRoleKey),
    };
  }

  // ✅ الحصول على الـ Role
  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }
  // ✅ التحقق من الصلاحية
  static Future<bool> hasPermission(List<String> allowedRoles) async {
    final role = await getUserRole();
    if (role == null) return false;
    return allowedRoles.map((r) => r.toLowerCase()).contains(role.toLowerCase());
  }

}
