import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import 'l10n/app_localizations.dart';

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
  bool _mapReady = false;
  bool _routeLoadFailed = false;

  static const Color _bg = Color(0xFF050B1B);
  static const Color _card = Color(0xFF08152D);
  static const Color _card2 = Color(0xFF0D2040);
  static const Color _cyan = Color(0xFF12D9FF);
  static const Color _blue = Color(0xFF1677FF);
  static const Color _purple = Color(0xFFB13CFF);
  static const Color _white = Color(0xFFF4F7FF);
  static const Color _muted = Color(0xFFA8B8D8);
  static const Color _border = Color(0xFF174B87);

  bool get isTrain => widget.transportType.toLowerCase().contains('train');
  Color get accent => isTrain ? _purple : _cyan;
  Color get accent2 => isTrain ? _cyan : _purple;

  String get _heroImage => isTrain
      ? 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?auto=format&fit=crop&w=1400&q=85'
      : 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?auto=format&fit=crop&w=1400&q=85';

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final supplied = widget.routePath;
    if (supplied != null && supplied.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        _routePoints = supplied
            .where((p) => p.length >= 2)
            .map((p) => LatLng(p[0], p[1]))
            .toList();
        _isLoadingRoute = false;
      });
      _fitWhenReady();
      return;
    }

    // OSRM provides road-driving geometry, not railway geometry.
    // Do not request it for train journeys.
    if (isTrain) {
      _setFallbackRoute();
      return;
    }

    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${widget.startLng},${widget.startLat};'
        '${widget.endLng},${widget.endLat}'
        '?overview=full&geometries=geojson',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = data['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final geometry = routes.first['geometry'] as Map<String, dynamic>;
          final coordinates = geometry['coordinates'] as List;
          final points = coordinates.map<LatLng>((p) {
            return LatLng((p[1] as num).toDouble(), (p[0] as num).toDouble());
          }).toList();

          if (points.isNotEmpty && mounted) {
            setState(() {
              _routePoints = points;
              _isLoadingRoute = false;
            });
            _fitWhenReady();
            return;
          }
        }
      }
      _setFallbackRoute();
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
      _routeLoadFailed = true;
    });
    _fitWhenReady();
  }

  void _fitWhenReady() {
    if (!_mapReady || _routePoints.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _routePoints.isEmpty) return;
      try {
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(_routePoints),
            padding: const EdgeInsets.all(40),
          ),
        );
      } catch (_) {}
    });
  }

  void _toggleFavourite() {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isFavourite = !_isFavourite);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavourite ? l10n.addedToFavourites : l10n.addToFavourites,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _card2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEndpointStrip(),
                  const SizedBox(height: 16),
                  _buildMap(),
                  const SizedBox(height: 16),
                  _buildStats(),
                  const SizedBox(height: 16),
                  _buildDepartures(),
                  const SizedBox(height: 16),
                  _buildStationsAndAbout(),
                  const SizedBox(height: 20),
                  _buildMapButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 330,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _heroImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_card2, _bg],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                widget.icon,
                color: accent.withValues(alpha: 0.25),
                size: 130,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _bg.withValues(alpha: 0.50),
                  _bg.withValues(alpha: 0.28),
                  _bg.withValues(alpha: 0.96),
                ],
                stops: const [0, 0.38, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _circleButton(
                        Icons.arrow_back_rounded,
                        () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        l10n.routeDetails,
                        style: const TextStyle(
                          color: _white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      _circleButton(
                        _isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        _toggleFavourite,
                        color: _isFavourite ? Colors.pinkAccent : _white,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: _bg.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: accent, width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: 0.30),
                              blurRadius: 22,
                            ),
                          ],
                        ),
                        child: Icon(widget.icon, color: accent, size: 42),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transportType.toUpperCase(),
                              style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              '${widget.from}  →  ${widget.to}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _white,
                                fontSize: 23,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(widget.icon, size: 17, color: accent2),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(
                                    widget.routeName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: _muted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = _white,
  }) {
    return Material(
      color: _bg.withValues(alpha: 0.72),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: _border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  Widget _buildEndpointStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _cyan.withValues(alpha: 0.10),
            _card,
            _purple.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          _endpoint(
            icon: Icons.location_on_rounded,
            name: widget.from,
            subtitle: 'Starting point',
            color: _cyan,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.more_horiz_rounded, color: accent2, size: 27),
          ),
          _endpoint(
            icon: Icons.location_on_rounded,
            name: widget.to,
            subtitle: 'Destination',
            color: _purple,
            alignEnd: true,
          ),
        ],
      ),
    );
  }

  Widget _endpoint({
    required IconData icon,
    required String name,
    required String subtitle,
    required Color color,
    bool alignEnd = false,
  }) {
    return Expanded(
      child: Row(
        mainAxisAlignment: alignEnd
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!alignEnd) _pin(icon, color),
          if (!alignEnd) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: alignEnd
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 10),
                ),
              ],
            ),
          ),
          if (alignEnd) const SizedBox(width: 8),
          if (alignEnd) _pin(icon, color),
        ],
      ),
    );
  }

  Widget _pin(IconData icon, Color color) {
    return Container(
      width: 37,
      height: 37,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Icon(icon, color: color, size: 21),
    );
  }

  Widget _buildMap() {
    final center = LatLng(
      (widget.startLat + widget.endLat) / 2,
      (widget.startLng + widget.endLng) / 2,
    );
    return Container(
      height: 245,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 8.5,
              onMapReady: () {
                _mapReady = true;
                _fitWhenReady();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.lanka_transit',
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 7,
                      color: accent.withValues(alpha: 0.25),
                    ),
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 3.5,
                      color: accent,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.startLat, widget.startLng),
                    width: 42,
                    height: 42,
                    child: _mapPin(_cyan, Icons.trip_origin_rounded),
                  ),
                  Marker(
                    point: LatLng(widget.endLat, widget.endLng),
                    width: 42,
                    height: 42,
                    child: _mapPin(_purple, Icons.location_on_rounded),
                  ),
                ],
              ),
            ],
          ),
          if (_isLoadingRoute)
            Container(
              color: _bg.withValues(alpha: 0.78),
              child: Center(child: CircularProgressIndicator(color: accent)),
            ),
          if (_routeLoadFailed && !_isLoadingRoute)
            Positioned(
              left: 10,
              right: 58,
              top: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _bg.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isTrain
                      ? 'Route line is approximate; railway geometry is not connected yet.'
                      : 'Showing an approximate route line.',
                  style: const TextStyle(color: _white, fontSize: 10),
                ),
              ),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _bg.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, color: _cyan, size: 17),
                  const SizedBox(width: 6),
                  const Text(
                    'OpenStreetMap',
                    style: TextStyle(color: _white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: _circleButton(
              Icons.fullscreen_rounded,
              _fitWhenReady,
              color: _cyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin(Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: _bg,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 12),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _stat(
            Icons.schedule_rounded,
            'Duration',
            'See timetable',
            _cyan,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _stat(
            Icons.payments_outlined,
            'Est. Fare',
            'Check locally',
            _purple,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _stat(Icons.alt_route_rounded, 'Stops', 'Route stops', _cyan),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _stat(
            Icons.calendar_month_rounded,
            'Service',
            'Check times',
            _purple,
          ),
        ),
      ],
    );
  }

  Widget _stat(IconData icon, String label, String value, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 105),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.6)),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _muted, fontSize: 10),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartures() {
    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _panelIcon(Icons.access_time_rounded, _cyan),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Departure information',
                  style: TextStyle(
                    color: _white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: _muted),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Example times only — confirm the latest timetable before travelling.',
            style: TextStyle(color: _muted, fontSize: 11),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _timeChip('6:00 AM', _cyan),
              _timeChip('7:00 AM', _cyan),
              _timeChip('8:00 AM', _purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeChip(String time, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.22), _card2],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.65)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_rounded, color: color, size: 16),
          const SizedBox(width: 7),
          Text(
            time,
            style: const TextStyle(
              color: _white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationsAndAbout() {
    final stops = isTrain
        ? <String>[
            widget.from,
            'Maradana',
            'Ragama',
            'Gampaha',
            'Veyangoda',
            '… and more stations',
            widget.to,
          ]
        : <String>[
            widget.from,
            'Main Bus Stop',
            'Central Junction',
            'Town Bus Stand',
            widget.to,
          ];

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _panelIcon(Icons.train_rounded, _cyan),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Stations along the route',
                  style: TextStyle(
                    color: _white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...List.generate(stops.length, (index) {
            final first = index == 0;
            final last = index == stops.length - 1;
            final color = last ? _purple : _cyan;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: first || last ? color : _card2,
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 2),
                          boxShadow: first || last
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      if (!last)
                        Container(width: 2, height: 27, color: _border),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      stops[index],
                      style: TextStyle(
                        color: first || last ? _white : _muted,
                        fontSize: 12,
                        fontWeight: first || last
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                if (last)
                  Text(
                    'Destination',
                    style: TextStyle(color: _purple, fontSize: 10),
                  ),
              ],
            );
          }),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: _card2.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _cyan, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Route stops, departure times and fares shown here are illustrative sample data, not verified live transport information.',
                    style: TextStyle(color: _muted, fontSize: 11, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: child,
    );
  }

  Widget _panelIcon(IconData icon, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildMapButton() {
    return SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_cyan, _blue, _purple]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.20),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: _fitWhenReady,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          icon: const Icon(Icons.map_outlined),
          label: const Text(
            'View route on map',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
