
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'bus_routes_screen.dart';
import 'train_routes_screen.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _amber = Color(0xFFFBBF24);

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final background = theme.scaffoldBackgroundColor;
    final textColor = colorScheme.onSurface;
    final mutedColor = colorScheme.onSurfaceVariant;
    final surfaceColor = colorScheme.surface;

    final heroGradient = isDark
        ? const [
            Color(0xFF172C4A),
            Color(0xFF171A38),
            Color(0xFF241A46),
          ]
        : const [
            Color(0xFFE1F3FF),
            Color(0xFFEAE8FF),
            Color(0xFFF3E9FF),
          ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        foregroundColor: textColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.exploreRoutesTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            // Hero section
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: heroGradient,
                ),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.09)
                      : _purple.withValues(alpha: 0.15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _purple.withValues(
                      alpha: isDark ? 0.08 : 0.05,
                    ),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8,
                    top: 0,
                    child: Icon(
                      Icons.route_rounded,
                      size: 94,
                      color: _cyan.withValues(
                        alpha: isDark ? 0.10 : 0.17,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: _cyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'JOURNEY PLANNER',
                          style: TextStyle(
                            color: _cyan,
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.whereWouldYouLikeToGo,
                        style: TextStyle(
                          fontSize: 29,
                          height: 1.12,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF18233D),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.chooseTransportDescription,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.70)
                              : const Color(0xFF4E5D78),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 27),

            Text(
              l10n.chooseTransportLabel,
              style: TextStyle(
                color: mutedColor,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 13),

            // Bus routes
            _TransportCard(
              title: l10n.busRoutes,
              subtitle: l10n.busRoutesExploreDescription,
              label: l10n.roadTravelLabel,
              icon: Icons.directions_bus_rounded,
              accent: _cyan,
              isDark: isDark,
              gradient: isDark
                  ? const [
                      Color(0xFF112A42),
                      Color(0xFF101A30),
                    ]
                  : const [
                      Color(0xFFE5F6FF),
                      Color(0xFFF4FAFF),
                    ],
              onTap: () => _open(
                context,
                const BusRoutesScreen(),
              ),
            ),

            const SizedBox(height: 16),

            // Train routes
            _TransportCard(
              title: l10n.trainRoutes,
              subtitle: l10n.trainRoutesExploreDescription,
              label: l10n.railTravelLabel,
              icon: Icons.train_rounded,
              accent: _purple,
              isDark: isDark,
              gradient: isDark
                  ? const [
                      Color(0xFF251B48),
                      Color(0xFF17182F),
                    ]
                  : const [
                      Color(0xFFF0E9FF),
                      Color(0xFFFAF7FF),
                    ],
              onTap: () => _open(
                context,
                const TrainRoutesScreen(),
              ),
            ),

            const SizedBox(height: 22),

            // Tip card
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(
                    alpha: isDark ? 0.35 : 0.7,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: _amber,
                    size: 23,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.saveFavouriteRouteTip,
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransportCard extends StatelessWidget {
  const _TransportCard({
    required this.title,
    required this.subtitle,
    required this.label,
    required this.icon,
    required this.accent,
    required this.gradient,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final Color accent;
  final List<Color> gradient;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    
    

    final titleColor = isDark
        ? Colors.white
        : const Color(0xFF1B2942);

    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.70)
        : const Color(0xFF586780);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: accent.withValues(
                alpha: isDark ? 0.28 : 0.35,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(
                  alpha: isDark ? 0.07 : 0.06,
                ),
                blurRadius: 22,
                offset: const Offset(0, 9),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: isDark ? 0.14 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  color: accent,
                  size: 34,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: accent,
                        fontSize: 9,
                        letterSpacing: 1.3,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_rounded,
                color: accent,
                size: 23,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
