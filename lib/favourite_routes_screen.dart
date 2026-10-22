import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'route_details_screen.dart';

class FavouriteRoutesScreen extends StatefulWidget {
  const FavouriteRoutesScreen({super.key});

  @override
  State<FavouriteRoutesScreen> createState() => _FavouriteRoutesScreenState();
}

class _FavouriteRoutesScreenState extends State<FavouriteRoutesScreen> {
  static const String _storageKey = 'lanka_transit_favourites_v1';

  static const Color _bg = Color(0xFF070B18);
  static const Color _card = Color(0xFF111A2E);
  static const Color _card2 = Color(0xFF15223B);
  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _pink = Color(0xFFFB7185);
  static const Color _white = Color(0xFFF3F6FF);
  static const Color _muted = Color(0xFF9AA8C0);

  List<Map<String, dynamic>> _routes = <Map<String, dynamic>>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_storageKey) ?? <String>[];
      final parsed = <Map<String, dynamic>>[];

      for (final item in saved) {
        try {
          final value = jsonDecode(item);
          if (value is Map<String, dynamic>) {
            parsed.add(value);
          }
        } catch (e) {
          debugPrint('Skipping invalid favourite route: $e');
        }
      }

      if (!mounted) return;
      setState(() {
        _routes = parsed.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Could not load favourite routes: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  double _number(Map<String, dynamic> route, String key) {
    final value = route[key];
    if (value is num) return value.toDouble();
    return double.tryParse('$value') ?? 0.0;
  }

  List<List<double>>? _routePath(Map<String, dynamic> route) {
    final rawPath = route['routePath'];
    if (rawPath is! List) return null;

    final result = <List<double>>[];
    for (final point in rawPath) {
      if (point is List && point.length >= 2) {
        final lat = point[0];
        final lng = point[1];
        if (lat is num && lng is num) {
          result.add(<double>[lat.toDouble(), lng.toDouble()]);
        }
      }
    }
    return result.isEmpty ? null : result;
  }

  Future<void> _openRoute(Map<String, dynamic> route) async {
    final transportType = '${route['transportType'] ?? 'Bus Route'}';
    final isTrain = transportType.toLowerCase().contains('train');

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          transportType: transportType,
          routeName: '${route['routeName'] ?? 'Saved route'}',
          from: '${route['from'] ?? 'Start'}',
          to: '${route['to'] ?? 'Destination'}',
          icon: isTrain ? Icons.train_rounded : Icons.directions_bus_rounded,
          iconColor: isTrain ? _purple : _cyan,
          startLat: _number(route, 'startLat'),
          startLng: _number(route, 'startLng'),
          endLat: _number(route, 'endLat'),
          endLng: _number(route, 'endLng'),
          routePath: _routePath(route),
        ),
      ),
    );

    // Refresh when returning in case the heart button was toggled.
    await _loadFavourites();
  }

  Future<void> _removeFavourite(Map<String, dynamic> route) async {
    final id = route['id'];
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getStringList(_storageKey) ?? <String>[];
      saved.removeWhere((item) {
        try {
          final decoded = jsonDecode(item) as Map<String, dynamic>;
          return decoded['id'] == id;
        } catch (_) {
          return false;
        }
      });
      await prefs.setStringList(_storageKey, saved);

      if (id is String && id.isNotEmpty) {
        await prefs.setBool(id, false);
      }

      await _loadFavourites();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Route removed from favourites'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Could not remove favourite route: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not remove route. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _white,
        elevation: 0,
        title: const Text(
          'Favourite Routes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh favourites',
            onPressed: _loadFavourites,
            icon: const Icon(Icons.refresh_rounded, color: _cyan),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: _cyan))
            : _routes.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
                color: _cyan,
                backgroundColor: _card,
                onRefresh: _loadFavourites,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_card2, Color(0xFF211D3D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: _cyan.withValues(alpha: 0.18),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _pink.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: _pink,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_routes.length} saved ${_routes.length == 1 ? 'route' : 'routes'}',
                                  style: const TextStyle(
                                    color: _white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Your favourite bus and train journeys',
                                  style: TextStyle(color: _muted, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    ..._routes.map(_buildRouteCard),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: _pink.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                color: _pink,
                size: 48,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No favourite routes yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Open a bus or train route and tap the heart icon to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, height: 1.5, fontSize: 14),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore routes'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _cyan,
                side: const BorderSide(color: _cyan),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> route) {
    final transportType = '${route['transportType'] ?? 'Bus Route'}';
    final isTrain = transportType.toLowerCase().contains('train');
    final accent = isTrain ? _purple : _cyan;
    final routeName = '${route['routeName'] ?? 'Saved route'}';
    final from = '${route['from'] ?? 'Start'}';
    final to = '${route['to'] ?? 'Destination'}';

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openRoute(route),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isTrain
                        ? Icons.train_rounded
                        : Icons.directions_bus_rounded,
                    color: accent,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$from  →  $to',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        isTrain ? 'TRAIN ROUTE' : 'BUS ROUTE',
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  tooltip: 'Remove favourite',
                  onPressed: () => _removeFavourite(route),
                  icon: const Icon(Icons.favorite_rounded, color: _pink),
                ),
                const Icon(Icons.chevron_right_rounded, color: _muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
