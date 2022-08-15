import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dengage_flutter/dengage_flutter_method_channel.dart';

void main() {
  MethodChannelDengageFlutter platform = MethodChannelDengageFlutter();
  const MethodChannel channel = MethodChannel('dengage_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {});
}
