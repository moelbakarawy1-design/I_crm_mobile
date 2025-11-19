import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // يفضل استخدام intl لتنسيق الوقت بشكل أدق

class ChatUtils {
  static String formatTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateTimeString).toLocal();
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return '';
    }
  }

  static String getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'SENT': return 'SENT ✓';
      case 'DELIVERED': return 'DELIVERED ✓✓';
      case 'READ': return 'Seen ✓✓';
      case 'FAILED': return 'FAILED ✗';
      default: return status;
    }
  }

  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SENT': return Colors.grey;
      case 'DELIVERED': return Colors.blueGrey;
      case 'READ': return Colors.blue;
      case 'FAILED': return Colors.red;
      default: return Colors.grey;
    }
  }
}