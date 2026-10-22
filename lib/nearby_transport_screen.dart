import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class NearbyTransportScreen extends StatefulWidget {
  const NearbyTransportScreen({super.key});

  @override
  State<NearbyTransportScreen> createState() => _NearbyTransportScreenState();
}

class _NearbyTransportScreenState extends State<NearbyTransportScreen> {
  static const Color _bg = Color(0xFF070B18);
  static const Color _panel = Color(0xFF111A2E);
  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);

  final MapController _mapController = MapController();
  Position? _position;
  List<_NearbyPlace> _places = [];
  bool _loading = false;
  String? _error;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    _findNearby();
  }

  Future<void> _findNearby() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Please turn on Location/GPS on your device.');
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission was denied. Allow it to find nearby transport.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is blocked. Enable it in your device app settings.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _position = position;
      });

      _mapController.move(LatLng(position.latitude, position.longitude), 14);

      final places = await _loadPlaces(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _places = places;
        if (places.isEmpty) {
          _error = 'No nearby stops found in OpenStreetMap data. Try refreshing or check your internet connection.';
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<List<_NearbyPlace>> _loadPlaces(double lat, double lon) async {
    const endpoint = 'https://overpass-api.de/api/interpreter';
    final query =
        '''[out:json][timeout:25];
(
  node(around:5000,$lat,$lon)[highway=bus_stop];
  node(around:5000,$lat,$lon)[public_transport=platform][bus=yes];
  node(around:5000,$lat,$lon)[railway=station];
  node(around:5000,$lat,$lon)[railway=halt];
  way(around:5000,$lat,$lon)[railway=station];
  way(around:5000,$lat,$lon)[railway=halt];
);
out center tags;''';

    final response = await http
        .post(
          Uri.parse(endpoint),
          headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {'data': query},
        )
        .timeout(const Duration(seconds: 35));

    if (response.statusCode != 200) {
      throw Exception(
        'Map data service is busy. Please try again in a moment.',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final elements = decoded['elements'] as List<dynamic>? ?? [];
    final result = <_NearbyPlace>[];
    final seen = <String>{};

    for (final raw in elements) {
      final item = raw as Map<String, dynamic>;
      final tags = item['tags'] as Map<String, dynamic>? ?? {};
      final railway = tags['railway'] == 'station' || tags['railway'] == 'halt';
      final isBus =
          tags['highway'] == 'bus_stop' ||
          (tags['public_transport'] == 'platform' && tags['bus'] == 'yes');

      if (!railway && !isBus) continue;

      final latValue =
          item['lat'] ?? (item['center'] as Map<String, dynamic>?)?['lat'];
      final lonValue =
          item['lon'] ?? (item['center'] as Map<String, dynamic>?)?['lon'];

      if (latValue == null || lonValue == null) continue;

      final name =
          (tags['name'] ??
                  tags['name:en'] ??
                  (railway ? 'Train station' : 'Bus stop'))
              .toString();
      final type = railway ? 'Train Station' : 'Bus Stop';
      final key = '$type|$name|$latValue|$lonValue';

      if (!seen.add(key)) continue;

      final placeLat = (latValue as num).toDouble();
      final placeLon = (lonValue as num).toDouble();
      final distance = Geolocator.distanceBetween(lat, lon, placeLat, placeLon);

      result.add(
        _NearbyPlace(
          name: name,
          type: type,
          lat: placeLat,
          lon: placeLon,
          distanceMeters: distance,
        ),
      );
    }

    result.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return result;
  }

  List<_NearbyPlace> get _filteredPlaces {
    return _places.where((place) {
      if (_filter == 'Bus') return place.type == 'Bus Stop';
      if (_filter == 'Train') return place.type == 'Train Station';
      return true;
    }).toList();
  }

  String _distanceLabel(double meters) {
    if (meters < 1000) return '${meters.round()} m away';
    return '${(meters / 1000).toStringAsFixed(1)} km away';
  }

  @override
  Widget build(BuildContext context) {
    final center = _position == null
        ? const LatLng(7.8731, 80.7718)
        : LatLng(_position!.latitude, _position!.longitude);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        title: const Text(
          'Nearby Transport',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh location',
            onPressed: _loading ? null : _findNearby,
            icon: const Icon(Icons.my_location_rounded, color: _cyan),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.location_on_rounded, color: _cyan, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _position == null
                          ? 'Finding your current location…'
                          : 'Transport within 5 km of you',
                      style: const TextStyle(color: Color(0xFFB7C4D9)),
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  height: 300,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(initialCenter: center, initialZoom: 7),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.lanka_transit',
                      ),
                      if (_position != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: center,
                              width: 44,
                              height: 44,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _cyan,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x6638BDF8),
                                      blurRadius: 14,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_pin_circle_rounded,
                                  color: Color(0xFF07111F),
                                  size: 28,
                                ),
                              ),
                            ),
                            ..._filteredPlaces.map(
                              (place) => Marker(
                                point: LatLng(place.lat, place.lon),
                                width: 42,
                                height: 42,
                                child: Icon(
                                  place.type == 'Bus Stop'
                                      ? Icons.directions_bus_filled_rounded
                                      : Icons.train_rounded,
                                  color: place.type == 'Bus Stop'
                                      ? _cyan
                                      : _purple,
                                  size: 30,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black87,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            '© OpenStreetMap contributors',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.directions_bus_rounded,
                      label: 'Bus stops',
                      count: _places.where((p) => p.type == 'Bus Stop').length,
                      color: _cyan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.train_rounded,
                      label: 'Train stations',
                      count: _places
                          .where((p) => p.type == 'Train Station')
                          .length,
                      color: _purple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Nearby places',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _FilterChip(
                    label: 'All',
                    selected: _filter == 'All',
                    onTap: () => setState(() => _filter = 'All'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Bus',
                    selected: _filter == 'Bus',
                    onTap: () => setState(() => _filter = 'Bus'),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: 'Train',
                    selected: _filter == 'Train',
                    onTap: () => setState(() => _filter = 'Train'),
                  ),
                ],
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _panel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF34415B)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: _cyan,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFCBD5E1)),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _loading ? null : _findNearby,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: _loading && _position == null
                  ? const Center(child: CircularProgressIndicator(color: _cyan))
                  : _filteredPlaces.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error == null
                              ? 'No places to show yet.'
                              : 'Check your location and try again.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF9CAEC6)),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                      itemCount: _filteredPlaces.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        final place = _filteredPlaces[index];
                        final isBus = place.type == 'Bus Stop';

                        return Material(
                          color: _panel,
                          borderRadius: BorderRadius.circular(17),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(17),
                            onTap: () => _mapController.move(
                              LatLng(place.lat, place.lon),
                              16,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(13),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: (isBus ? _cyan : _purple)
                                          .withValues(alpha: .13),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      isBus
                                          ? Icons.directions_bus_filled_rounded
                                          : Icons.train_rounded,
                                      color: isBus ? _cyan : _purple,
                                      size: 26,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          place.type,
                                          style: TextStyle(
                                            color: isBus ? _cyan : _purple,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _distanceLabel(place.distanceMeters),
                                    style: const TextStyle(
                                      color: Color(0xFFB7C4D9),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyPlace {
  const _NearbyPlace({
    required this.name,
    required this.type,
    required this.lat,
    required this.lon,
    required this.distanceMeters,
  });

  final String name;
  final String type;
  final double lat;
  final double lon;
  final double distanceMeters;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFF111A2E),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: color.withValues(alpha: .25)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 25),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF9CAEC6), fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF173953) : const Color(0xFF111A2E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? const Color(0xFF38BDF8) : const Color(0xFF34415B),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? const Color(0xFF38BDF8) : const Color(0xFFB7C4D9),
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
