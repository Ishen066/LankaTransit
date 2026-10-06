import 'package:flutter/material.dart';
import 'route_details_screen.dart';

class BusRoutesScreen extends StatelessWidget {
  const BusRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Routes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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

            // SEARCH
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

            // BUS ROUTE 1
            _buildBusRoute(
              context,
              '138',
              'Colombo',
              'Kaduwela',
            ),

            // BUS ROUTE 2
            _buildBusRoute(
              context,
              '100',
              'Panadura',
              'Colombo',
            ),

            // BUS ROUTE 3
            _buildBusRoute(
              context,
              '02',
              'Galle',
              'Colombo',
            ),

            // BUS ROUTE 4
            _buildBusRoute(
              context,
              '03',
              'Colombo',
              'Kandy',
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

        // ================= ROUTE DETAILS =================

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
              ),
            ),
          );
        },
      ),
    );
  }
}