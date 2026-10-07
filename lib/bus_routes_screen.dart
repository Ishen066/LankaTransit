import 'package:flutter/material.dart';
import 'route_coordinates.dart';
import 'route_details_screen.dart';

class BusRoutesScreen extends StatelessWidget {
  const BusRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Routes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find Your Bus Route',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Search for buses and their destinations.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search bus number or destination',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Popular Bus Routes',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // 138
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

            // 100
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

            // 02
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

            // 03
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
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFE8F5EF),
          child: Text(
            busNumber,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF087F5B),
            ),
          ),
        ),

        title: Text(
          '$start → $destination',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(
          'Bus Route $busNumber',
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
                transportType: 'Bus Route',
                routeName: busNumber,
                from: start,
                to: destination,
                icon: Icons.directions_bus_rounded,
                iconColor: const Color(0xFF087F5B),

                startLat: coordinates.startLat,
                startLng: coordinates.startLng,
                endLat: coordinates.endLat,
                endLng: coordinates.endLng,
              ),
            ),
          );
        },
      ),
    );
  }
}