import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final String hospitalName;
  final double lat;
  final double lng;

  const MapScreen({
    super.key,
    required this.hospitalName,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route to Hospital')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Navigation to $hospitalName',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Coordinates: $lat, $lng'),
                    const SizedBox(height: 32),
                    const Text(
                      'PLATFORM INTEGRATION POINT:\nExternal Map App would open here',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Future: Add code to launch Google Maps / Apple Maps via URL scheme
                // Example: 'google.navigation:q=$lat,$lng'
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening external navigation...')),
                );
              },
              icon: const Icon(Icons.navigation),
              label: const Text('Open in Google Maps'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
