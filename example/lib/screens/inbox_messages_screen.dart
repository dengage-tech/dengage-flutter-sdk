import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class InboxMessagesScreen extends StatefulWidget {
  const InboxMessagesScreen({Key? key}) : super(key: key);

  @override
  State<InboxMessagesScreen> createState() => _InboxMessagesScreenState();
}

class _InboxMessagesScreenState extends State<InboxMessagesScreen> {
  List<dynamic> _messages = [];
  bool _loading = true;
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    if (!_refreshing) setState(() => _loading = true);
    try {
      final result =
          await DengageFlutter.getInboxMessages(0, 50);
      if (mounted) {
        setState(() {
          _messages = List<dynamic>.from(result as List);
          _loading = false;
          _refreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _refreshing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _handleDelete(String id) async {
    try {
      await DengageFlutter.deleteInboxMessage(id);
      _fetchMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  Future<void> _handleMarkClicked(String id) async {
    try {
      await DengageFlutter.setInboxMessageAsClicked(id);
      _fetchMessages();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark as clicked: $e')),
        );
      }
    }
  }

  Map<String, dynamic> _itemToMap(dynamic item) {
    if (item is Map) return Map<String, dynamic>.from(item);
    return {};
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && !_refreshing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Inbox Messages'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2980B9)),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Inbox Messages'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _refreshing = true);
          await _fetchMessages();
        },
        child: _messages.isEmpty
            ? const Center(child: Text('No messages found.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final item = _itemToMap(_messages[index]);
                  final id = item['id']?.toString() ?? '';
                  final title =
                      item['title']?.toString() ?? item['data']?['title']?.toString() ?? 'No Title';
                  final message =
                      item['message']?.toString() ?? item['data']?['message']?.toString() ?? '';
                  final receiveDate =
                      item['receiveDate']?.toString() ?? item['data']?['receiveDate']?.toString() ?? '';
                  final isClicked = item['isClicked'] == true;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF222222),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  message,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF444444),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  receiveDate,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF888888),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isClicked ? 'Clicked' : 'Not Clicked',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF27AE60),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFFE74C3C),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete'),
                                      content: const Text(
                                          'Delete this message?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            _handleDelete(id);
                                          },
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color: Color(0xFFE74C3C))),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: const Text('Delete',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 6),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xFF2980B9),
                                ),
                                onPressed: () => _handleMarkClicked(id),
                                child: const Text('Mark as Clicked',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
