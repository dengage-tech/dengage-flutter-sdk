import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebView extends StatelessWidget {
  final String propertyId;
  final String? screenName;
  final HashMap<String,String>? customParams;
  final bool? hideIfNotFound;
  const WebView({Key? key, required this.propertyId,this.screenName,this.customParams,this.hideIfNotFound}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'plugins.codingwithtashi/flutter_web_view',
          creationParams: {
            "propertyId":
            propertyId,
            "screenName":
            screenName,
            "customParams":
            customParams,
            "hideIfNotFound":
            hideIfNotFound,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: 'plugins.codingwithtashi/flutter_web_view',
          creationParams: {
            "propertyId":
            propertyId,
            "screenName":
            screenName,
            "customParams":
            customParams,
            "hideIfNotFound":
            hideIfNotFound,
          },
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        return Text(
            '$defaultTargetPlatform is not yet supported by the web_view plugin');
    }
  }
}

