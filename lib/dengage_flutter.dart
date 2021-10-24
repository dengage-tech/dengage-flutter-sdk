
import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

class DengageFlutter {
  static const MethodChannel _channel =
      const MethodChannel('dengage_flutter');

  static Future<String> get platformVersion async {
    // final String version = await (_channel.invokeMethod('getPlatformVersion') as FutureOr<String>);
    return "Dengage Flutter Example";
  }

  // iOS only
  static Future<bool?> setIntegerationKey (String key) async {
    return await _channel.invokeMethod("dEngage#setIntegerationKey", {'key': key});
  }

  static Future<bool?> setContactKey (String? contactKey) async {
    return await _channel.invokeMethod("dEngage#setContactKey", {'contactKey': contactKey});
  }

  // iOS only
  static Future<void> promptForPushNotifications () async {
    return await _channel.invokeMethod("dEngage#promptForPushNotifications");
  }

  // iOS only
  static Future<bool?> promptForPushNotificationsWithPromise () async {
    return await _channel.invokeMethod("dEngage#promptForPushNotifications");
  }

  static Future<void> setUserPermission (bool hasPermission) async {
    return await _channel.invokeMethod("dEngage#setUserPermission", {'hasPermission': hasPermission});
  }

  // iOS only
  static Future<void> registerForRemoteNotifications (bool enabled) async {
    return await _channel.invokeMethod("dEngage#registerForRemoteNotifications", {enabled: enabled});
  }

  static Future<String?> getToken () {
    return _channel.invokeMethod("dEngage#getToken");
  }

  static Future<String?> getContactKey () {
    return _channel.invokeMethod("dEngage#getContactKey");
  }

  static Future<void> setToken (String token) {
    return _channel.invokeMethod("dEngage#setToken", {token: token});
  }

  // android only
  static Future<bool?> setHuaweiIntegrationKey (String key) async {
    return await _channel.invokeMethod("dEngage#setHuaweiIntegrationKey", {'key': key});
  }

  // android only
  static Future<bool?> setFirebaseIntegrationKey (String key) async {
    return await _channel.invokeMethod("dEngage#setFirebaseIntegrationKey", {'key': key});
  }

  static Future<bool?> setLogStatus (bool isVisible) async {
    return await _channel.invokeMethod("dEngage#setLogStatus", {'logStatus': isVisible});
  }

  // android Only
  static Future<bool?> getUserPermission () async {
    return _channel.invokeMethod("dEngage#getUserPermission");
  }

  // android only
  static Future<Object?> getSubscription () async {
    return _channel.invokeMethod("dEngage#getSubscription");
  }

  static Future<Object> handleNotificationActionBlock () async {
    // todo: handling callback.
    return {};
  }

  static Future<bool?> pageView (Object data) async {
    return await _channel.invokeMethod("dEngage#pageView", {'data': data});
  }

  static Future<void> addToCart (Object data) async {
    return await _channel.invokeMethod("dEngage#addToCart", {'data': data});
  }

  static Future<void> removeFromCart (Object data) async {
    return await _channel.invokeMethod("dEngage#removeFromCart", {'data': data});
  }

  static Future<void> viewCart (Object data) async {
    return await _channel.invokeMethod("dEngage#viewCart", {'data': data});
  }

  static Future<void> beginCheckout (Object data) async {
    return await _channel.invokeMethod("dEngage#beginCheckout", {'data': data});
  }

  static Future<void> placeOrder (Object data) async {
    return await _channel.invokeMethod("dEngage#placeOrder", {'data': data});
  }

  static Future<void> cancelOrder (Object data) async {
    return await _channel.invokeMethod("dEngage#cancelOrder", {'data': data});
  }

  static Future<void> addToWishList (Object data) async {
    return await _channel.invokeMethod("dEngage#addToWishList", {'data': data});
  }

  static Future<void> removeFromWishList (Object data) async {
    return await _channel.invokeMethod("dEngage#removeFromWishList", {'data': data});
  }

  static Future<void> search (Object data) async {
    return await _channel.invokeMethod("dEngage#search", {'data': data});
  }

  static Future<bool> sendDeviceEvent (String tableName, Object data) async {
    return await _channel.invokeMethod("dEngage#sendDeviceEvent", {"tableName": tableName, "data": data});
  }

  static Future<List<Object?>> getInboxMessages (int offset, int limit) async {
    return await _channel.invokeMethod("dEngage#getInboxMessages", {'offset': offset, 'limit': limit});
  }

  static Future<void> deleteInboxMessage (int id) async {
    return await _channel.invokeMethod("dEngage#deleteInboxMessage", {'id': id});
  }

  static Future<void> setInboxMessageAsClicked (int id) async {
    return await _channel.invokeMethod("dEngage#setInboxMessageAsClicked", {'id': id});
  }

  static Future<void> setNavigation () async {
    return await _channel.invokeMethod("dEngage#setNavigation");
  }

  static Future<void> setNavigationWithName (String screenName) async {
    return await _channel.invokeMethod("dEngage#setNavigationWithName", {'screenName': screenName});
  }

}
