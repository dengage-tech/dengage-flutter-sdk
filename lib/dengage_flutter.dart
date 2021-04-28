
import 'dart:async';

import 'package:flutter/services.dart';

class DengageFlutter {
  static const MethodChannel _channel =
      const MethodChannel('dengage_flutter');

  static Future<String> get platformVersion async {
    // final String version = await (_channel.invokeMethod('getPlatformVersion') as FutureOr<String>);
    return "Dengage Flutter Example";
  }

  static Future<bool> setIntegerationKey (String key) async {
    return await _channel.invokeMethod("setIntegerationKey", {'key': key});
  }
}
