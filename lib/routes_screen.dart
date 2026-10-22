import 'package:flutter/material.dart';

import 'bus_routes_screen.dart';
import 'train_routes_screen.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  static const Color _background = Color(0xFF070B18);
  static const Color _cyan = Color(0xFF38BDF8);
  static const Color _purple = Color(0xFF8B5CF6);

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        title: const Text(
          'Explore Routes',
          style: TextStyle(fontWeight: FontWeight.w800),
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
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF172C4A),
                    Color(0xFF171A38),
                    Color(0xFF241A46),
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.09)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -8,
                    top: 0,
                    child: Icon(
                      Icons.route_rounded,
                      size: 94,
                      color: _cyan.withValues(alpha: 0.10),
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
                          color: _cyan.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'SRI LANKA • JOURNEY PLANNER',
                          style: TextStyle(
                            color: _cyan,
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Where would you\nlike to go?',
                        style: TextStyle(
                          fontSize: 29,
                          height: 1.12,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Choose your transport and find a route that fits your journey.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 27),
            const Text(
              'CHOOSE TRANSPORT',
              style: TextStyle(
                color: Color(0xFF9AA9C5),
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 13),
            _TransportCard(
              title: 'Bus Routes',
              subtitle:
                  'Explore bus routes and plan your trip across the island.',
              label: 'ROAD TRAVEL',
              icon: Icons.directions_bus_rounded,
              accent: _cyan,
              gradient: const [Color(0xFF112A42), Color(0xFF101A30)],
              onTap: () => _open(context, const BusRoutesScreen()),
            ),
            const SizedBox(height: 16),
            _TransportCard(
              title: 'Train Routes',
              subtitle:
                  'Discover railway journeys, stations and scenic routes.',
              label: 'RAIL TRAVEL',
              icon: Icons.train_rounded,
              accent: _purple,
              gradient: const [Color(0xFF251B48), Color(0xFF17182F)],
              onTap: () => _open(context, const TrainRoutesScreen()),
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF111A2E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Color(0xFFFBBF24),
                    size: 23,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tip: Save a route with the heart icon to find it quickly in Favourite Routes.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
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
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final Color accent;
  final List<Color> gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            border: Border.all(color: accent.withValues(alpha: 0.28)),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.07),
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
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: accent, size: 34),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.68),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: accent, size: 23),
            ],
          ),
        ),
      ),
    );
  }
}
