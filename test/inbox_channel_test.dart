import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dengage_flutter');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'dEngage#getInboxChannelMessages':
          return [
            {
              'id': 'm1',
              'isRead': false,
              'priority': 2,
              'isDeleted': false,
              'data': {
                'title': 'Hello',
                'message': null,
                'imageUrl': null,
                'isPinned': true,
                'receiveDate': '2026-09-30T10:00:00Z',
                'messageDetails': 'opaque',
                'ctaButtons': [
                  {
                    'buttonId': 'b1',
                    'label': 'Go',
                    'iosDeeplink': 'app://ios',
                    'androidDeeplink': null,
                    'webUrl': 'https://x.y',
                  }
                ],
              },
            }
          ];
        case 'dEngage#sendInboxChannelEvents':
          return true;
        default:
          return null;
      }
    });
  });

  test('getInboxChannelMessages parses messages and sends limit', () async {
    final msgs = await DengageFlutter.getInboxChannelMessages(5);
    expect(calls.single.arguments, {'limit': 5});
    expect(msgs.length, 1);
    final m = msgs.first;
    expect(m.id, 'm1');
    expect(m.isRead, false);
    expect(m.priority, 2);
    expect(m.data.title, 'Hello');
    expect(m.data.message, isNull);
    expect(m.data.isPinned, true);
    expect(m.data.messageDetails, 'opaque');
    expect(m.data.ctaButtons.single.iosDeeplink, 'app://ios');
    expect(m.data.ctaButtons.single.androidDeeplink, isNull);
    expect(m.copyWith(isRead: true).isRead, true);
  });

  test('sendInboxChannelEvents serialises event codes', () async {
    final msgs = await DengageFlutter.getInboxChannelMessages();
    expect(calls.first.arguments, {'limit': 20});
    final ok = await DengageFlutter.sendInboxChannelEvents([
      msgs.first.toEvent(InboxChannelEventType.impression),
      msgs.first.toEvent(InboxChannelEventType.open),
      msgs.first.toEvent(InboxChannelEventType.click),
      msgs.first.toEvent(InboxChannelEventType.delete),
    ]);
    expect(ok, true);
    final events = (calls.last.arguments as Map)['events'] as List;
    expect(events.map((e) => e['eventType']), ['IM', 'OP', 'CL', 'DT']);
    expect(events.first, {
      'eventType': 'IM',
      'messageId': 'm1',
      'messageDetails': 'opaque',
    });
  });

  test('setLocationPermission passes status', () async {
    await DengageFlutter.setLocationPermission('always');
    expect(calls.single.method, 'dEngage#setLocationPermission');
    expect(calls.single.arguments, {'status': 'always'});
  });

  test('removeInAppMessageDisplay calls the native method', () async {
    await DengageFlutter.removeInAppMessageDisplay();
    expect(calls.single.method, 'dEngage#removeInAppMessageDisplay');
  });
}
