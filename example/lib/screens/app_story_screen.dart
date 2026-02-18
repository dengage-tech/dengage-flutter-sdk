import 'package:flutter/material.dart';

/// App Story (Stories list) is not exposed as a Flutter widget in the SDK.
/// Use React or native SDK for full App Story UI.
class AppStoryScreen extends StatelessWidget {
  const AppStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('App Story'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'App Story (Stories list view) is not available in the Flutter SDK. '
            'Use the React Native or native (iOS/Android) example apps for full App Story functionality.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
        ),
      ),
    );
  }
}
