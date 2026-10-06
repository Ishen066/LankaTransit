import 'package:flutter/material.dart';
import 'route_details_screen.dart';

class TrainRoutesScreen extends StatelessWidget {
  const TrainRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Train Routes',
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

            // ================= SEARCH =================

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

            // ================= COASTAL LINE =================

            _buildTrainRoute(
              context,
              'Coastal Line',
              'Colombo Fort',
              'Galle',
            ),

            // ================= MAIN LINE =================

            _buildTrainRoute(
              context,
              'Main Line',
              'Colombo Fort',
              'Kandy',
            ),

            // ================= PUTTALAM LINE =================

            _buildTrainRoute(
              context,
              'Puttalam Line',
              'Colombo Fort',
              'Puttalam',
            ),

            // ================= NORTHERN LINE =================

            _buildTrainRoute(
              context,
              'Northern Line',
              'Colombo Fort',
              'Jaffna',
            ),
          ],
        ),
      ),
    );
  }

  // ================= TRAIN ROUTE CARD =================

  Widget _buildTrainRoute(
    BuildContext context,
    String line,
    String start,
    String destination,
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

        // ================= ROUTE DETAILS =================

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
              ),
            ),
          );
        },
      ),
    );
  }
}