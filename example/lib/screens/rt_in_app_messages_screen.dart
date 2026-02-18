import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class RTInAppMessagesScreen extends StatefulWidget {
  const RTInAppMessagesScreen({Key? key}) : super(key: key);

  @override
  State<RTInAppMessagesScreen> createState() => _RTInAppMessagesScreenState();
}

class _RTInAppMessagesScreenState extends State<RTInAppMessagesScreen> {
  final _categoryPathController = TextEditingController();
  final _cartItemCountController = TextEditingController();
  final _cartAmountController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _screenNameController = TextEditingController();
  final List<Map<String, String>> _params = [];

  void _setCategoryPath() {
    final v = _categoryPathController.text.trim();
    if (v.isNotEmpty) DengageFlutter.setCategoryPath(v);
  }

  void _setCartItemCount() {
    final v = _cartItemCountController.text.trim();
    if (v.isNotEmpty) DengageFlutter.setCartItemCount(v);
  }

  void _setCartAmount() {
    final v = _cartAmountController.text.trim();
    if (v.isNotEmpty) DengageFlutter.setCartAmount(v);
  }

  void _setState() {
    final v = _stateController.text.trim();
    if (v.isNotEmpty) DengageFlutter.setState(v);
  }

  void _setCity() {
    final v = _cityController.text.trim();
    if (v.isNotEmpty) DengageFlutter.setCity(v);
  }

  void _addParam() {
    setState(() => _params.add({'key': '', 'value': ''}));
  }

  void _showRealTimeInApp() {
    final screenName = _screenNameController.text.trim();
    final data = <String, String>{};
    for (final p in _params) {
      final k = (p['key'] ?? '').trim();
      final v = (p['value'] ?? '').trim();
      if (k.isNotEmpty && v.isNotEmpty) data[k] = v;
    }
    DengageFlutter.showRealTimeInApp(screenName, data);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Show Real Time In App triggered')),
    );
  }

  @override
  void dispose() {
    _categoryPathController.dispose();
    _cartItemCountController.dispose();
    _cartAmountController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _screenNameController.dispose();
    super.dispose();
  }

  Widget _row(String label, TextEditingController controller, VoidCallback onSet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onSet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
            ),
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Real Time In App Message'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _row('Category Path', _categoryPathController, _setCategoryPath),
            _row('Cart Item Count', _cartItemCountController, _setCartItemCount),
            _row('Cart Amount', _cartAmountController, _setCartAmount),
            _row('State', _stateController, _setState),
            _row('City', _cityController, _setCity),
            TextField(
              controller: _screenNameController,
              decoration: const InputDecoration(
                hintText: 'Screen name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addParam,
                child: const Text('+ Add New Parameter',
                    style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
              ),
            ),
            ...List.generate(_params.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Key',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => _params[i]['key'] = v,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Value',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        onChanged: (v) => _params[i]['value'] = v,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _showRealTimeInApp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007AFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Show Real Time In App'),
            ),
          ],
        ),
      ),
    );
  }
}
