
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'route_details_screen.dart';

class FavouriteRoutesScreen extends StatefulWidget {
  const FavouriteRoutesScreen({super.key});

  @override
  State<FavouriteRoutesScreen> createState() =>
      _FavouriteRoutesScreenState();
}

class _FavouriteRoutesScreenState extends State<FavouriteRoutesScreen> {
  static const String _storageKey = 'lanka_transit_favourites_v1';

  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _pink = Color(0xFFFB7185);
 
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

      setState(() {
        _isLoading = false;
      });
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
          result.add(<double>[
            lat.toDouble(),
            lng.toDouble(),
          ]);
        }
      }
    }

    return result.isEmpty ? null : result;
  }

  Future<void> _openRoute(Map<String, dynamic> route) async {
    final l10n = AppLocalizations.of(context)!;

    final transportType = '${route['transportType'] ?? 'Bus Route'}';
    final isTrain = transportType.toLowerCase().contains('train');

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          transportType: transportType,
          routeName: '${route['routeName'] ?? l10n.savedRouteFallback}',
          from: '${route['from'] ?? l10n.startLocationFallback}',
          to: '${route['to'] ?? l10n.destinationFallback}',
          icon: isTrain
              ? Icons.train_rounded
              : Icons.directions_bus_rounded,
          iconColor: isTrain ? _purple : _cyan,
          startLat: _number(route, 'startLat'),
          startLng: _number(route, 'startLng'),
          endLat: _number(route, 'endLat'),
          endLng: _number(route, 'endLng'),
          routePath: _routePath(route),
        ),
      ),
    );

    await _loadFavourites();
  }

  Future<void> _removeFavourite(Map<String, dynamic> route) async {
    final l10n = AppLocalizations.of(context)!;
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
        SnackBar(
          content: Text(l10n.routeRemovedFromFavourites),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      debugPrint('Could not remove favourite route: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.couldNotRemoveRoute),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _savedCountText(AppLocalizations l10n, int count) {
    if (count == 1) return l10n.oneSavedRoute;

    return '$count ${l10n.savedRoutesCountLabel}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final background = theme.scaffoldBackgroundColor;
    final surface = colorScheme.surface;
    final textColor = colorScheme.onSurface;
    final mutedColor = colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.favouriteRoutes,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.refreshFavourites,
            onPressed: _loadFavourites,
            icon: const Icon(
              Icons.refresh_rounded,
              color: _cyan,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: _cyan,
                ),
              )
            : _routes.isEmpty
                ? _buildEmptyState(
                    context,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  )
                : RefreshIndicator(
                    color: _cyan,
                    backgroundColor: surface,
                    onRefresh: _loadFavourites,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        8,
                        18,
                        24,
                      ),
                      children: [
                        _buildSummaryCard(
                          context,
                          l10n: l10n,
                          isDark: isDark,
                          textColor: textColor,
                          mutedColor: mutedColor,
                        ),
                        const SizedBox(height: 18),
                        ..._routes.map(
                          (route) => _buildRouteCard(
                            context,
                            route,
                            isDark: isDark,
                            textColor: textColor,
                            mutedColor: mutedColor,
                            surface: surface,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required AppLocalizations l10n,
    required bool isDark,
    required Color textColor,
    required Color mutedColor,
  }) {
    final gradient = isDark
        ? const [
            Color(0xFF15223B),
            Color(0xFF211D3D),
          ]
        : const [
            Color(0xFFE6F5FF),
            Color(0xFFF0EAFF),
          ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _cyan.withValues(
            alpha: isDark ? 0.18 : 0.30,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _pink.withValues(alpha: 0.14),
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
                  _savedCountText(l10n, _routes.length),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.favouriteRoutesDescription,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required Color textColor,
    required Color mutedColor,
    required bool isDark,
  }) {
    final l10n = AppLocalizations.of(context)!;

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
            Text(
              l10n.noFavouriteRoutesYet,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              l10n.saveFavouriteRoutesDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 22),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.explore_rounded),
              label: Text(l10n.exploreRoutesButton),
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

  Widget _buildRouteCard(
    BuildContext context,
    Map<String, dynamic> route, {
    required bool isDark,
    required Color textColor,
    required Color mutedColor,
    required Color surface,
  }) {
    final l10n = AppLocalizations.of(context)!;

    final transportType = '${route['transportType'] ?? 'Bus Route'}';
    final isTrain = transportType.toLowerCase().contains('train');
    final accent = isTrain ? _purple : _cyan;

    final routeName =
        '${route['routeName'] ?? l10n.savedRouteFallback}';
    final from = '${route['from'] ?? l10n.startLocationFallback}';
    final to = '${route['to'] ?? l10n.destinationFallback}';

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withValues(
            alpha: isDark ? 0.22 : 0.35,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? 0.08 : 0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
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
                    color: accent.withValues(
                      alpha: isDark ? 0.12 : 0.10,
                    ),
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
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$from  →  $to',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        isTrain
                            ? l10n.trainRoutes
                            : l10n.busRouteLabel,
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
                  tooltip: l10n.removeFavourite,
                  onPressed: () => _removeFavourite(route),
                  icon: const Icon(
                    Icons.favorite_rounded,
                    color: _pink,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: mutedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
