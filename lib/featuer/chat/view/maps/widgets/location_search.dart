import 'package:admin_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:latlong2/latlong.dart';


class LocationSearch extends StatefulWidget {
  final Function(LatLng) onLocationSelected;
  const LocationSearch({super.key, required this.onLocationSelected});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;
  Timer? _debounce;

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _search(value));
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=5');
      final response = await http.get(url, headers: {'User-Agent': 'FlutterMapPickerApp/1.0'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() => _results = data.cast<Map<String, dynamic>>());
      }
    } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColor.mainWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Search places...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _results = []);
                      },
                    )
                  : null,
              border: InputBorder.none,
            ),
            onChanged: _onChanged,
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        if (_results.isNotEmpty)
  Container(
    margin: const EdgeInsets.only(top: 8),
    
    decoration: BoxDecoration(
      color: AppColor.mainWhite, // <-- white background
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _results[index];
        final lat = double.parse(item['lat']);
        final lon = double.parse(item['lon']);
        final name = item['display_name'] ?? '';
        return ListTile(
          leading: const Icon(Icons.place, color: Colors.blue),
          title: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => widget.onLocationSelected(LatLng(lat, lon)),
        );
      },
    ),
  ),

      ],
    );
  }
}
