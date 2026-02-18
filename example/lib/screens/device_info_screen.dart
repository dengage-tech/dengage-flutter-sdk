import 'dart:convert';
import 'dart:io' show Platform;

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({Key? key}) : super(key: key);

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  Map<String, dynamic>? _subscription;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final result = await DengageFlutter.getSubscription();
      if (result == null) {
        setState(() => _error = 'No subscription data');
        return;
      }
      Map<String, dynamic> data;
      if (result is String) {
        data = jsonDecode(result) as Map<String, dynamic>;
      } else if (result is Map) {
        data = Map<String, dynamic>.from(result);
      } else {
        setState(() => _error = 'Unexpected format');
        return;
      }
      setState(() {
        _subscription = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<MapEntry<String, String>> _getFields() {
    if (_subscription == null) return [];
    final s = _subscription!;
    return [
      MapEntry('Integration Key', s['integrationKey']?.toString() ?? ''),
      MapEntry('Device ID', s['udid']?.toString() ?? ''),
      MapEntry('Contact Key', s['contactKey']?.toString() ?? ''),
      MapEntry('User Permission', (s['permission'] == true).toString()),
      MapEntry('Device Token', s['token']?.toString() ?? ''),
      MapEntry('SDK Version', s['sdkVersion']?.toString() ?? ''),
      MapEntry('Device Brand', Platform.operatingSystem),
      MapEntry('Device Model', ''),
      MapEntry('Timezone', s['timezone']?.toString() ?? ''),
      MapEntry('Language', s['language']?.toString() ?? ''),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Device Info'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Device Info'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(child: Text(_error)),
      );
    }
    final fields = _getFields();
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Device Info'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            elevation: 1,
            shadowColor: Colors.black.withValues(alpha: 0.04),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  for (int i = 0; i < fields.length; i++) ...[
                    InkWell(
                      onLongPress: () {
                        final v = fields[i].value;
                        if (v.isNotEmpty) {
                          Clipboard.setData(ClipboardData(text: v));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${fields[i].key} copied to clipboard')),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fields[i].key,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    fields[i].value,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF222222),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < fields.length - 1)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
