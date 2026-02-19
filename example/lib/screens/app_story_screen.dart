import 'dart:collection';

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

/// App Story (stories list) is displayed via the [AppStoryView] widget,
/// which embeds the native Dengage story list view (same as iOS/Android/Cordova/React Native SDKs).
class AppStoryScreen extends StatefulWidget {
  const AppStoryScreen({Key? key}) : super(key: key);

  @override
  State<AppStoryScreen> createState() => _AppStoryScreenState();
}

class _AppStoryScreenState extends State<AppStoryScreen> {
  final _propertyIdController = TextEditingController(text: '4');
  final _screenNameController = TextEditingController(text: 'appstory');
  bool _showAppStory = false;

  @override
  void dispose() {
    _propertyIdController.dispose();
    _screenNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyId = _propertyIdController.text.trim().isEmpty
        ? '4'
        : _propertyIdController.text.trim();
    final screenName = _screenNameController.text.trim().isEmpty
        ? 'appstory'
        : _screenNameController.text.trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('App Story'),
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
              controller: _propertyIdController,
              decoration: const InputDecoration(
                hintText: 'Story Property ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _screenNameController,
              decoration: const InputDecoration(
                hintText: 'Screen Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => _showAppStory = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
              ),
              child: const Text('Show App Story'),
            ),
            if (_showAppStory) ...[
              const SizedBox(height: 16),
              const Text(
                'Story list is shown below. Configure in Dengage dashboard (Content > Marketing > In-App, Story template).',
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 320,
                child: AppStoryView(
                  key: ValueKey('appstory_${propertyId}_$screenName'),
                  propertyId: propertyId,
                  screenName: screenName,
                  customParams: HashMap<String, String>(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
