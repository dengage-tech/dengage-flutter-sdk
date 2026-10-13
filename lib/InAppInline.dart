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

/// Called when the inline in-app placement changes visibility.
///
/// [isHidden] is `true` when the native SDK hid the placement (no message
/// found and `hideIfNotFound` is true) and `false` when a message is shown.
typedef InAppInlineVisibilityCallback = void Function(bool isHidden);

class InAppInline extends StatefulWidget {
  final String propertyId;
  final String? screenName;
  final HashMap<String, String>? customParams;
  final bool? hideIfNotFound;
  final InAppInlineVisibilityCallback? onVisibilityChanged;

  const InAppInline({
    Key? key,
    required this.propertyId,
    this.screenName,
    this.customParams,
    this.hideIfNotFound,
    this.onVisibilityChanged,
  }) : super(key: key);

  @override
  State<InAppInline> createState() => _InAppInlineState();
}

class _InAppInlineState extends State<InAppInline> {
  MethodChannel? _channel;
  bool? _lastIsHidden;

  Map<String, dynamic> get _creationParams => {
        'propertyId': widget.propertyId,
        'screenName': widget.screenName,
        'customParams': widget.customParams,
        'hideIfNotFound': widget.hideIfNotFound,
      };

  void _onPlatformViewCreated(int viewId) {
    _unbindChannel();
    _lastIsHidden = null;
    final channel = MethodChannel('plugins.dengage/inappinline_$viewId');
    // Always read the callback from `widget` so a callback passed by a later
    // rebuild (or added after the view was created) is the one that runs.
    channel.setMethodCallHandler((call) async {
      if (call.method != 'onVisibilityChanged') return;
      final onChanged = widget.onVisibilityChanged;
      if (onChanged == null) return;
      final map = (call.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      final isHidden = (map['isHidden'] as bool?) ?? false;
      // The re-sync below can repeat a value that was already delivered.
      if (isHidden == _lastIsHidden) return;
      _lastIsHidden = isHidden;
      onChanged(isHidden);
    });
    _channel = channel;
    // Native starts reporting before this handler exists, so ask it to send
    // the current state again now that we are listening.
    channel.invokeMethod<void>('requestVisibility').catchError((_) {});
  }

  void _unbindChannel() {
    _channel?.setMethodCallHandler(null);
    _channel = null;
  }

  @override
  void dispose() {
    _unbindChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewKey = _platformViewKey(
      propertyId: widget.propertyId,
      screenName: widget.screenName,
      customParams: widget.customParams,
      hideIfNotFound: widget.hideIfNotFound,
    );

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          key: viewKey,
          viewType: 'plugins.dengage/inappinline',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          key: viewKey,
          viewType: 'plugins.dengage/inappinline',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: _creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        return Text('$defaultTargetPlatform is not supported');
    }
  }
}
