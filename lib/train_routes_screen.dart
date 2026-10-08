import 'package:flutter/material.dart';
import 'route_coordinates.dart';
import 'route_details_screen.dart';

class TrainRoutesScreen extends StatelessWidget {
  const TrainRoutesScreen({super.key});

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFFEFF4FF);
  static const Color background = Color(0xFFF6F8F7);
  static const Color darkText = Color(0xFF172B4D);

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
          'Train Routes',
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
            const Text(
              'Find Your Train Route',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Explore railway lines and find your destination easily.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            // Search bar
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
                  hintText: 'Search railway line or destination',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: primaryBlue,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Section title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Train Routes',
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
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '4 Routes',
                    style: TextStyle(
                      color: primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Coastal Line
            _buildTrainRoute(
              context,
              'Coastal Line',
              'Colombo Fort',
              'Galle',
              const RouteCoordinates(
                startLat: 6.9344,
                startLng: 79.8428,
                endLat: 6.0329,
                endLng: 80.2168,
              ),
              const [
                [6.9344, 79.8428],
                [6.9060, 79.8530],
                [6.8760, 79.8600],
                [6.8380, 79.8650],
                [6.7150, 79.9070],
                [6.5850, 79.9600],
                [6.4200, 80.0000],
                [6.2800, 80.0300],
                [6.1400, 80.1100],
                [6.0900, 80.1400],
                [6.0329, 80.2168],
              ],
            ),

            // Main Line
            _buildTrainRoute(
              context,
              'Main Line',
              'Colombo Fort',
              'Kandy',
              const RouteCoordinates(
                startLat: 6.9344,
                startLng: 79.8428,
                endLat: 7.2906,
                endLng: 80.6337,
              ),
              const [
                [6.9344, 79.8428],
                [6.9310, 79.8610],
                [7.0840, 79.9580],
                [7.1500, 80.0500],
                [7.2500, 80.1200],
                [7.2900, 80.3500],
                [7.2500, 80.5000],
                [7.2906, 80.6337],
              ],
            ),

            // Puttalam Line
            _buildTrainRoute(
              context,
              'Puttalam Line',
              'Colombo Fort',
              'Puttalam',
              const RouteCoordinates(
                startLat: 6.9344,
                startLng: 79.8428,
                endLat: 8.0362,
                endLng: 79.8283,
              ),
              const [
                [6.9344, 79.8428],
                [6.9500, 79.8700],
                [7.0300, 79.8900],
                [7.1600, 79.8700],
                [7.2080, 79.8400],
                [7.2900, 79.8700],
                [7.4500, 79.9000],
                [7.6000, 79.8500],
                [7.8000, 79.8200],
                [8.0362, 79.8283],
              ],
            ),

            // Northern Line
            _buildTrainRoute(
              context,
              'Northern Line',
              'Colombo Fort',
              'Jaffna',
              const RouteCoordinates(
                startLat: 6.9344,
                startLng: 79.8428,
                endLat: 9.6615,
                endLng: 80.0255,
              ),
              const [
                [6.9344, 79.8428],
                [7.0300, 79.8900],
                [7.2800, 80.2000],
                [7.4800, 80.3500],
                [7.7500, 80.5000],
                [8.1200, 80.6000],
                [8.4500, 80.5000],
                [8.7500, 80.5000],
                [9.0500, 80.0000],
                [9.3500, 80.0000],
                [9.6615, 80.0255],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainRoute(
    BuildContext context,
    String line,
    String start,
    String destination,
    RouteCoordinates coordinates,
    List<List<double>> routePath,
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
                  transportType: 'Train Route',
                  routeName: line,
                  from: start,
                  to: destination,
                  icon: Icons.train_rounded,
                  iconColor: primaryBlue,
                  startLat: coordinates.startLat,
                  startLng: coordinates.startLng,
                  endLat: coordinates.endLat,
                  endLng: coordinates.endLng,
                  routePath: routePath,
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
                    // Train icon + line
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.train_rounded,
                            color: primaryBlue,
                            size: 21,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            line.split(' ').first,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Route information
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'TRAIN ROUTE',
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
                          const SizedBox(height: 4),
                          Text(
                            line,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: primaryBlue,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                const Divider(
                  height: 1,
                  color: Color(0xFFEFF2F0),
                ),

                const SizedBox(height: 13),

                // Bottom information
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '$start to $destination',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.map_outlined,
                      size: 17,
                      color: primaryBlue,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'View Route',
                      style: TextStyle(
                        color: primaryBlue,
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