import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InAppInline extends StatelessWidget {
  final String propertyId;
  final String? screenName;
  final HashMap<String,String>? customParams;
  final bool? hideIfNotFound;
  const InAppInline({Key? key, required this.propertyId,this.screenName,this.customParams,this.hideIfNotFound}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: 'plugins.dengage/inappinline',
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
          viewType: 'plugins.dengage/inappinline',
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

