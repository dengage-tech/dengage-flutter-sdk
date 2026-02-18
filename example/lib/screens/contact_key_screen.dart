import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class ContactKeyScreen extends StatefulWidget {
  const ContactKeyScreen({Key? key}) : super(key: key);

  @override
  State<ContactKeyScreen> createState() => _ContactKeyScreenState();
}

class _ContactKeyScreenState extends State<ContactKeyScreen> {
  final _controller = TextEditingController();
  bool _permission = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadContactKey();
  }

  Future<void> _loadContactKey() async {
    try {
      final key = await DengageFlutter.getContactKey();
      bool perm = false;
      try {
        final p = await DengageFlutter.getUserPermission();
        perm = p == true;
      } catch (_) {}
      if (mounted) {
        setState(() {
          _controller.text = key ?? '';
          _permission = perm;
          _initialized = true;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _initialized = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveContactKey() {
    final key = _controller.text.trim();
    DengageFlutter.setContactKey(key);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact key has been updated.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Change Contact Key'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Change Contact Key'),
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
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Contact Key',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('User Permission',
                    style: TextStyle(fontSize: 16, color: Colors.black)),
                Switch(
                  value: _permission,
                  onChanged: (v) {
                    setState(() => _permission = v);
                    DengageFlutter.setUserPermission(v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveContactKey,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
