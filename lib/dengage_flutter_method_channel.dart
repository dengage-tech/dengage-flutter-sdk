import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dengage_flutter_platform_interface.dart';
import 'model/subscription.dart';

/// An implementation of [DengageFlutterPlatform] that uses method channels.
class MethodChannelDengageFlutter extends DengageFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dengage_flutter');
  @visibleForTesting
  final eventChannel = const EventChannel('dengageEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future addToCart(Object data) async {
    return await methodChannel.invokeMethod('addToCart', {"data": data});
  }

  @override
  Future addToWishList(Object data) async {
    return await methodChannel.invokeMethod('addToWishList', {"data": data});
  }

  @override
  Future beginCheckout(Object data) async {
    return await methodChannel.invokeMethod('beginCheckout', {"data": data});
  }

  @override
  Future cancelOrder(Object data) async {
    return await methodChannel.invokeMethod('cancelOrder', {"data": data});
  }

  @override
  Future categoryView(String categoryId) async {
    return await methodChannel
        .invokeMethod('categoryView', {"categoryId": categoryId});
  }

  @override
  Future deleteInboxMessage(String messageId) async {
    return await methodChannel
        .invokeMethod('deleteInboxMessage', {"messageId": messageId});
  }

  @override
  Future<List<Object?>?> getInboxMessages(int limit, int offset) async {
    return await methodChannel
        .invokeMethod('getInboxMessages', {"limit": limit, "offset": offset});
  }

  @override
  Future<Subscription?> getSubscription() async {
    String json = await methodChannel.invokeMethod('getSubscription') ?? "{}";
    return Subscription.fromJson(jsonDecode(json));
  }

  @override
  Future<String?> getToken() async {
    return await methodChannel.invokeMethod<String>("getToken");
  }

  @override
  Future<bool?> getUserPermission() async {
    return await methodChannel.invokeMethod('getUserPermission');
  }

  @override
  Future<FirebaseApp> init(
      {String? androidIntegrationKey,
      String? iosIntegrationKey,
      String? huaweiIntegrationKey,
      bool? geofenceEnabled}) async {
    WidgetsFlutterBinding.ensureInitialized();
    return Firebase.initializeApp().then((value) async {
      await methodChannel.invokeMethod("init", {
        "androidIntegrationKey": androidIntegrationKey,
        "iosIntegrationKey": iosIntegrationKey,
        "huaweiIntegrationKey": huaweiIntegrationKey,
        "geofenceEnabled": geofenceEnabled
      });
      return value;
    });
  }

  @override
  Future onMessageReceived(Object? data) async {
    return await methodChannel
        .invokeMethod('onMessageReceived', {"data": data});
  }

  @override
  Future onNewToken(String? token) async {
    return await methodChannel.invokeMethod('onNewToken', {"token": token});
  }

  @override
  Future order(Object data) async {
    return await methodChannel.invokeMethod('order', {"data": data});
  }

  @override
  Future pageView(Object data) async {
    return await methodChannel.invokeMethod('pageView', {"data": data});
  }

  @override
  Future removeFromCart(Object data) async {
    return await methodChannel.invokeMethod('removeFromCart', {"data": data});
  }

  @override
  Future removeFromWishList(Object data) async {
    return await methodChannel
        .invokeMethod('removeFromWishList', {"data": data});
  }

  @override
  Future saveRFMScores(List<Object> scores) async {
    return await methodChannel
        .invokeMethod('saveRFMScores', {"scores": scores});
  }

  @override
  Future search(Object data) async {
    return await methodChannel.invokeMethod('search', {"data": data});
  }

  @override
  Future sendCartEvents(Object data, String eventType) async {
    return await methodChannel
        .invokeMethod('sendCartEvents', {"data": data, "eventType": eventType});
  }

  @override
  Future sendCustomEvent(String tableName, String key, Object data) async {
    return await methodChannel.invokeMethod(
        'sendCustomEvent', {"tableName": tableName, "key": key, "data": data});
  }

  @override
  Future sendDeviceEvent(String tableName, Object data) async {
    return await methodChannel.invokeMethod(
        'sendDeviceEvent', {"tableName": tableName, "data": data});
  }

  @override
  Future sendOpenEvent(String buttonId, String itemId, Object? message) async {
    return await methodChannel.invokeMethod('sendOpenEvent',
        {"buttonId": buttonId, "itemId": itemId, "message": message});
  }

  @override
  Future sendWishListEvents(Object data, String eventType) async {
    return await methodChannel.invokeMethod(
        'sendWishListEvents', {"data": data, "eventType": eventType});
  }

  @override
  Future setContactKey(String? contactKey) async {
    return await methodChannel
        .invokeMethod('setContactKey', {"contactKey": contactKey});
  }

  @override
  Future setCountry(String country) async {
    return await methodChannel.invokeMethod('setCountry', {"country": country});
  }

  @override
  Future setDeviceId(String deviceId) async {
    return await methodChannel
        .invokeMethod('setDeviceId', {"deviceId": deviceId});
  }

  @override
  Future setFirebaseIntegrationKey(String integrationKey) async {
    return await methodChannel.invokeMethod('setFirebaseIntegrationKey',
        {"setFirebaseIntegrationKey": integrationKey});
  }

  @override
  Future setHuaweiIntegrationKey(String integrationKey) async {
    return await methodChannel.invokeMethod(
        'setHuaweiIntegrationKey', {"integrationKey": integrationKey});
  }

  @override
  Future setInboxMessageAsClicked(String messageId) async {
    return await methodChannel
        .invokeMethod('setInboxMessageAsClicked', {"messageId": messageId});
  }

  @override
  Future setLogStatus(bool enable) async {
    return await methodChannel.invokeMethod('setLogStatus', {"enable": enable});
  }

  @override
  Future setNavigation(String? screenName) async {
    return await methodChannel
        .invokeMethod('setNavigation', {"screenName": screenName});
  }

  @override
  Future setNotificationChannelName(String name) async {
    return await methodChannel
        .invokeMethod('setNotificationChannelName', {"name": name});
  }

  @override
  Future setTags(List<Object> tags) async {
    return await methodChannel.invokeMethod('setTags', {"tags": tags});
  }

  @override
  Future setToken(String? token) async {
    return await methodChannel.invokeMethod('setToken', {"token": token});
  }

  @override
  Future setUserPermission(bool permission) async {
    return await methodChannel
        .invokeMethod('setUserPermission', {"permission": permission});
  }

  @override
  Future showTestPage() async {
    return await methodChannel.invokeMethod('showTestPage');
  }

  @override
  Future sortRFMItems(Object rfmGender, List<Object> rfmItems) async {
    return await methodChannel.invokeMethod(
        'sortRFMItems', {"rfmGender": rfmGender, "rfmItems": rfmItems});
  }

  @override
  Future startAppTracking(List<Object>? appTrackings) async {
    return await methodChannel
        .invokeMethod('startAppTracking', {"appTrackings": appTrackings});
  }

  @override
  Future viewCart(Object data) async {
    return await methodChannel.invokeMethod('viewCart', {"data": data});
  }

  @override
  Future requestLocationPermissions() async {
    return await methodChannel.invokeMethod('requestLocationPermissions');
  }

  @override
  Future sendLoginEvent() async {
    return await methodChannel.invokeMethod('sendLoginEvent');
  }

  @override
  Future sendLogoutEvent() async {
    return await methodChannel.invokeMethod('sendLogoutEvent');
  }

  @override
  Future sendRegisterEvent() async {
    return await methodChannel.invokeMethod('sendRegisterEvent');
  }

  @override
  Stream<Object?> handleNotificationActionBlock() {
    return eventChannel.receiveBroadcastStream();
  }
}
