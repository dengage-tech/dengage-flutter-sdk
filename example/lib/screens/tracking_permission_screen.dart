import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class TrackingPermissionScreen extends StatefulWidget {
  const TrackingPermissionScreen({Key? key}) : super(key: key);

  @override
  State<TrackingPermissionScreen> createState() =>
      _TrackingPermissionScreenState();
}

class _TrackingPermissionScreenState extends State<TrackingPermissionScreen> {
  bool _trackingPermission = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadTrackingPermission();
  }

  Future<void> _loadTrackingPermission() async {
    try {
      final permission = await DengageFlutter.getTrackingPermission();
      if (mounted) {
        setState(() {
          _trackingPermission = permission == true;
          _initialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error fetching tracking permission: $e');
      if (mounted) setState(() => _initialized = true);
    }
  }

  Future<void> _toggleTrackingPermission(bool value) async {
    setState(() => _trackingPermission = value);
    await DengageFlutter.setTrackingPermission(value);
    debugPrint('trackingPermission: $value');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Change Tracking Permission'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _initialized
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tracking Permission',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  Switch(
                    value: _trackingPermission,
                    onChanged: _toggleTrackingPermission,
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
