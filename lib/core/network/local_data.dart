import 'package:admin_app/core/helper/enum_permission.dart';
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
  
  // Key for Permissions List
  static const String _userPermissionsKey = 'user_permissions'; 

  static Future<void> init() async {
    accessToken = await _storage.read(key: _accessTokenKey);
    refreshToken = await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    LocalData.accessToken = accessToken;
    LocalData.refreshToken = refreshToken;
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  static Future<void> clear() async {
    LocalData.accessToken = null;
    LocalData.refreshToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userPermissionsKey);
  }

  static Future<void> saveUserData({
    required String userId,
    required String userName,
    required String userEmail,
    required String userRole,
    List<String>? permissions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userEmailKey, userEmail);
    await prefs.setString(_userRoleKey, userRole);
    
    if (permissions != null) {
      await prefs.setStringList(_userPermissionsKey, permissions);
      // 🟢 UPDATED LOG: Prints the actual list
      print("✅ Permissions Saved: $permissions"); 
    }
  }

  // � Update only role and permissions (for real-time role updates)
  static Future<void> updateRoleAndPermissions({
    required String userRole,
    required List<String> permissions,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, userRole);
    await prefs.setStringList(_userPermissionsKey, permissions);
    
    print("🔄 [LocalData] Role updated to: $userRole");
    print("🔑 [LocalData] Permissions updated: $permissions");
  }

  // �🟢 NEW HELPER: Call this anywhere to check what's currently saved
  static Future<void> debugPrintAllPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedPermissions = prefs.getStringList(_userPermissionsKey);
    
    print("\n--------------------------------------------------");
    print("🛠️ DEBUG: CURRENTLY STORED PERMISSIONS");
    print("--------------------------------------------------");
    if (storedPermissions == null || storedPermissions.isEmpty) {
      print("❌ No permissions found in storage.");
    } else {
      print("✅ Found ${storedPermissions.length} permissions:");
      for (var p in storedPermissions) {
        print("   🔹 $p");
      }
    }
    print("--------------------------------------------------\n");
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

  static Future<bool> hasEnumPermission(Permission requiredPermission) async {
    final prefs = await SharedPreferences.getInstance();

    // Check the actual list saved from Backend
    final List<String>? storedPermissions = prefs.getStringList(_userPermissionsKey);
    
    if (storedPermissions != null && storedPermissions.isNotEmpty) {
      final hasPermission = storedPermissions.contains(requiredPermission.name);
      return hasPermission;
    }

    print("❌ Access Denied: No stored permissions found.");
    return false;
  }
}