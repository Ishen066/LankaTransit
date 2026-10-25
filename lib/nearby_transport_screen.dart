
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'l10n/app_localizations.dart';

class NearbyTransportScreen extends StatefulWidget {
  const NearbyTransportScreen({super.key});

  @override
  State<NearbyTransportScreen> createState() =>
      _NearbyTransportScreenState();
}

class _NearbyTransportScreenState extends State<NearbyTransportScreen> {
  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);

  final MapController _mapController = MapController();

  Position? _position;
  List<_NearbyPlace> _places = [];
  bool _loading = false;
  String? _errorCode;

  // Internal values remain unchanged when the language changes.
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
      _errorCode = null;
    });

    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception('locationServiceOff');
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('locationPermissionDenied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('locationPermissionBlocked');
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

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        14,
      );

      final places = await _loadPlaces(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _places = places;

        if (places.isEmpty) {
          _errorCode = 'noNearbyStopsFound';
        }
      });
    } catch (e) {
      if (!mounted) return;

      final message = e.toString().replaceFirst(
            'Exception: ',
            '',
          );

      setState(() {
        _errorCode = [
          'locationServiceOff',
          'locationPermissionDenied',
          'locationPermissionBlocked',
          'mapServiceBusy',
        ].contains(message)
            ? message
            : 'somethingWentWrong';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<List<_NearbyPlace>> _loadPlaces(
    double lat,
    double lon,
  ) async {
    const endpoint =
        'https://overpass-api.de/api/interpreter';

    final query = '''[out:json][timeout:25];
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
          headers: const {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {'data': query},
        )
        .timeout(const Duration(seconds: 35));

    if (response.statusCode != 200) {
      throw Exception('mapServiceBusy');
    }

    final decoded =
        jsonDecode(response.body) as Map<String, dynamic>;

    final elements =
        decoded['elements'] as List<dynamic>? ?? [];

    final result = <_NearbyPlace>[];
    final seen = <String>{};

    for (final raw in elements) {
      final item = raw as Map<String, dynamic>;
      final tags =
          item['tags'] as Map<String, dynamic>? ?? {};

      final railway = tags['railway'] == 'station' ||
          tags['railway'] == 'halt';

      final isBus = tags['highway'] == 'bus_stop' ||
          (tags['public_transport'] == 'platform' &&
              tags['bus'] == 'yes');

      if (!railway && !isBus) continue;

      final latValue = item['lat'] ??
          (item['center'] as Map<String, dynamic>?)?['lat'];

      final lonValue = item['lon'] ??
          (item['center'] as Map<String, dynamic>?)?['lon'];

      if (latValue == null || lonValue == null) continue;

      final name = (tags['name'] ??
              tags['name:en'] ??
              (railway ? 'Train station' : 'Bus stop'))
          .toString();

      final type = railway ? 'Train Station' : 'Bus Stop';
      final key = '$type|$name|$latValue|$lonValue';

      if (!seen.add(key)) continue;

      final placeLat = (latValue as num).toDouble();
      final placeLon = (lonValue as num).toDouble();

      final distance = Geolocator.distanceBetween(
        lat,
        lon,
        placeLat,
        placeLon,
      );

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

    result.sort(
      (a, b) => a.distanceMeters.compareTo(b.distanceMeters),
    );

    return result;
  }

  List<_NearbyPlace> get _filteredPlaces {
    return _places.where((place) {
      if (_filter == 'Bus') {
        return place.type == 'Bus Stop';
      }

      if (_filter == 'Train') {
        return place.type == 'Train Station';
      }

      return true;
    }).toList();
  }

  String _distanceLabel(
    double meters,
    AppLocalizations l10n,
  ) {
    if (meters < 1000) {
      return '${meters.round()} ${l10n.metersAway}';
    }

    return '${(meters / 1000).toStringAsFixed(1)} '
        '${l10n.kilometersAway}';
  }

  String _errorMessage(AppLocalizations l10n) {
    switch (_errorCode) {
      case 'locationServiceOff':
        return l10n.locationServiceOff;
      case 'locationPermissionDenied':
        return l10n.locationPermissionDenied;
      case 'locationPermissionBlocked':
        return l10n.locationPermissionBlocked;
      case 'mapServiceBusy':
        return l10n.mapServiceBusy;
      case 'noNearbyStopsFound':
        return l10n.noNearbyStopsFound;
      default:
        return l10n.somethingWentWrong;
    }
  }

  String _placeTypeLabel(
    _NearbyPlace place,
    AppLocalizations l10n,
  ) {
    return place.type == 'Bus Stop'
        ? l10n.busStop
        : l10n.trainStation;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final muted = colors.onSurface.withValues(
      alpha: isDark ? 0.70 : 0.65,
    );

    final center = _position == null
        ? const LatLng(7.8731, 80.7718)
        : LatLng(
            _position!.latitude,
            _position!.longitude,
          );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.nearbyTransport,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.refreshLocation,
            onPressed: _loading ? null : _findNearby,
            icon: const Icon(
              Icons.my_location_rounded,
              color: _cyan,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Current location status
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                4,
                16,
                12,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: _cyan,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _position == null
                          ? l10n.findingCurrentLocation
                          : l10n.transportWithin5Km,
                      style: TextStyle(
                        color: muted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                ],
              ),
            ),

            // Map
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  height: 300,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: center,
                      initialZoom: 7,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.lanka_transit',
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
                                  boxShadow: [
                                    BoxShadow(
                                      color: _cyan.withValues(
                                        alpha: 0.4,
                                      ),
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
                                point: LatLng(
                                  place.lat,
                                  place.lon,
                                ),
                                width: 42,
                                height: 42,
                                child: Icon(
                                  place.type == 'Bus Stop'
                                      ? Icons
                                          .directions_bus_filled_rounded
                                      : Icons.train_rounded,
                                  color:
                                      place.type == 'Bus Stop'
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

            // Bus and train summary cards
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.directions_bus_rounded,
                      label: l10n.busStops,
                      count: _places
                          .where((p) => p.type == 'Bus Stop')
                          .length,
                      color: _cyan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SummaryCard(
                      icon: Icons.train_rounded,
                      label: l10n.trainStations,
                      count: _places
                          .where(
                            (p) => p.type == 'Train Station',
                          )
                          .length,
                      color: _purple,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Nearby places and filters
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.nearbyPlaces,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _FilterChip(
                    label: l10n.all,
                    selected: _filter == 'All',
                    onTap: () => setState(
                      () => _filter = 'All',
                    ),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: l10n.bus,
                    selected: _filter == 'Bus',
                    onTap: () => setState(
                      () => _filter = 'Bus',
                    ),
                  ),
                  const SizedBox(width: 6),
                  _FilterChip(
                    label: l10n.train,
                    selected: _filter == 'Train',
                    onTap: () => setState(
                      () => _filter = 'Train',
                    ),
                  ),
                ],
              ),
            ),

            // Error message
            if (_errorCode != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  8,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: isDark ? _cyan : colors.primary,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage(l10n),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed:
                            _loading ? null : _findNearby,
                        icon: const Icon(
                          Icons.refresh_rounded,
                        ),
                        label: Text(l10n.tryAgain),
                      ),
                    ],
                  ),
                ),
              ),

            // Nearby places list
            Expanded(
              child: _loading && _position == null
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _cyan,
                      ),
                    )
                  : _filteredPlaces.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _errorCode == null
                                  ? l10n.noPlacesToShow
                                  : l10n.checkLocationTryAgain,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: muted,
                              ),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            10,
                            16,
                            20,
                          ),
                          itemCount: _filteredPlaces.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 9),
                          itemBuilder: (context, index) {
                            final place =
                                _filteredPlaces[index];
                            final isBus =
                                place.type == 'Bus Stop';
                            final accent =
                                isBus ? _cyan : _purple;

                            return Material(
                              color: colors.surfaceContainer,
                              borderRadius:
                                  BorderRadius.circular(17),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  _mapController.move(
                                    LatLng(
                                      place.lat,
                                      place.lon,
                                    ),
                                    16,
                                  );
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(13),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: colors
                                          .outlineVariant
                                          .withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(17),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: accent.withValues(
                                            alpha: 0.13,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: Icon(
                                          isBus
                                              ? Icons
                                                  .directions_bus_filled_rounded
                                              : Icons.train_rounded,
                                          color: accent,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            Text(
                                              place.name,
                                              maxLines: 2,
                                              overflow: TextOverflow
                                                  .ellipsis,
                                              style: TextStyle(
                                                color:
                                                    colors.onSurface,
                                                fontWeight:
                                                    FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              _placeTypeLabel(
                                                place,
                                                l10n,
                                              ),
                                              style: TextStyle(
                                                color: accent,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          _distanceLabel(
                                            place.distanceMeters,
                                            l10n,
                                          ),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: muted,
                                            fontSize: 11,
                                          ),
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

// Summary card
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
        ),
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
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface.withValues(
                      alpha: 0.65,
                    ),
                    fontSize: 11,
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

// Theme-aware filter chip
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = isDark
        ? const Color(0xFF173953)
        : colors.primaryContainer;

    final selectedTextColor = isDark
        ? _NearbyTransportScreenState._cyan
        : colors.onPrimaryContainer;

    return Material(
      color: selected ? selectedColor : colors.surfaceContainer,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? (isDark
                      ? _NearbyTransportScreenState._cyan
                      : colors.primary)
                  : colors.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: selected
                  ? selectedTextColor
                  : colors.onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
