import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const Color _bg = Color(0xFF0B1220);
  static const Color _cyan = Color(0xFF22D3EE);
  static const Color _purple = Color(0xFF8B5CF6);
  static const Color _textColor = Color(0xFFF1F5F9);
  static const Color _muted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: _textColor,
        elevation: 0,
        title: const Text(
          'About LankaTransit',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: Colors.white,
                      size: 55,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'LankaTransit',
                    style: TextStyle(
                      color: _textColor,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your travel companion for exploring Sri Lanka.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _muted, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const _SectionHeading(title: 'About Our App'),
            const SizedBox(height: 12),
            const _InfoCard(
              child: Text(
                'LankaTransit helps users explore bus and train routes '
                'across Sri Lanka. It provides a simple interface to '
                'discover transport options and organise journeys.',
                style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
              ),
            ),

            const SizedBox(height: 25),
            const _SectionHeading(title: 'Key Features'),
            const SizedBox(height: 12),

            const _FeatureTile(
              icon: Icons.directions_bus_rounded,
              title: 'Bus Routes',
              subtitle: 'Explore available bus route information.',
            ),
            const SizedBox(height: 10),
            const _FeatureTile(
              icon: Icons.train_rounded,
              title: 'Train Routes',
              subtitle: 'Discover train route information.',
            ),
            const SizedBox(height: 10),
            const _FeatureTile(
              icon: Icons.location_on_rounded,
              title: 'Nearby Transport',
              subtitle: 'Explore nearby transport options.',
            ),
            const SizedBox(height: 10),
            const _FeatureTile(
              icon: Icons.favorite_rounded,
              title: 'Favourite Routes',
              subtitle: 'Access your saved favourite routes.',
            ),
            const SizedBox(height: 10),
            const _FeatureTile(
              icon: Icons.history_rounded,
              title: 'Recent Journeys',
              subtitle: 'View your recent journey list.',
            ),

            const SizedBox(height: 25),
            const _SectionHeading(title: 'App Information'),
            const SizedBox(height: 12),
            const _InfoCard(
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.apps_rounded,
                    label: 'Application',
                    value: 'LankaTransit',
                  ),
                  Divider(color: Color(0xFF29384D), height: 24),
                  _InfoRow(
                    icon: Icons.phone_android_rounded,
                    label: 'Platform',
                    value: 'Flutter',
                  ),
                  Divider(color: Color(0xFF29384D), height: 24),
                  _InfoRow(
                    icon: Icons.public_rounded,
                    label: 'Coverage',
                    value: 'Sri Lanka',
                  ),
                  Divider(color: Color(0xFF29384D), height: 24),
                  _InfoRow(
                    icon: Icons.info_outline_rounded,
                    label: 'Version',
                    value: '1.0.0',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.favorite_rounded, color: _purple, size: 22),
                  SizedBox(height: 8),
                  Text(
                    'Made for smarter journeys',
                    style: TextStyle(color: _muted, fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'LankaTransit © 2026',
                    style: TextStyle(color: _muted, fontSize: 12),
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
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF22D3EE),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;

  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF172337),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: child,
    );
  }
}

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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF172337),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF29384D)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF22D3EE).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF22D3EE), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFF1F5F9),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                    height: 1.4,
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
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon, color: Color(0xFF22D3EE), size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Color(0xFFF1F5F9),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
