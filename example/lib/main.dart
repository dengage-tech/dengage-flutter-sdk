import 'package:flutter/material.dart';

import 'screens/notification_screen.dart';
import 'screens/device_info_screen.dart';
import 'screens/contact_key_screen.dart';
import 'screens/inbox_messages_screen.dart';
import 'screens/in_app_message_screen.dart';
import 'screens/rt_in_app_messages_screen.dart';
import 'screens/real_time_in_app_filters_screen.dart';
import 'screens/event_history_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/geofence_screen.dart';
import 'screens/in_app_inline_screen.dart';
import 'screens/app_story_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dengage Example App',
      theme: ThemeData(
        primaryColor: const Color(0xFF007AFF),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF007AFF)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/device_info': (context) => const DeviceInfoScreen(),
        '/contact_key': (context) => const ContactKeyScreen(),
        '/inbox_messages': (context) => const InboxMessagesScreen(),
        '/in_app_message': (context) => const InAppMessageScreen(),
        '/rt_in_app_messages': (context) => const RTInAppMessagesScreen(),
        '/real_time_in_app_filters': (context) =>
            const RealTimeInAppFiltersScreen(),
        '/event_history': (context) => const EventHistoryScreen(),
        '/cart': (context) => const CartScreen(),
        '/geofence': (context) => const GeofenceScreen(),
        '/in_app_inline': (context) => const InAppInlineScreen(),
        '/app_story': (context) => const AppStoryScreen(),
      },
    );
  }
}
