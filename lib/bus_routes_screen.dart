import 'package:flutter/material.dart';
import 'route_coordinates.dart';
import 'route_details_screen.dart';

class BusRoutesScreen extends StatelessWidget {
  const BusRoutesScreen({super.key});

  static const Color primaryGreen = Color(0xFF087F5B);
  static const Color lightGreen = Color(0xFFE8F5EF);
  static const Color background = Color(0xFFF6F8F7);
  static const Color darkText = Color(0xFF173B32);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Bus Routes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const Text(
              'Find Your Bus Route',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Explore bus routes and find your destination easily.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            // SEARCH BAR
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search bus number or destination',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: primaryGreen,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // SECTION HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Bus Routes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '4 Routes',
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            _buildBusRoute(
              context,
              '138',
              'Colombo',
              'Kaduwela',
              const RouteCoordinates(
                startLat: 6.9271,
                startLng: 79.8612,
                endLat: 6.9360,
                endLng: 79.9840,
              ),
            ),

            _buildBusRoute(
              context,
              '100',
              'Panadura',
              'Colombo',
              const RouteCoordinates(
                startLat: 6.7132,
                startLng: 79.9074,
                endLat: 6.9271,
                endLng: 79.8612,
              ),
            ),

            _buildBusRoute(
              context,
              '02',
              'Galle',
              'Colombo',
              const RouteCoordinates(
                startLat: 6.0329,
                startLng: 80.2168,
                endLat: 6.9271,
                endLng: 79.8612,
              ),
            ),

            _buildBusRoute(
              context,
              '03',
              'Colombo',
              'Kandy',
              const RouteCoordinates(
                startLat: 6.9271,
                startLng: 79.8612,
                endLat: 7.2906,
                endLng: 80.6337,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusRoute(
    BuildContext context,
    String busNumber,
    String start,
    String destination,
    RouteCoordinates coordinates,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RouteDetailsScreen(
                  transportType: 'Bus Route',
                  routeName: busNumber,
                  from: start,
                  to: destination,
                  icon: Icons.directions_bus_rounded,
                  iconColor: primaryGreen,
                  startLat: coordinates.startLat,
                  startLng: coordinates.startLng,
                  endLat: coordinates.endLat,
                  endLng: coordinates.endLng,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  children: [
                    // BUS NUMBER
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: lightGreen,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.directions_bus_rounded,
                            color: primaryGreen,
                            size: 21,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            busNumber,
                            style: const TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // ROUTE INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'BUS ROUTE',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$start → $destination',
                            style: const TextStyle(
                              color: darkText,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ARROW
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: primaryGreen,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // DIVIDER
                const Divider(
                  height: 1,
                  color: Color(0xFFEFF2F0),
                ),

                const SizedBox(height: 13),

                // BOTTOM INFO
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '$start to $destination',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.map_outlined,
                      size: 17,
                      color: primaryGreen,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'View Route',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}