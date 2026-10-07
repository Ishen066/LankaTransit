import 'package:flutter/material.dart';
import 'route_coordinates.dart';
import 'route_details_screen.dart';

class TrainRoutesScreen extends StatelessWidget {
  const TrainRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Train Routes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find Your Train Route',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Search for trains and their destinations.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search station or destination',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Popular Train Routes',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
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
                [6.9344, 79.8428], // Colombo Fort
                [6.9060, 79.8530], // Maradana
                [6.8760, 79.8600], // Dehiwala
                [6.8380, 79.8650], // Mount Lavinia
                [6.7150, 79.9070], // Panadura
                [6.5850, 79.9600], // Kalutara
                [6.4200, 80.0000], // Beruwala
                [6.2800, 80.0300], // Bentota
                [6.1400, 80.1100], // Ambalangoda
                [6.0900, 80.1400], // Hikkaduwa
                [6.0329, 80.2168], // Galle
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
                [6.9344, 79.8428], // Colombo Fort
                [6.9310, 79.8610], // Maradana
                [7.0840, 79.9580], // Gampaha area
                [7.1500, 80.0500], // Veyangoda
                [7.2500, 80.1200], // Polgahawela area
                [7.2900, 80.3500], // Rambukkana area
                [7.2500, 80.5000], // Peradeniya
                [7.2906, 80.6337], // Kandy
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
                [6.9344, 79.8428], // Colombo Fort
                [6.9500, 79.8700], // Maradana
                [7.0300, 79.8900], // Ragama
                [7.1600, 79.8700], // Ja-Ela
                [7.2080, 79.8400], // Katunayake
                [7.2900, 79.8700], // Negombo
                [7.4500, 79.9000], // Kochchikade
                [7.6000, 79.8500], // Chilaw area
                [7.8000, 79.8200],
                [8.0362, 79.8283], // Puttalam
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
                [6.9344, 79.8428], // Colombo Fort
                [7.0300, 79.8900], // Ragama
                [7.2800, 80.2000], // Polgahawela
                [7.4800, 80.3500], // Kurunegala area
                [7.7500, 80.5000], // Maho area
                [8.1200, 80.6000], // Anuradhapura
                [8.4500, 80.5000], // North Central
                [8.7500, 80.5000], // Vavuniya
                [9.0500, 80.0000], // Kilinochchi area
                [9.3500, 80.0000],
                [9.6615, 80.0255], // Jaffna
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
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: const CircleAvatar(
          radius: 28,
          backgroundColor: Color(0xFFEFF4FF),
          child: Icon(
            Icons.train_rounded,
            color: Color(0xFF2563EB),
            size: 28,
          ),
        ),

        title: Text(
          line,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          '$start → $destination',
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
        ),

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
                iconColor: const Color(0xFF2563EB),

                startLat: coordinates.startLat,
                startLng: coordinates.startLng,
                endLat: coordinates.endLat,
                endLng: coordinates.endLng,

                routePath: routePath,
              ),
            ),
          );
        },
      ),
    );
  }
}