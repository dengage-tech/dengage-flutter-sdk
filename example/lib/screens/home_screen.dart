import 'dart:async';

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _notificationChannel =
      EventChannel('com.dengage.flutter/onNotificationClicked');
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    DengageFlutter.setNavigation();
    _notificationSubscription =
        _notificationChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        debugPrint('onNotificationClicked: $event');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Push clicked: ${event.toString()}')),
          );
        }
      },
      onError: (dynamic e) => debugPrint('Notification stream error: $e'),
    );
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  /// Same as iOS: tapping "ASK NOTIFICATIONS" runs prompt and shows result (no separate screen).
  static const String _askNotificationsRoute = '__ask_notifications__';

  static const List<Map<String, String>> _menuItems = [
    {'title': 'ASK NOTIFICATIONS', 'route': _askNotificationsRoute},
    {'title': 'DEVICE INFO', 'route': '/device_info'},
    {'title': 'CHANGE CONTACT KEY', 'route': '/contact_key'},
    {'title': 'INBOX MESSAGES', 'route': '/inbox_messages'},
    {'title': 'IN APP MESSAGE', 'route': '/in_app_message'},
    {'title': 'REAL TIME IN APP MESSAGE', 'route': '/rt_in_app_messages'},
    {'title': 'REAL TIME IN APP FILTERS', 'route': '/real_time_in_app_filters'},
    {'title': 'GEOFENCE', 'route': '/geofence'},
    {'title': 'INAPP INLINE', 'route': '/in_app_inline'},
    {'title': 'APP STORY', 'route': '/app_story'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dengage Example App'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: const Color(0xFFD3D3D3),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  final route = item['route']!;
                  if (route == _askNotificationsRoute) {
                    // iOS SDK: tap "ASK NOTIFICATIONS" → prompt immediately, show result (no navigation)
                    NotificationScreen.requestPushPermission(context);
                    return;
                  }
                  if (route.isNotEmpty) {
                    Navigator.pushNamed(context, route);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: Text(
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
