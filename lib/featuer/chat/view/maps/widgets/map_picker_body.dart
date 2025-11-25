import 'package:admin_app/core/theme/app_color.dart';
import 'package:admin_app/core/widgets/cusstom_btn_widget.dart';
import 'package:admin_app/featuer/chat/view/maps/helper/map_constants.dart';
// import 'package:admin_app/featuer/chat/view/maps/widgets/location_card.dart';
import 'package:admin_app/featuer/chat/view/maps/widgets/location_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapPickerBody extends StatefulWidget {
  const MapPickerBody({super.key});

  @override
  State<MapPickerBody> createState() => _MapPickerBodyState();
}

class _MapPickerBodyState extends State<MapPickerBody> {
  final MapController _mapController = MapController();
  LatLng _selectedPosition = MapConstants.initialPosition;

  void _selectLocation(LatLng position) {
    setState(() {
      _selectedPosition = position;
    });
    _mapController.move(position, 16);
  }

  void _confirmLocation() {
    Navigator.of(context).pop({
      'lat': _selectedPosition.latitude,
      'long': _selectedPosition.longitude,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedPosition,
            initialZoom: 14,
            onTap: (tapPos, point) => _selectLocation(point),
          ),
          children: [
            TileLayer(urlTemplate: MapConstants.mapUrl, userAgentPackageName: "com.example.app"),
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedPosition,
                  width: 50,
                  height: 50,
                  alignment: Alignment.topCenter,
                  child: const Icon(Icons.location_on, color: Colors.red, size: 50),
                ),
              ],
            ),
          ],
        ),
        // Search Box
        Positioned(top: 50, left: 16, right: 16, child: LocationSearch(onLocationSelected: _selectLocation)),
        // Location Info Card
        // Positioned(bottom: 16, left: 16, right: 16, child: LocationCard(selectedPosition: _selectedPosition)),
        // Confirm Button
        Positioned(
          right: 16,
          bottom: 30,
          left:16,
          child: CustomButton(
            backgroundColor: AppColor.lightBlue,
            text:"Confirm Location", onPressed: _confirmLocation, width: 200, height: 50,
          ),
        ),
      ],
    );
  }
}
