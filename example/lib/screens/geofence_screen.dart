import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class GeofenceScreen extends StatelessWidget {
  const GeofenceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Geofence'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await DengageFlutter.requestLocationPermissions();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Location permission requested')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Request Location Always Authorization'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await DengageFlutter.startGeofence();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Start Geofence')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Start Geofence'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                await DengageFlutter.stopGeofence();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Stop Geofence')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Stop Geofence'),
            ),
          ],
        ),
      ),
    );
  }
}
