import 'dart:convert';

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({Key? key}) : super(key: key);

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  static const List<String> _statuses = ['always', 'appinuse', 'none'];

  String _current = '-';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final result = await DengageFlutter.getSubscription();
      Map<String, dynamic>? data;
      if (result is String) {
        data = jsonDecode(result) as Map<String, dynamic>;
      } else if (result is Map) {
        data = Map<String, dynamic>.from(result);
      }
      if (!mounted) return;
      final value = data?['locationPermission']?.toString() ?? '';
      setState(() => _current = value.isEmpty ? '-' : value);
    } catch (e) {
      debugPrint('getSubscription error: $e');
    }
  }

  Future<void> _apply(String status) async {
    await DengageFlutter.setLocationPermission(status);
    // Native updates its subscription asynchronously, give it a moment.
    await Future.delayed(const Duration(milliseconds: 800));
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Location Permission'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Current location permission',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            const SizedBox(height: 4),
            Text(_current,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            for (final status in _statuses)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2980B9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _apply(status),
                  child: Text('SET "$status"',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
