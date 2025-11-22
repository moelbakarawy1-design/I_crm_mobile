import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskHelper {
  static String formatDateString(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      final DateFormat formatter = DateFormat('MMM dd');
      return formatter.format(parsedDate);
    } catch (e) {
      return dateString;
    }
  }

  static String formatTaskDate(String? start, String? end) {
    final String startDate = formatDateString(start);
    final String endDate = formatDateString(end);
    return '$startDate to $endDate';
  }

  static Map<String, dynamic> getStatusInfo(String? status) {
    switch (status?.toUpperCase()) {
      case 'IN_PROGRESS':
        return {
          'icon': Icons.hourglass_empty,
          'color': Colors.orange,
          'label': 'In Progress',
        };

      case 'COMPLETED':
        return {
          'icon': Icons.check_circle_outline,
          'color': Colors.green,
          'label': 'Completed',
        };

      case 'OVERDUE':
        return {
          'icon': Icons.warning_amber_rounded,
          'color': Colors.red,
          'label': 'Overdue',
        };

      default:
        return {
          'icon': Icons.info_outline,
          'color': Colors.grey,
          'label': 'Unknown',
        };
    }
  }
}