import 'package:flutter/material.dart';

class RecentJourneysScreen extends StatelessWidget {
  const RecentJourneysScreen({super.key});

  static const Color bg = Color(0xFF0B1220);
  static const Color panel = Color(0xFF172337);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color purple = Color(0xFF9B87F5);
  static const Color muted = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Recent Journeys',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your travel history',
            style: TextStyle(color: muted, fontSize: 14),
          ),
          const SizedBox(height: 22),

          _journeyCard(
            icon: Icons.directions_bus_rounded,
            iconColor: cyan,
            iconBg: const Color(0xFF164E63),
            from: 'Colombo Fort',
            to: 'Kandy',
            type: 'Bus Journey',
            date: '21 Oct 2026',
            time: '8:30 AM',
          ),

          const SizedBox(height: 16),

          _journeyCard(
            icon: Icons.train_rounded,
            iconColor: purple,
            iconBg: const Color(0xFF3B2866),
            from: 'Colombo Fort',
            to: 'Galle',
            type: 'Train Journey',
            date: '19 Oct 2026',
            time: '10:15 AM',
          ),

          const SizedBox(height: 16),

          _journeyCard(
            icon: Icons.directions_bus_rounded,
            iconColor: cyan,
            iconBg: const Color(0xFF164E63),
            from: 'Kandy',
            to: 'Peradeniya',
            type: 'Bus Journey',
            date: '17 Oct 2026',
            time: '2:45 PM',
          ),

          const SizedBox(height: 24),

          const Center(
            child: Text(
              'Sample journeys are displayed for now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _journeyCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String from,
    required String to,
    required String type,
    required String date,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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
                child: Icon(icon, color: iconColor, size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$from → $to',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF34D399),
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.08)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_month_rounded, color: muted, size: 17),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  date,
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
              ),
              const Icon(Icons.access_time_rounded, color: muted, size: 17),
              const SizedBox(width: 5),
              Text(time, style: const TextStyle(color: muted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
