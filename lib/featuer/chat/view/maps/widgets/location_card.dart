import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';


class LocationCard extends StatelessWidget {
  final LatLng selectedPosition;
  const LocationCard({super.key, required this.selectedPosition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.primaryWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Lat: ${selectedPosition.latitude.toStringAsFixed(6)}, Lng: ${selectedPosition.longitude.toStringAsFixed(6)}',
              style: AppTextStyle.setpoppinsBlack(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
