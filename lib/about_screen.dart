
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color _cyan = Color(0xFF22D3EE);
  static const Color _purple = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final muted = colors.onSurface.withValues(
      alpha: isDark ? 0.70 : 0.65,
    );

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.aboutLankaTransit,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo and introduction
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_cyan, _purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: _cyan.withValues(alpha: 0.18),
                          blurRadius: 22,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'LankaTransit',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Travel Smarter, Travel Better',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _cyan,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.aboutCompanion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _SectionHeading(title: l10n.aboutOurApp),
            const SizedBox(height: 12),

            _InfoCard(
              child: Text(
                l10n.aboutDescription,
                style: TextStyle(
                  color: muted,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ),

            const SizedBox(height: 25),

            _SectionHeading(title: l10n.keyFeatures),
            const SizedBox(height: 12),

            _FeatureTile(
              icon: Icons.directions_bus_rounded,
              title: l10n.busRoutes,
              subtitle: l10n.aboutBusDescription,
            ),
            const SizedBox(height: 10),

            _FeatureTile(
              icon: Icons.train_rounded,
              title: l10n.trainRoutes,
              subtitle: l10n.aboutTrainDescription,
            ),
            const SizedBox(height: 10),

            _FeatureTile(
              icon: Icons.location_on_rounded,
              title: l10n.nearbyTransport,
              subtitle: l10n.aboutNearbyDescription,
            ),
            const SizedBox(height: 10),

            _FeatureTile(
              icon: Icons.favorite_rounded,
              title: l10n.favouriteRoutes,
              subtitle: l10n.aboutFavouritesDescription,
            ),
            const SizedBox(height: 10),

            _FeatureTile(
              icon: Icons.history_rounded,
              title: l10n.recentJourneys,
              subtitle: l10n.aboutRecentDescription,
            ),

            const SizedBox(height: 25),

            _SectionHeading(title: l10n.appInformation),
            const SizedBox(height: 12),

            _InfoCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.apps_rounded,
                    label: l10n.application,
                    value: 'LankaTransit',
                  ),
                  _buildDivider(context),
                  _InfoRow(
                    icon: Icons.phone_android_rounded,
                    label: l10n.platform,
                    value: 'Flutter',
                  ),
                  _buildDivider(context),
                  _InfoRow(
                    icon: Icons.public_rounded,
                    label: l10n.coverage,
                    value: l10n.sriLanka,
                  ),
                  _buildDivider(context),
                  _InfoRow(
                    icon: Icons.info_outline_rounded,
                    label: l10n.version,
                    value: '1.0.0',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Footer
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite_rounded,
                    color: _purple,
                    size: 22,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.madeForSmarterJourneys,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'LankaTransit © 2026',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget _buildDivider(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Divider(
      color: colors.outlineVariant.withValues(alpha: 0.55),
      height: 24,
    );
  }
}

// Section heading
class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AboutScreen._cyan,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Reusable information card
class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.55),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: child,
    );
  }
}

// Feature tile with its own icon
class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.55),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.025),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AboutScreen._cyan.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AboutScreen._cyan,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colors.onSurface.withValues(
                      alpha: isDark ? 0.70 : 0.65,
                    ),
                    fontSize: 12,
                    height: 1.5,
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

// Application information row
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          color: AboutScreen._cyan,
          size: 21,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: colors.onSurface.withValues(alpha: 0.65),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
