
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';

class RecentJourneysScreen extends StatelessWidget {
  const RecentJourneysScreen({super.key});

  static const Color cyan = Color(0xFF22D3EE);
  static const Color purple = Color(0xFF9B87F5);
  static const Color success = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final mutedColor = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.65 : 0.60,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          l10n.recentJourneys,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.yourTravelHistory,
            style: TextStyle(
              color: mutedColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 22),

          _journeyCard(
            context: context,
            icon: Icons.directions_bus_rounded,
            iconColor: cyan,
            iconBg: const Color(0xFF164E63),
            from: 'Colombo Fort',
            to: 'Kandy',
            type: l10n.busJourney,
            date: '21 Oct 2026',
            time: '8:30 AM',
          ),

          const SizedBox(height: 16),

          _journeyCard(
            context: context,
            icon: Icons.train_rounded,
            iconColor: purple,
            iconBg: const Color(0xFF3B2866),
            from: 'Colombo Fort',
            to: 'Galle',
            type: l10n.trainJourney,
            date: '19 Oct 2026',
            time: '10:15 AM',
          ),

          const SizedBox(height: 16),

          _journeyCard(
            context: context,
            icon: Icons.directions_bus_rounded,
            iconColor: cyan,
            iconBg: const Color(0xFF164E63),
            from: 'Kandy',
            to: 'Peradeniya',
            type: l10n.busJourney,
            date: '17 Oct 2026',
            time: '2:45 PM',
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              l10n.sampleJourneysMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mutedColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _journeyCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String from,
    required String to,
    required String type,
    required String date,
    required String time,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = colorScheme.surfaceContainer;
    final primaryTextColor = colorScheme.onSurface;
    final mutedColor = colorScheme.onSurface.withValues(
      alpha: isDark ? 0.65 : 0.60,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: isDark
                            ? iconColor
                            : Color.lerp(
                                iconColor,
                                Colors.black,
                                0.20,
                              ),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$from → $to',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: success,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: mutedColor,
                size: 17,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  date,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                Icons.access_time_rounded,
                color: mutedColor,
                size: 17,
              ),
              const SizedBox(width: 5),
              Text(
                time,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
