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
  final MapController _mapController = MapController();

  List<LatLng> _routePoints = [];
  bool _isLoadingRoute = true;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  bool get isTrain => widget.transportType == 'Train Route';

  Color get primaryColor =>
      isTrain ? const Color(0xFF2563EB) : const Color(0xFF087F5B);

  Color get lightColor =>
      isTrain ? const Color(0xFFEFF4FF) : const Color(0xFFE8F5EF);

  Color get darkText =>
      isTrain ? const Color(0xFF172B4D) : const Color(0xFF173B32);

  Future<void> _loadRoute() async {
    if (widget.routePath != null && widget.routePath!.isNotEmpty) {
      setState(() {
        _routePoints = widget.routePath!
            .map(
              (point) => LatLng(point[0], point[1]),
            )
            .toList();

        _isLoadingRoute = false;
      });

      return;
    }

    await _loadRoadRoute();
  }

  Future<void> _loadRoadRoute() async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${widget.startLng},${widget.startLat};'
          '${widget.endLng},${widget.endLat}'
          '?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final coordinates =
            data['routes'][0]['geometry']['coordinates'] as List;

        final points = coordinates
            .map<LatLng>(
              (point) => LatLng(
                point[1].toDouble(),
                point[0].toDouble(),
              ),
            )
            .toList();

        if (mounted) {
          setState(() {
            _routePoints = points;
            _isLoadingRoute = false;
          });
        }
      } else {
        _setFallbackRoute();
      }
    } catch (_) {
      _setFallbackRoute();
    }
  }

  void _setFallbackRoute() {
    if (!mounted) return;

    setState(() {
      _routePoints = [
        LatLng(widget.startLat, widget.startLng),
        LatLng(widget.endLat, widget.endLng),
      ];

      _isLoadingRoute = false;
    });
  }

  void _toggleFavourite() {
    setState(() {
      _isFavourite = !_isFavourite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavourite
              ? 'Route added to favourites'
              : 'Route removed from favourites',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _fitMapToRoute() {
    if (_routePoints.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(_routePoints);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildRouteHeader(),
                  _buildMap(),
                  _buildJourneyCard(),
                  _buildTripInformation(),
                  _buildMainStops(),
                  _buildFavouriteButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // APP BAR
  // ------------------------------------------------------------

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF6F8F7),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black87,
          ),
        ),
      ),
      title: Text(
        'Route Details',
        style: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: _toggleFavourite,
            icon: Icon(
              _isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _isFavourite ? Colors.red : Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // ROUTE HEADER
  // ------------------------------------------------------------

  Widget _buildRouteHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: lightColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    widget.icon,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transportType.toUpperCase(),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.routeName,
                        style: TextStyle(
                          color: darkText,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildRouteJourney(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteJourney() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 42,
              color: primaryColor.withValues(alpha: 0.25),
            ),
            Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FROM',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.from,
                style: TextStyle(
                  color: darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 23),
              Text(
                'TO',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.to,
                style: TextStyle(
                  color: darkText,
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

  // ------------------------------------------------------------
  // MAP
  // ------------------------------------------------------------

  Widget _buildMap() {
    final center = LatLng(
      (widget.startLat + widget.endLat) / 2,
      (widget.startLng + widget.endLng) / 2,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        height: 290,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: 9.5,
                onMapReady: () {
                  Future.delayed(
                    const Duration(milliseconds: 300),
                    _fitMapToRoute,
                  );
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.lanka_transit',
                ),

                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 5,
                        color: primaryColor,
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        widget.startLat,
                        widget.startLng,
                      ),
                      width: 44,
                      height: 44,
                      child: _buildMapMarker(
                        Icons.trip_origin_rounded,
                        primaryColor,
                      ),
                    ),
                    Marker(
                      point: LatLng(
                        widget.endLat,
                        widget.endLng,
                      ),
                      width: 44,
                      height: 44,
                      child: _buildMapMarker(
                        Icons.location_on_rounded,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (_isLoadingRoute)
              Container(
                color: Colors.white.withValues(alpha: 0.75),
                child: Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                ),
              ),

            Positioned(
              top: 14,
              right: 14,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _fitMapToRoute,
                  icon: Icon(
                    Icons.fullscreen_rounded,
                    color: primaryColor,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.map_rounded,
                      size: 15,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'OpenStreetMap',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );
  }

  // ------------------------------------------------------------
  // JOURNEY CARD
  // ------------------------------------------------------------

  Widget _buildJourneyCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.route_rounded,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Journey',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plan your journey with ease',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TRIP INFORMATION
  // ------------------------------------------------------------

  Widget _buildTripInformation() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: _buildSectionCard(
        title: 'Trip Information',
        icon: Icons.info_outline_rounded,
        child: Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                Icons.access_time_rounded,
                'Duration',
                '1h 30m',
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildInfoItem(
                Icons.payments_outlined,
                'Est. Fare',
                'Rs. 150',
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildInfoItem(
                Icons.location_on_outlined,
                'Stops',
                '12',
              ),
            ),
            _buildVerticalDivider(),
            Expanded(
              child: _buildInfoItem(
                Icons.schedule_rounded,
                'Frequency',
                '20m',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 21,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: darkText,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 48,
      width: 1,
      color: const Color(0xFFE8ECEA),
    );
  }

  // ------------------------------------------------------------
  // MAIN STOPS
  // ------------------------------------------------------------

  Widget _buildMainStops() {
    final List<String> stops = isTrain
        ? [
            widget.from,
            'Intermediate Station',
            'Major Station',
            'Main Junction',
            widget.to,
          ]
        : [
            widget.from,
            'Main Bus Stop',
            'Central Junction',
            'Town Bus Stand',
            widget.to,
          ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: _buildSectionCard(
        title: 'Main Stops',
        icon: Icons.signpost_outlined,
        child: Column(
          children: List.generate(
            stops.length,
            (index) {
              final bool isLast = index == stops.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: index == 0 || isLast
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 34,
                          color: primaryColor.withValues(alpha: 0.18),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 17),
                      child: Text(
                        stops[index],
                        style: TextStyle(
                          color: darkText,
                          fontSize: 14,
                          fontWeight: index == 0 || isLast
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION CARD
  // ------------------------------------------------------------

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Text(
                title,
                style: TextStyle(
                  color: darkText,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // FAVOURITE BUTTON
  // ------------------------------------------------------------

  Widget _buildFavouriteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: _toggleFavourite,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isFavourite ? Colors.red.shade50 : primaryColor,
            foregroundColor:
                _isFavourite ? Colors.red : Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: _isFavourite
                  ? BorderSide(
                      color: Colors.red.shade100,
                    )
                  : BorderSide.none,
            ),
          ),
          icon: Icon(
            _isFavourite
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
          ),
          label: Text(
            _isFavourite
                ? 'Added to Favourites'
                : 'Add to Favourites',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}