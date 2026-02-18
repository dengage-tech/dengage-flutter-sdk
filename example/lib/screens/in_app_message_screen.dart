import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class InAppMessageScreen extends StatefulWidget {
  const InAppMessageScreen({Key? key}) : super(key: key);

  @override
  State<InAppMessageScreen> createState() => _InAppMessageScreenState();
}

class _InAppMessageScreenState extends State<InAppMessageScreen> {
  final _screenNameController = TextEditingController();

  @override
  void dispose() {
    _screenNameController.dispose();
    super.dispose();
  }

  void _setNavigation() {
    final name = _screenNameController.text.trim();
    if (name.isNotEmpty) {
      DengageFlutter.setNavigationWithName(name);
    } else {
      DengageFlutter.setNavigation();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigation set')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('In App Message'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _screenNameController,
              decoration: const InputDecoration(
                hintText: 'Screen Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _setNavigation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
              ),
              child: const Text('Set Navigation'),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Device Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'In-app device info (setInAppDeviceInfo / clearInAppDeviceInfo) is not exposed in Flutter SDK. Use native or React SDK for full device info keys.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
