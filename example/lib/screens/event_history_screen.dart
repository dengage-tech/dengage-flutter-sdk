import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class EventHistoryScreen extends StatefulWidget {
  const EventHistoryScreen({Key? key}) : super(key: key);

  @override
  State<EventHistoryScreen> createState() => _EventHistoryScreenState();
}

class _EventHistoryScreenState extends State<EventHistoryScreen> {
  final _tableNameController = TextEditingController();
  final List<Map<String, String>> _params = [];

  @override
  void initState() {
    super.initState();
    _params.add({'key': '', 'value': ''});
  }

  @override
  void dispose() {
    _tableNameController.dispose();
    super.dispose();
  }

  void _addParameter() {
    setState(() => _params.add({'key': '', 'value': ''}));
  }

  void _removeParameter(int index) {
    if (_params.length > 1) {
      setState(() => _params.removeAt(index));
    }
  }

  void _sendEvent() {
    final tableName = _tableNameController.text.trim();
    if (tableName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter table name')),
      );
      return;
    }
    final data = <String, dynamic>{};
    for (final p in _params) {
      final k = (p['key'] ?? '').trim();
      final v = (p['value'] ?? '').trim();
      if (k.isNotEmpty) data[k] = v;
    }
    DengageFlutter.sendDeviceEvent(tableName, data);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event sent to table: $tableName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Event History / Send Device Event'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Table Name:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tableNameController,
              decoration: const InputDecoration(
                hintText: 'Table Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Event parameters (key / value):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
                    if (_params.length > 1)
                      TextButton(
                        onPressed: () => _removeParameter(i),
                        child: const Text('Remove',
                            style: TextStyle(
                                color: Color(0xFFDC3545),
                                fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              );
            }),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _addParameter,
                child: const Text('+ Add Parameter',
                    style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF007BFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Send Event',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
