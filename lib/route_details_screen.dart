import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String transportType;
  final String routeName;
  final String from;
  final String to;
  final IconData icon;
  final Color iconColor;

  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;

  // Custom route path for train routes
  final List<List<double>>? routePath;

  const RouteDetailsScreen({
    super.key,
    required this.transportType,
    required this.routeName,
    required this.from,
    required this.to,
    required this.icon,
    required this.iconColor,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    this.routePath,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  List<LatLng> routePoints = [];
  bool isLoadingRoute = false;
  String? routeError;

  @override
  void initState() {
    super.initState();

    // BUS
    // Use OSRM to find an actual road route.
    if (widget.transportType == 'Bus Route') {
      _loadRoadRoute();
    }

    // TRAIN
    // Use the custom railway path passed from train_routes_screen.dart.
    else if (widget.routePath != null &&
        widget.routePath!.isNotEmpty) {
      routePoints = widget.routePath!.map<LatLng>((point) {
        return LatLng(point[0], point[1]);
      }).toList();
    }

    // Fallback
    else {
      routePoints = _createFallbackRoute();
    }
  }

  // ============================================================
  // BUS ROUTE - OSRM
  // ============================================================

  Future<void> _loadRoadRoute() async {
    setState(() {
      isLoadingRoute = true;
      routeError = null;
    });

    try {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${widget.startLng},${widget.startLat};'
        '${widget.endLng},${widget.endLat}'
        '?overview=full&geometries=geojson',
      );

      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Routing server error');
      }

      final data = jsonDecode(response.body);

      if (data['code'] != 'Ok' ||
          data['routes'] == null ||
          data['routes'].isEmpty) {
        throw Exception('No route found');
      }

      final coordinates =
          data['routes'][0]['geometry']['coordinates'] as List;

      final points = coordinates.map<LatLng>((coordinate) {
        return LatLng(
          (coordinate[1] as num).toDouble(),
          (coordinate[0] as num).toDouble(),
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        routePoints = points;
        isLoadingRoute = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        routeError = 'Could not load road route.';
        routePoints = _createFallbackRoute();
        isLoadingRoute = false;
      });
    }
  }

  // ============================================================
  // FALLBACK ROUTE
  // ============================================================

  List<LatLng> _createFallbackRoute() {
    return [
      LatLng(widget.startLat, widget.startLng),
      LatLng(
        (widget.startLat + widget.endLat) / 2,
        widget.startLng,
      ),
      LatLng(
        (widget.startLat + widget.endLat) / 2,
        widget.endLng,
      ),
      LatLng(widget.endLat, widget.endLng),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final startPoint = LatLng(
      widget.startLat,
      widget.startLng,
    );

    final endPoint = LatLng(
      widget.endLat,
      widget.endLng,
    );

    final centerPoint = LatLng(
      (widget.startLat + widget.endLat) / 2,
      (widget.startLng + widget.endLng) / 2,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),

      appBar: AppBar(
        title: const Text(
          'Route Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // ==================================================
            // HEADER
            // ==================================================

            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                10,
              ),
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Row(
                children: [

                  CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        widget.iconColor.withOpacity(0.12),

                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          widget.routeName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.transportType,
                          style: TextStyle(
                            color: widget.iconColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Added to favourites!',
                          ),
                        ),
                      );
                    },

                    icon: const Icon(
                      Icons.favorite_border,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // JOURNEY
            // ==================================================

            Container(
              width: double.infinity,

              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Journey',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ==================================================
                  // MAP
                  // ==================================================

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(16),

                    child: SizedBox(
                      height: 320,

                      child: Stack(
                        children: [

                          FlutterMap(
                            options: MapOptions(
                              initialCenter: centerPoint,
                              initialZoom: 9.5,
                            ),

                            children: [

                              // OpenStreetMap
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                                userAgentPackageName:
                                    'com.example.lanka_transit',
                              ),

                              // ==================================================
                              // ROUTE LINE
                              // ==================================================

                              if (routePoints.isNotEmpty)
                                PolylineLayer(
                                  polylines: [

                                    Polyline(
                                      points: routePoints,

                                      strokeWidth: 5,

                                      color:
                                          widget.iconColor,
                                    ),
                                  ],
                                ),

                              // ==================================================
                              // START + DESTINATION
                              // ==================================================

                              MarkerLayer(
                                markers: [

                                  Marker(
                                    point: startPoint,

                                    width: 50,
                                    height: 50,

                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.green,
                                      size: 42,
                                    ),
                                  ),

                                  Marker(
                                    point: endPoint,

                                    width: 50,
                                    height: 50,

                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 42,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ==================================================
                          // LOADING
                          // ==================================================

                          if (isLoadingRoute)
                            Positioned.fill(
                              child: Container(
                                color: Colors.white
                                    .withOpacity(0.7),

                                child:
                                    const Center(
                                  child:
                                      CircularProgressIndicator(),
                                ),
                              ),
                            ),

                          // ==================================================
                          // ERROR
                          // ==================================================

                          if (routeError != null)
                            Positioned(
                              left: 12,
                              right: 12,
                              bottom: 12,

                              child: Container(
                                padding:
                                    const EdgeInsets.all(10),

                                decoration: BoxDecoration(
                                  color: Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),

                                child: Text(
                                  routeError!,
                                  textAlign:
                                      TextAlign.center,

                                  style:
                                      const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // START LOCATION
                  _locationRow(
                    icon: Icons.trip_origin,
                    color: Colors.green,
                    title: 'Starting Point',
                    location: widget.from,
                  ),

                  const SizedBox(height: 15),

                  // DESTINATION
                  _locationRow(
                    icon: Icons.location_on,
                    color: Colors.red,
                    title: 'Destination',
                    location: widget.to,
                  ),
                ],
              ),
            ),

            // ==================================================
            // TRIP INFORMATION
            // ==================================================

            Container(
              width: double.infinity,

              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Trip Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [

                      Expanded(
                        child: _infoCard(
                          Icons.access_time,
                          'Duration',
                          '1h 30m',
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _infoCard(
                          Icons.payments_outlined,
                          'Estimated Fare',
                          'Rs. 150',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Expanded(
                        child: _infoCard(
                          Icons.location_on_outlined,
                          'Stops',
                          '12 Stops',
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: _infoCard(
                          Icons.schedule,
                          'Frequency',
                          'Every 20m',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ==================================================
            // MAIN STOPS
            // ==================================================

            Container(
              width: double.infinity,

              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Main Stops',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  _stopItem(
                    'Starting Point',
                    widget.from,
                    true,
                  ),

                  _stopItem(
                    'Main Junction',
                    'Main Junction',
                    false,
                  ),

                  _stopItem(
                    'City Centre',
                    'City Centre',
                    false,
                  ),

                  _stopItem(
                    'Town Hall',
                    'Town Hall',
                    false,
                  ),

                  _stopItem(
                    'Destination',
                    widget.to,
                    true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ==================================================
            // FAVOURITE BUTTON
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
              ),

              child: SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Route added to favourites!',
                        ),
                      ),
                    );
                  },

                  icon: const Icon(
                    Icons.favorite_border,
                  ),

                  label: const Text(
                    'Add to Favourites',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.iconColor,

                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOCATION ROW
  // ============================================================

  Widget _locationRow({
    required IconData icon,
    required Color color,
    required String title,
    required String location,
  }) {
    return Row(
      children: [

        Icon(
          icon,
          color: color,
          size: 28,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                location,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F8),
        borderRadius: BorderRadius.circular(14),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: widget.iconColor,
            size: 26,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,

            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,

            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STOP ITEM
  // ============================================================

  Widget _stopItem(
    String title,
    String location,
    bool isEndpoint,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Column(
            children: [

              Icon(
                isEndpoint
                    ? Icons.location_on
                    : Icons.circle,

                size: isEndpoint ? 22 : 12,

                color: isEndpoint
                    ? widget.iconColor
                    : Colors.grey,
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.grey,
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