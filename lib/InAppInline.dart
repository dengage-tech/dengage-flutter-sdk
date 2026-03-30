import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Stable key so changing [propertyId] / [screenName] / params recreates the platform
/// view (native only runs `showInlineInApp` / `showInAppInLine` in `init`).
Key _platformViewKey({
  required String propertyId,
  String? screenName,
  HashMap<String, String>? customParams,
  bool? hideIfNotFound,
}) {
  final b = StringBuffer()
    ..write(propertyId)
    ..write('|')
    ..write(screenName ?? '')
    ..write('|')
    ..write(hideIfNotFound);
  if (customParams != null && customParams.isNotEmpty) {
    final sorted = customParams.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final e in sorted) {
      b.write('|${e.key}=${e.value}');
    }
  }
  return ValueKey<String>(b.toString());
}

void _bindVisibilityChannel(int viewId, ValueChanged<bool>? onChanged) {
  if (onChanged == null) return;
  final channel = MethodChannel('plugins.dengage/inappinline_$viewId');
  channel.setMethodCallHandler((call) async {
    if (call.method != 'onVisibilityChanged') return;
    final map = (call.arguments as Map?)?.cast<String, dynamic>() ?? const {};
    onChanged((map['isHidden'] as bool?) ?? false);
  });
}

class InAppInline extends StatelessWidget {
  final String propertyId;
  final String? screenName;
  final HashMap<String, String>? customParams;
  final bool? hideIfNotFound;
  final ValueChanged<bool>? onVisibilityChanged;

  const InAppInline({
    Key? key,
    required this.propertyId,
    this.screenName,
    this.customParams,
    this.hideIfNotFound,
    this.onVisibilityChanged,
  }) : super(key: key);

  Map<String, dynamic> get _creationParams => {
        'propertyId': propertyId,
        'screenName': screenName,
        'customParams': customParams,
        'hideIfNotFound': hideIfNotFound,
      };

  @override
  Widget build(BuildContext context) {
    final viewKey = _platformViewKey(
      propertyId: propertyId,
      screenName: screenName,
      customParams: customParams,
      hideIfNotFound: hideIfNotFound,
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          key: viewKey,
          viewType: 'plugins.dengage/inappinline',
          onPlatformViewCreated: (id) => _bindVisibilityChannel(id, onVisibilityChanged),
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          key: viewKey,
          viewType: 'plugins.dengage/inappinline',
          onPlatformViewCreated: (id) => _bindVisibilityChannel(id, onVisibilityChanged),
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        return Text('$defaultTargetPlatform is not supported');
    }
  }
}
