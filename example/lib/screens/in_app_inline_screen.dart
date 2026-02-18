import 'dart:collection';

import 'package:dengage_flutter/InAppInline.dart';
import 'package:flutter/material.dart';

class InAppInlineScreen extends StatefulWidget {
  const InAppInlineScreen({Key? key}) : super(key: key);

  @override
  State<InAppInlineScreen> createState() => _InAppInlineScreenState();
}

class _InAppInlineScreenState extends State<InAppInlineScreen> {
  final _propertyIdController = TextEditingController(text: '1');
  final _screenNameController = TextEditingController(text: 'inline');
  bool _showInline = false;

  @override
  void dispose() {
    _propertyIdController.dispose();
    _screenNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('InApp Inline'),
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
                hintText: 'Property ID',
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
              onPressed: () => setState(() => _showInline = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
              ),
              child: const Text('Show InApp Inline'),
            ),
            if (_showInline) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 244,
                child: InAppInline(
                  propertyId: _propertyIdController.text.trim().isEmpty
                      ? '1'
                      : _propertyIdController.text.trim(),
                  screenName: _screenNameController.text.trim().isEmpty
                      ? 'inline'
                      : _screenNameController.text.trim(),
                  customParams: HashMap<String, String>(),
                  hideIfNotFound: false,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
