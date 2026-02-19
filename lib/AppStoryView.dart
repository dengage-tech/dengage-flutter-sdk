import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Platform view widget that displays Dengage App Story (stories list).
///
/// Use this widget where you want to show the story-style in-app content.
/// Requires [propertyId] and [screenName]; [customParams] is optional.
///
/// App Story is already implemented in the native Dengage iOS and Android SDKs;
/// this widget embeds the native story list view in your Flutter layout.
class AppStoryView extends StatelessWidget {
  /// Story property ID from Dengage dashboard.
  final String propertyId;

  /// Screen name for story targeting.
  final String? screenName;

  /// Optional custom parameters for the story request.
  final HashMap<String, String>? customParams;

  const AppStoryView({
    Key? key,
    required this.propertyId,
    this.screenName,
    this.customParams,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'plugins.dengage/appstory',
          creationParams: <String, dynamic>{
            'propertyId': propertyId,
            'screenName': screenName,
            'customParams': customParams,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'plugins.dengage/appstory',
          creationParams: <String, dynamic>{
            'propertyId': propertyId,
            'screenName': screenName,
            'customParams': customParams,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        return const SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'App Story is not supported on this platform.',
            ),
          ),
        );
    }
  }
}
