import 'package:flutter/material.dart';

class RealTimeInAppFiltersScreen extends StatelessWidget {
  const RealTimeInAppFiltersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Real Time In App Filters'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _menuButton(
            context,
            'Event History',
            () => Navigator.pushNamed(context, '/event_history'),
          ),
          const SizedBox(height: 8),
          _menuButton(
            context,
            'Cart',
            () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
    );
  }

  Widget _menuButton(
      BuildContext context, String title, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFD3D3D3),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
