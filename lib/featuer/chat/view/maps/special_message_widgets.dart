import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

// Location Widget
class LocationMessageWidget extends StatelessWidget {
  final String locationContent; // Expected format: "lat,long"

  const LocationMessageWidget({super.key, required this.locationContent});

  Future<void> _openMap() async {
    final parts = locationContent.split(',');
    if (parts.length < 2) return;

    final lat = parts[0].trim();
    final long = parts[1].trim();

    // Opens Google Maps App or Browser
    final Uri googleMapsUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$long");

    try {
      if (!await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication)) {
        debugPrint("Could not launch maps");
      }
    } catch (e) {
      debugPrint("Error launching maps: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMap,
      child: Container(
        width: 220.w,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.map_outlined, size: 60, color: Colors.grey.shade300),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 32),
                SizedBox(height: 4.h),
                Text(
                  "Open Map",
                  style: TextStyle(
                    color: Colors.blue[700], 
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}