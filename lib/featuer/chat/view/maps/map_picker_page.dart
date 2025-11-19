import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  final Completer<GoogleMapController> _controller = Completer();
  
  // Default location (Cairo) until GPS loads
  LatLng _currentPosition = const LatLng(30.0444, 31.2357); 

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // 📍 Get Current User Location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Move camera to user
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentPosition, zoom: 15),
    ));
  }

  // 🟢 Send Location Back
  void _confirmLocation() {
    Navigator.pop(context, {
      "lat": _currentPosition.latitude,
      "long": _currentPosition.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. The Map
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.4746,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // We build our own
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            // Update position when map drags
            onCameraMove: (CameraPosition position) {
              _currentPosition = position.target;
            },
          ),

          // 2. Center Pin Icon (WhatsApp Style)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35.0), // Adjust for icon stem
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 45.sp,
              ),
            ),
          ),

          // 3. Search Bar (Visual Only - requires Places API for logic)
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                   BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search places...",
                        border: InputBorder.none,
                      ),
                      // To implement real search, you need Google Places API
                      onSubmitted: (val) {
                        print("Search for: $val"); 
                      },
                    ),
                  ),
                  const Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ),

          // 4. Bottom "Send" Button
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Column(
              children: [
                // My Location Button
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location, color: Colors.black),
                    onPressed: _determinePosition,
                  ),
                ),
                SizedBox(height: 15.h),
                
                // Send Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff075E54), // WhatsApp Green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: _confirmLocation,
                    child: const Text(
                      "Send this location",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}