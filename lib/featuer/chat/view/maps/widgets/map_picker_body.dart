import 'dart:ui';
import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/featuer/chat/view/maps/helper/map_constants.dart';
import 'package:admin_app/featuer/chat/view/maps/widgets/location_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class MapPickerBody extends StatefulWidget {
  const MapPickerBody({super.key});

  @override
  State<MapPickerBody> createState() => _MapPickerBodyState();
}

class _MapPickerBodyState extends State<MapPickerBody>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  LatLng _selectedPosition = MapConstants.initialPosition;
  late AnimationController _markerAnimController;
  late Animation<double> _markerAnimation;

  @override
  void initState() {
    super.initState();
    _markerAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _markerAnimation = CurvedAnimation(
      parent: _markerAnimController,
      curve: Curves.elasticOut,
    );
    _markerAnimController.forward();
  }

  @override
  void dispose() {
    _markerAnimController.dispose();
    super.dispose();
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
    _mapController.move(position, 16);
    _markerAnimController.forward(from: 0);
  }

  void _confirmLocation() {
    Navigator.of(context).pop({
      'lat': _selectedPosition.latitude,
      'long': _selectedPosition.longitude,
    });
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_selectedPosition, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_selectedPosition, currentZoom - 1);
  }

  void _centerOnLocation() {
    _mapController.move(_selectedPosition, 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPosition,
              initialZoom: 14,
              minZoom: 3,
              maxZoom: 18,
              onTap: (tapPos, point) => _selectLocation(point),
            ),
            children: [
              TileLayer(
                urlTemplate: MapConstants.mapUrl,
                userAgentPackageName: "com.example.app",
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPosition,
                    width: 60.w,
                    height: 60.h,
                    alignment: Alignment.topCenter,
                    child: ScaleTransition(
                      scale: _markerAnimation,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: AppColor.lightBlue,
                              size: 32.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Glassmorphism Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.h,
            left: 16.w,
            right: 16.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: LocationSearch(onLocationSelected: _selectLocation),
                ),
              ),
            ),
          ),

          // Floating Action Buttons - Right Side
          Positioned(
            right: 16.w,
            bottom: 180.h,
            child: Column(
              children: [
                _buildFloatingButton(
                  icon: Icons.add,
                  onTap: _zoomIn,
                  tooltip: 'Zoom In',
                ),
                SizedBox(height: 12.h),
                _buildFloatingButton(
                  icon: Icons.remove,
                  onTap: _zoomOut,
                  tooltip: 'Zoom Out',
                ),
                SizedBox(height: 12.h),
                _buildFloatingButton(
                  icon: Icons.my_location,
                  onTap: _centerOnLocation,
                  tooltip: 'Center',
                ),
              ],
            ),
          ),

          // Modern Confirm Button
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 30.h,
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.lightBlue,
                    AppColor.lightBlue.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.lightBlue.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: _confirmLocation,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Confirm Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.h,
            left: 16.w,
            child: _buildFloatingButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.of(context).pop(),
              tooltip: 'Back',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: onTap,
            child: Icon(icon, color: AppColor.lightBlue, size: 24.sp),
          ),
        ),
      ),
    );
  }
}
