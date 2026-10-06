import 'dart:convert';

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _subscriptionText = '';
  String _error = '';
  bool _loading = false;

  Future<void> _showSubscription() async {
    setState(() {
      _loading = true;
      _error = '';
      _subscriptionText = '';
    });

    try {
      final result = await DengageFlutter.getSubscription();
      Map<String, dynamic> data;

      if (result == null) {
        throw Exception('No subscription data');
      } else if (result is String) {
        data = jsonDecode(result) as Map<String, dynamic>;
      } else if (result is Map) {
        data = Map<String, dynamic>.from(result);
      } else {
        throw Exception('Unexpected subscription format');
      }

      final formatted = const JsonEncoder.withIndent('  ').convert(data);
      debugPrint('getSubscription: $formatted');
      setState(() => _subscriptionText = formatted);
    } catch (e) {
      debugPrint('getSubscription error: $e');
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: const Color(0xFFD3D3D3),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: _loading ? null : _showSubscription,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: const Text(
                    'SHOW SUBSCRIPTION',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            if (_loading) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
            if (_subscriptionText.isNotEmpty) ...[
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _subscriptionText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
