import 'package:admin_app/featuer/chat/view/maps/widgets/location_widget_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationWidgetHelpers {
  LocationWidgetHelpers._();

  static String formatCoordinates(String locationContent) {
    final parts = locationContent.split(',');
    if (parts.length < 2) {
      return LocationWidgetConstants.invalidLocationText;
    }

    final lat = double.tryParse(parts[0].trim());
    final long = double.tryParse(parts[1].trim());

    if (lat == null || long == null) {
      return LocationWidgetConstants.invalidLocationText;
    }

    return '${lat.toStringAsFixed(LocationWidgetConstants.coordinateDecimalPlaces)}°, '
        '${long.toStringAsFixed(LocationWidgetConstants.coordinateDecimalPlaces)}°';
  }

  /// Validate location content format
  static bool isValidLocation(String locationContent) {
    final parts = locationContent.split(',');
    if (parts.length < 2) return false;

    final lat = double.tryParse(parts[0].trim());
    final long = double.tryParse(parts[1].trim());

    return lat != null && long != null;
  }

  static Future<void> openMap(String locationContent) async {
    final parts = locationContent.split(',');
    if (parts.length < 2) return;

    final lat = parts[0].trim();
    final long = parts[1].trim();

    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$long",
    );

    try {
      if (!await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      )) {
        debugPrint("Could not launch Google Maps");
      }
    } catch (e) {
      debugPrint("Error launching maps: $e");
    }
  }

  static double? getLatitude(String locationContent) {
    final parts = locationContent.split(',');
    if (parts.isEmpty) return null;
    return double.tryParse(parts[0].trim());
  }

  static double? getLongitude(String locationContent) {
    final parts = locationContent.split(',');
    if (parts.length < 2) return null;
    return double.tryParse(parts[1].trim());
  }
}