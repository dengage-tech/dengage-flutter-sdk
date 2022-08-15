import 'package:dengage_flutter/model/subscription.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dengage_flutter/dengage_flutter_platform_interface.dart';
import 'package:dengage_flutter/dengage_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDengageFlutterPlatform
    with MockPlatformInterfaceMixin
    implements DengageFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future addToCart(Object data) {
    return Future.value();
  }

  @override
  Future addToWishList(Object data) {
    return Future.value();
  }

  @override
  Future beginCheckout(Object data) {
    return Future.value();
  }

  @override
  Future cancelOrder(Object data) {
    return Future.value();
  }

  @override
  Future categoryView(String categoryId) {
    return Future.value();
  }

  @override
  Future deleteInboxMessage(String messageId) {
    return Future.value();
  }

  @override
  Future<List<Object?>?> getInboxMessages(int limit, int offset) {
    return Future.value();
  }

  @override
  Future<Subscription?> getSubscription() {
    return Future.value();
  }

  @override
  Future<String?> getToken() {
    return Future.value();
  }

  @override
  Future<bool?> getUserPermission() {
    return Future.value();
  }

  @override
  Stream<Object?> handleNotificationActionBlock() {
    return Stream.value("event");
  }

  @override
  Future onMessageReceived(Object? data) {
    return Future.value();
  }

  @override
  Future onNewToken(String? token) {
    return Future.value();
  }

  @override
  Future order(Object data) {
    return Future.value();
  }

  @override
  Future pageView(Object data) {
    return Future.value();
  }

  @override
  Future removeFromCart(Object data) {
    return Future.value();
  }

  @override
  Future removeFromWishList(Object data) {
    return Future.value();
  }

  @override
  Future requestLocationPermissions() {
    return Future.value();
  }

  @override
  Future saveRFMScores(List<Object> scores) {
    return Future.value();
  }

  @override
  Future search(Object data) {
    return Future.value();
  }

  @override
  Future sendCartEvents(Object data, String eventType) {
    return Future.value();
  }

  @override
  Future sendCustomEvent(String tableName, String key, Object data) {
    return Future.value();
  }

  @override
  Future sendDeviceEvent(String tableName, Object data) {
    return Future.value();
  }

  @override
  Future sendLoginEvent() {
    return Future.value();
  }

  @override
  Future sendLogoutEvent() {
    return Future.value();
  }

  @override
  Future sendOpenEvent(String buttonId, String itemId, Object? message) {
    return Future.value();
  }

  @override
  Future sendRegisterEvent() {
    return Future.value();
  }

  @override
  Future sendWishListEvents(Object data, String eventType) {
    return Future.value();
  }

  @override
  Future setContactKey(String? contactKey) {
    return Future.value();
  }

  @override
  Future setCountry(String country) {
    return Future.value();
  }

  @override
  Future setDeviceId(String deviceId) {
    return Future.value();
  }

  @override
  Future setFirebaseIntegrationKey(String integrationKey) {
    return Future.value();
  }

  @override
  Future setHuaweiIntegrationKey(String integrationKey) {
    return Future.value();
  }

  @override
  Future setInboxMessageAsClicked(String messageId) {
    return Future.value();
  }

  @override
  Future setLogStatus(bool enable) {
    return Future.value();
  }

  @override
  Future setNavigation(String? screenName) {
    return Future.value();
  }

  @override
  Future setNotificationChannelName(String name) {
    return Future.value();
  }

  @override
  Future setTags(List<Object> tags) {
    return Future.value();
  }

  @override
  Future setToken(String? token) {
    return Future.value();
  }

  @override
  Future setUserPermission(bool permission) {
    return Future.value();
  }

  @override
  Future showTestPage() {
    return Future.value();
  }

  @override
  Future sortRFMItems(Object rfmGender, List<Object> rfmItems) {
    return Future.value();
  }

  @override
  Future startAppTracking(List<Object>? appTrackings) {
    return Future.value();
  }

  @override
  Future viewCart(Object data) {
    return Future.value();
  }

  @override
  Future<FirebaseApp> init(
      {String? androidIntegrationKey,
      String? iosIntegrationKey,
      String? huaweiIntegrationKey,
      bool? geofenceEnabled}) {
    return Future.value();
  }
}

void main() {
  final DengageFlutterPlatform initialPlatform =
      DengageFlutterPlatform.instance;

  test('$MethodChannelDengageFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDengageFlutter>());
  });

  test('getPlatformVersion', () async {});
}
