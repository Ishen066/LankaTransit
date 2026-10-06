import 'package:flutter/material.dart';

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

            // SEARCH
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

            _buildTrainRoute(
              'Coastal Line',
              'Colombo Fort',
              'Galle',
            ),

            _buildTrainRoute(
              'Main Line',
              'Colombo Fort',
              'Kandy',
            ),

            _buildTrainRoute(
              'Puttalam Line',
              'Colombo Fort',
              'Puttalam',
            ),

            _buildTrainRoute(
              'Northern Line',
              'Colombo Fort',
              'Jaffna',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainRoute(
    String lineName,
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
          child: Icon(Icons.train),
        ),

        title: Text(
          lineName,
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

        onTap: () {},
      ),
    );
  }
}