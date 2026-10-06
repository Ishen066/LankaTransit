import 'package:flutter/material.dart';

class RouteDetailsScreen extends StatelessWidget {
  final String transportType;
  final String routeName;
  final String from;
  final String to;
  final IconData icon;
  final Color iconColor;

  const RouteDetailsScreen({
    super.key,
    required this.transportType,
    required this.routeName,
    required this.from,
    required this.to,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),

      appBar: AppBar(
        title: const Text(
          'Route Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= ROUTE HEADER =================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [

                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      icon,
                      size: 34,
                      color: iconColor,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    routeName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    transportType,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ================= JOURNEY =================

            const Text(
              'Journey',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [

                  _LocationRow(
                    icon: Icons.radio_button_checked,
                    color: Colors.green,
                    title: 'Starting Point',
                    location: from,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 11,
                      top: 4,
                      bottom: 4,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 2,
                        height: 35,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),

                  _LocationRow(
                    icon: Icons.location_on,
                    color: Colors.red,
                    title: 'Destination',
                    location: to,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= TRIP INFORMATION =================

            const Text(
              'Trip Information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Expanded(
                  child: _InfoCard(
                    icon: Icons.access_time,
                    title: 'Duration',
                    value: '1h 30m',
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _InfoCard(
                    icon: Icons.payments_outlined,
                    title: 'Estimated Fare',
                    value: 'Rs. 150',
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [

                Expanded(
                  child: _InfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Stops',
                    value: '12 Stops',
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _InfoCard(
                    icon: Icons.schedule,
                    title: 'Frequency',
                    value: 'Every 20m',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= MAIN STOPS =================

            const Text(
              'Main Stops',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [

                  _StopItem(
                    number: '01',
                    name: 'Starting Point',
                  ),

                  _StopItem(
                    number: '02',
                    name: 'Main Junction',
                  ),

                  _StopItem(
                    number: '03',
                    name: 'City Centre',
                  ),

                  _StopItem(
                    number: '04',
                    name: 'Town Hall',
                  ),

                  _StopItem(
                    number: '05',
                    name: 'Destination',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ================= FAVOURITE BUTTON =================

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Route added to favourites',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text(
                  'Add to Favourites',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ================= LOCATION ROW =================

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String location;

  const _LocationRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          icon,
          color: color,
          size: 24,
        ),

        const SizedBox(width: 15),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              location,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ================= INFO CARD =================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ================= STOP ITEM =================

class _StopItem extends StatelessWidget {
  final String number;
  final String name;

  const _StopItem({
    required this.number,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [

          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Color(0xFF087F5B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}