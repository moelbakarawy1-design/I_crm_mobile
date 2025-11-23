import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'location_widget_constants.dart';

/// Styles for Location Widget
class LocationWidgetStyles {
  LocationWidgetStyles._();

  // Container Decorations
  static BoxDecoration getContainerDecoration(bool isHovered) {
    return BoxDecoration(
      gradient: _getBackgroundGradient(isHovered),
      borderRadius: BorderRadius.circular(
        LocationWidgetConstants.borderRadius.r,
      ),
      border: Border.all(
        color: _getBorderColor(isHovered),
        width: LocationWidgetConstants.borderWidth,
      ),
      boxShadow: _getContainerShadows(isHovered),
    );
  }

  static LinearGradient _getBackgroundGradient(bool isHovered) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isHovered
          ? [
              LocationWidgetConstants.primaryBlue.withOpacity(0.95),
              LocationWidgetConstants.primaryPurple.withOpacity(0.95),
            ]
          : [
              Colors.white,
              LocationWidgetConstants.backgroundWhite,
            ],
    );
  }

  static Color _getBorderColor(bool isHovered) {
    return isHovered
        ? LocationWidgetConstants.primaryBlue.withOpacity(0.5)
        : LocationWidgetConstants.borderGray;
  }

  static List<BoxShadow> _getContainerShadows(bool isHovered) {
    return [
      BoxShadow(
        color: isHovered
            ? LocationWidgetConstants.primaryBlue.withOpacity(0.3)
            : Colors.black.withOpacity(0.06),
        blurRadius: isHovered
            ? LocationWidgetConstants.shadowBlurRadiusHover
            : LocationWidgetConstants.shadowBlurRadiusNormal,
        offset: Offset(
          0,
          isHovered
              ? LocationWidgetConstants.shadowOffsetYHover.toDouble()
              : LocationWidgetConstants.shadowOffsetYNormal.toDouble(),
        ),
        spreadRadius: isHovered
            ? LocationWidgetConstants.shadowSpreadRadiusHover.toDouble()
            : LocationWidgetConstants.shadowSpreadRadiusNormal.toDouble(),
      ),
      if (isHovered)
        BoxShadow(
          color: LocationWidgetConstants.primaryPurple.withOpacity(0.2),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
    ];
  }

  // Header Icon Decoration
  static BoxDecoration getHeaderIconDecoration(bool isHovered) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isHovered
            ? [
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.1),
              ]
            : [
                LocationWidgetConstants.primaryBlue.withOpacity(0.15),
                LocationWidgetConstants.primaryPurple.withOpacity(0.15),
              ],
      ),
      borderRadius: BorderRadius.circular(12.r),
    );
  }

  // Live Badge Decoration
  static BoxDecoration getLiveBadgeDecoration(bool isHovered) {
    return BoxDecoration(
      color: isHovered
          ? Colors.white.withOpacity(0.2)
          : LocationWidgetConstants.accentGreen.withOpacity(0.15),
      borderRadius: BorderRadius.circular(
        LocationWidgetConstants.badgeBorderRadius.r,
      ),
      border: Border.all(
        color: isHovered
            ? Colors.white.withOpacity(0.3)
            : LocationWidgetConstants.accentGreen.withOpacity(0.3),
        width: 1,
      ),
    );
  }

  // Location Pin Decoration
  static BoxDecoration getLocationPinDecoration(bool isHovered) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isHovered
            ? [Colors.white, Colors.white]
            : [
                LocationWidgetConstants.accentRed,
                LocationWidgetConstants.accentRedDark,
              ],
      ),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: (isHovered ? Colors.white : LocationWidgetConstants.accentRed)
              .withOpacity(0.4),
          blurRadius: LocationWidgetConstants.pinBlurRadius,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Pulse Effect Decoration
  static BoxDecoration getPulseDecoration(bool isHovered, double scale) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: (isHovered ? Colors.white : LocationWidgetConstants.accentRed)
          .withOpacity(LocationWidgetConstants.pulseOpacityDivisor / scale),
    );
  }

  // Text Styles
  static TextStyle getLiveBadgeTextStyle(bool isHovered) {
    return TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w700,
      color: isHovered ? Colors.white : LocationWidgetConstants.accentGreen,
    );
  }

  static TextStyle getLocationLabelTextStyle(bool isHovered) {
    return TextStyle(
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: isHovered
          ? Colors.white.withOpacity(0.7)
          : LocationWidgetConstants.textGray,
      letterSpacing: 0.5,
    );
  }

  static TextStyle getCoordinatesTextStyle(bool isHovered) {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      color: isHovered ? Colors.white : LocationWidgetConstants.textDark,
    );
  }

  // Icon Colors
  static Color getHeaderIconColor(bool isHovered) {
    return isHovered ? Colors.white : LocationWidgetConstants.primaryBlue;
  }

  static Color getLocationPinIconColor(bool isHovered) {
    return isHovered
        ? LocationWidgetConstants.primaryBlue
        : Colors.white;
  }

  static Color getArrowIconColor(bool isHovered) {
    return isHovered ? Colors.white : LocationWidgetConstants.primaryBlue;
  }

  static Color getLiveIndicatorColor(bool isHovered) {
    return isHovered ? Colors.white : LocationWidgetConstants.accentGreen;
  }

  // Grid Color
  static Color getGridColor(bool isHovered) {
    return isHovered
        ? Colors.white.withOpacity(0.1)
        : LocationWidgetConstants.borderGray.withOpacity(0.3);
  }
}