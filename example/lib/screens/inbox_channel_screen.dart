import 'dart:io' show Platform;

import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';

class InboxChannelScreen extends StatefulWidget {
  const InboxChannelScreen({Key? key}) : super(key: key);

  @override
  State<InboxChannelScreen> createState() => _InboxChannelScreenState();
}

class _InboxChannelScreenState extends State<InboxChannelScreen> {
  static const int _pageLimit = 20;

  List<InboxChannelMessage> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  void _toast(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _fetchMessages() async {
    setState(() => _loading = true);
    try {
      final msgs = await DengageFlutter.getInboxChannelMessages(_pageLimit);
      if (!mounted) return;
      setState(() {
        _messages = msgs;
        _loading = false;
      });
      // Report an impression (IM) for every message currently shown, in bulk.
      if (msgs.isNotEmpty) {
        await DengageFlutter.sendInboxChannelEvents(
            msgs.map((m) => m.toEvent(InboxChannelEventType.impression)).toList());
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _toast('Failed to fetch inbox channel messages: $e');
    }
  }

  void _markRead(InboxChannelMessage m) {
    setState(() {
      _messages = _messages
          .map((x) => x.id == m.id ? x.copyWith(isRead: true) : x)
          .toList();
    });
  }

  Future<void> _send(InboxChannelMessage m, InboxChannelEventType type) async {
    try {
      await DengageFlutter.sendInboxChannelEvents([m.toEvent(type)]);
    } catch (e) {
      _toast('Failed to send ${type.code} event: $e');
    }
  }

  Future<void> _handleOpen(InboxChannelMessage m) async {
    _markRead(m);
    await _send(m, InboxChannelEventType.open);
  }

  Future<void> _handleClick(InboxChannelMessage m,
      [InboxChannelCtaButton? cta]) async {
    _markRead(m);
    await _send(m, InboxChannelEventType.click);
    final button = cta ?? (m.data.ctaButtons.isNotEmpty ? m.data.ctaButtons.first : null);
    final link = (Platform.isIOS ? button?.iosDeeplink : button?.androidDeeplink);
    final target = (link != null && link.isNotEmpty) ? link : button?.webUrl;
    // Routing to the deeplink is app specific; the example only shows it.
    _toast(target == null || target.isEmpty
        ? 'No deeplink for this message'
        : 'Deeplink: $target');
  }

  Future<void> _handleDelete(InboxChannelMessage m) async {
    // Reflect the delete on the UI immediately; the server processes the event async.
    setState(() => _messages = _messages.where((x) => x.id != m.id).toList());
    await _send(m, InboxChannelEventType.delete);
  }

  void _confirmDelete(InboxChannelMessage m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Delete this message?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleDelete(m);
            },
            child:
                const Text('Delete', style: TextStyle(color: Color(0xFFE74C3C))),
          ),
        ],
      ),
    );
  }

  Widget _button(String label, Color color, VoidCallback onPressed) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: color),
      onPressed: onPressed,
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _card(InboxChannelMessage m) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: m.isRead
            ? BorderSide.none
            : const BorderSide(color: Color(0xFF2980B9), width: 1.5),
      ),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleClick(m),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (m.data.imageUrl != null && m.data.imageUrl!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(m.data.imageUrl!,
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${m.data.isPinned ? '📌 ' : ''}${m.data.title ?? 'No Title'}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF222222)),
                    ),
                  ),
                  Text(
                    m.isRead ? 'Read' : 'Unread',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: m.isRead ? FontWeight.normal : FontWeight.bold,
                        color: m.isRead
                            ? const Color(0xFF888888)
                            : const Color(0xFF2980B9)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(m.data.message ?? '',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF444444))),
              const SizedBox(height: 4),
              Text(m.data.receiveDate ?? '',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final cta in m.data.ctaButtons)
                    _button(cta.label ?? 'Open', const Color(0xFF27AE60),
                        () => _handleClick(m, cta)),
                  _button('Mark Opened', const Color(0xFF2980B9),
                      () => _handleOpen(m)),
                  _button('Delete', const Color(0xFFE74C3C),
                      () => _confirmDelete(m)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Inbox Channel'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2980B9)))
          : RefreshIndicator(
              onRefresh: _fetchMessages,
              child: _messages.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 200),
                      Center(child: Text('No inbox channel messages.')),
                    ])
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => _card(_messages[index]),
                    ),
            ),
    );
  }
}
