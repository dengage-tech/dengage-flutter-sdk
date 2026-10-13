import 'dart:collection';

import 'package:dengage_flutter/InAppInline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives [InAppInline] with a fake platform-view layer so the Dart side of
/// the `onVisibilityChanged(isHidden)` channel can be tested deterministically.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late int viewId;
  late String channelName;
  late List<MethodCall> nativeCalls; // calls Dart makes to the inline channel
  const codec = StandardMethodCodec();

  setUp(() {
    nativeCalls = [];
    viewId = -1;
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform_views, (call) async {
      if (call.method == 'create') {
        viewId = (call.arguments as Map)['id'] as int;
        channelName = 'plugins.dengage/inappinline_$viewId';
        messenger.setMockMethodCallHandler(MethodChannel(channelName), (c) async {
          nativeCalls.add(c);
          return null;
        });
        return 0; // texture id
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform_views, null);
  });

  /// Pretend the native view sent `onVisibilityChanged`.
  Future<void> fromNative(bool isHidden) async {
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      channelName,
      codec.encodeMethodCall(MethodCall('onVisibilityChanged', {'isHidden': isHidden})),
      (_) {},
    );
  }

  Widget host(InAppInlineVisibilityCallback? cb) => Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 100,
          height: 100,
          child: InAppInline(
            propertyId: 'p1',
            customParams: HashMap<String, String>(),
            hideIfNotFound: true,
            onVisibilityChanged: cb,
          ),
        ),
      );

  final android = TargetPlatformVariant.only(TargetPlatform.android);

  testWidgets('delivers isHidden true and false to the callback', (tester) async {
    final got = <bool>[];
    await tester.pumpWidget(host(got.add));
    await tester.pump();
    await fromNative(true);
    await fromNative(false);
    expect(got, [true, false]);
  }, variant: android);

  testWidgets('does not repeat an unchanged value', (tester) async {
    final got = <bool>[];
    await tester.pumpWidget(host(got.add));
    await tester.pump();
    await fromNative(true);
    await fromNative(true); // e.g. the re-sync reply
    await fromNative(false);
    await fromNative(false);
    expect(got, [true, false]);
  }, variant: android);

  testWidgets('asks native to re-send the current state once bound', (tester) async {
    await tester.pumpWidget(host((_) {}));
    await tester.pump();
    expect(nativeCalls.map((c) => c.method), contains('requestVisibility'));
  }, variant: android);

  testWidgets('uses the latest callback after the parent rebuilds', (tester) async {
    final first = <bool>[];
    final second = <bool>[];
    await tester.pumpWidget(host(first.add));
    await tester.pump();
    await tester.pumpWidget(host(second.add)); // same view, new callback
    await tester.pump();
    await fromNative(true);
    expect(first, isEmpty);
    expect(second, [true]);
  }, variant: android);

  testWidgets('stops delivering after the widget is disposed', (tester) async {
    final got = <bool>[];
    await tester.pumpWidget(host(got.add));
    await tester.pump();
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    await fromNative(true);
    expect(got, isEmpty);
  }, variant: android);

  testWidgets('works when the callback is added after the view was created', (tester) async {
    await tester.pumpWidget(host(null));
    await tester.pump();
    final got = <bool>[];
    await tester.pumpWidget(host(got.add));
    await tester.pump();
    await fromNative(true);
    expect(got, [true]);
  }, variant: android);
}
