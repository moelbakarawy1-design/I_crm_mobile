import 'package:flutter/material.dart';

/// Constants for Location Widget
class LocationWidgetConstants {
  LocationWidgetConstants._();

  // Animation Durations
  static const Duration hoverAnimationDuration = Duration(milliseconds: 300);
  static const Duration pulseAnimationDuration = Duration(milliseconds: 2000);

  // Colors
  static const Color primaryBlue = Color(0xFF1366D9);
  static const Color primaryPurple = Color(0xFF4C4DDC);
  static const Color accentRed = Color(0xFFEF4444);
  static const Color accentRedDark = Color(0xFFDC2626);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color borderGray = Color(0xFFE5E7EB);
  static const Color textGray = Color(0xFF6B7280);
  static const Color textDark = Color(0xFF1F2937);
  static const Color backgroundWhite = Color(0xFFF9F9F9);

  // Sizes
  static const double containerWidth = 240;
  static const double containerHeight = 180;
  static const double borderRadius = 20;
  static const double borderWidth = 2;
  static const double contentPadding = 14;
  
  // Icon Sizes
  static const double headerIconSize = 20;
  static const double locationPinSize = 20;
  static const double arrowIconSize = 18;
  static const double liveIndicatorSize = 6;
  
  // Badge
  static const double badgeHorizontalPadding = 10;
  static const double badgeVerticalPadding = 5;
  static const double badgeBorderRadius = 8;
  
  // Location Pin
  static const double pinContainerPadding = 8;
  static const double pinPulseSize = 50;
  static const double pinBlurRadius = 12;
  
  // Grid
  static const double gridSize = 20.0;
  static const double gridStrokeWidth = 1.0;
  
  // Animation Values
  static const double pulseScaleMin = 1.0;
  static const double pulseScaleMax = 1.15;
  static const double pulseOpacityDivisor = 0.2;
  
  // Shadow
  static const double shadowBlurRadiusNormal = 16;
  static const double shadowBlurRadiusHover = 24;
  static const double shadowOffsetYNormal = 4;
  static const double shadowOffsetYHover = 8;
  static const double shadowSpreadRadiusNormal = -2;
  static const double shadowSpreadRadiusHover = 0;
  
  // Text
  static const String liveText = 'Live';
  static const String locationLabel = 'Location';
  static const String invalidLocationText = 'Invalid Location';
  
  // Coordinate Display
  static const int coordinateDecimalPlaces = 4;
}