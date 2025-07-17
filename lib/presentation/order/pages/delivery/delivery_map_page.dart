import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../l10n/app_localizations.dart';

class DeliveryMapPage extends StatefulWidget {
  const DeliveryMapPage({super.key});

  @override
  State<DeliveryMapPage> createState() => _DeliveryMapPageState();
}

class _DeliveryMapPageState extends State<DeliveryMapPage> {
  LatLng? selectedPoint;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  final MapController _mapController = MapController();

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;
    setState(() => _isSearching = true);
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=5');
    final response = await http.get(url, headers: {'User-Agent': 'FlutterApp'});
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _searchResults = data.cast<Map<String, dynamic>>();
        _isSearching = false;
      });
    } else {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Pengiriman'),
        actions: [
          if (selectedPoint != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, selectedPoint);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchAddress,
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () =>
                            _searchLocation(_searchController.text),
                      ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
          if (_searchResults.isNotEmpty)
            SizedBox(
              height: 180,
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final item = _searchResults[index];
                  return ListTile(
                    title: Text(item['display_name'] ?? ''),
                    onTap: () {
                      final lat = double.tryParse(item['lat'] ?? '') ?? 0.0;
                      final lon = double.tryParse(item['lon'] ?? '') ?? 0.0;
                      final newPoint = LatLng(lat, lon);
                      setState(() {
                        selectedPoint = newPoint;
                        _searchResults = [];
                        _searchController.text = item['display_name'] ?? '';
                      });
                      // Animate map to the selected location
                      _mapController.move(newPoint, 13.0);
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: selectedPoint ?? const LatLng(-6.208763, 106.845599),
                initialZoom: 10.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedPoint = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // urlTemplate:
                  //     'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  // subdomains: const ['a', 'b', 'c'],
                ),
                if (selectedPoint != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: selectedPoint!,
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedPoint != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${AppLocalizations.of(context)!.location} : ${selectedPoint!.latitude}, ${selectedPoint!.longitude}',
                textAlign: TextAlign.center,
              ),
            )
          : null,
    );
  }
}
