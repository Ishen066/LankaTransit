import 'package:flutter/material.dart';

void main() {
  runApp(const LankaTransitApp());
}

class LankaTransitApp extends StatelessWidget {
  const LankaTransitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LankaTransit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------- SPLASH SCREEN ----------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.directions_bus,
              size: 100,
              color: Colors.green,
            ),

            const SizedBox(height: 20),

            const Text(
              'LankaTransit',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Smart Travel Across Sri Lanka',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- HOME SCREEN ----------------

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LankaTransit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Where are you going?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Find the best public transport route in Sri Lanka.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              decoration: InputDecoration(
                hintText: 'Search destination',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Transport',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        children: const [

                          Icon(
                            Icons.directions_bus,
                            size: 40,
                            color: Colors.green,
                          ),

                          SizedBox(height: 10),

                          Text(
                            'Bus',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        children: const [

                          Icon(
                            Icons.train,
                            size: 40,
                            color: Colors.blue,
                          ),

                          SizedBox(height: 10),

                          Text(
                            'Train',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}