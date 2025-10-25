import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalInvitations {
  static const String _key = 'saved_invitations';

  // ✅ Save list of invitations
  static Future<void> saveInvitations(List<Map<String, dynamic>> invitations) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = invitations.map((item) {
      final temp = Map<String, dynamic>.from(item);
      if (temp['date'] is DateTime) {
        temp['date'] = (temp['date'] as DateTime).toIso8601String();
      }
      return temp;
    }).toList();

    await prefs.setString(_key, jsonEncode(encodedList));
  }

  // ✅ Load saved invitations
  static Future<List<Map<String, dynamic>>> loadInvitations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map<Map<String, dynamic>>((item) {
      final temp = Map<String, dynamic>.from(item);
      if (temp['date'] != null) {
        temp['date'] = DateTime.parse(temp['date']);
      }
      return temp;
    }).toList();
  }

  // ✅ Clear invitations
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
