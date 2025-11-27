import 'package:admin_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapConstants {
  static const LatLng initialPosition = LatLng(30.0444, 31.2357);
  static const String mapUrl =
      "https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=S3MPSGbrr5xZYGIlMOp3";
  static const Color primaryColor = AppColor.mainBlue;
}
