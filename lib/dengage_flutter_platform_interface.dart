import 'package:dengage_flutter/model/subscription.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dengage_flutter_method_channel.dart';

abstract class DengageFlutterPlatform extends PlatformInterface {
  /// Constructs a DengageFlutterPlatform.
  DengageFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DengageFlutterPlatform _instance = MethodChannelDengageFlutter();

  /// The default instance of [DengageFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelDengageFlutter].
  static DengageFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DengageFlutterPlatform] when
  /// they register themselves.
  static set instance(DengageFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<FirebaseApp> init(
      {String? androidIntegrationKey,
      String? iosIntegrationKey,
      String? huaweiIntegrationKey,
      bool? geofenceEnabled});

  /// You can enable or disable logs comes from Dengage sdk to your Logcat.
  Future setLogStatus(bool enable);

  /// only android
  /// You can also set your Dengage firebase app integration key after sdk initiation.
  Future setFirebaseIntegrationKey(String integrationKey);

  /// only android
  /// You can also set your Dengage huawei app integration key after sdk initiation.
  Future setHuaweiIntegrationKey(String integrationKey);

  /// only android
  ///You can get Dengage sdk subscription model from sdk cache if exists (If you init correctly, it will exist).
  Future<Subscription?> getSubscription();

  /// You can set device id of current user subscription.
  Future setDeviceId(String deviceId);

  /// only android
  /// You can set country of current user subscription.
  Future setCountry(String country);

  //You can set contact key of current user subscription.
  Future setContactKey(String? contactKey);

  /// You can set user permission of current user subscription.
  Future setUserPermission(bool permission);

  /// You can get user permission of current user subscription.
  Future<bool?> getUserPermission();

  /// only android
  /// You can set firebase or huawei messaging token of current user subscription.
  Future setToken(String? token);

  /// You can get token of current user subscription.
  Future<String?> getToken();

  /// only android
  /// You can set firebase or huawei messaging token of current user subscription.
  Future onNewToken(String? token);

  /// only android
  ///You can set notification channel name for setting to notifications above android 26.
  Future setNotificationChannelName(String name);

  /// You can start app tracking with package name of the apps that you want to track.
  /// Future startAppTracking( List<AppTracking>? appTrackings);
  Future startAppTracking(List<Object>? appTrackings);

  /// You can get inbox messages with pagination. If you set push message addToInbox parameter as true, push messages sent from Dengage are also saved to your inbox.
  Future<List<Object?>?> getInboxMessages(int limit, int offset);

  /// You can delete any inbox message from the user's inbox.
  Future deleteInboxMessage(String messageId);

  /// You can set any inbox message as clicked with the user's interaction.
  Future setInboxMessageAsClicked(String messageId);

  /// You can call this method for showing in app message popup if exists with the given screen name.
  /// You can call this method for showing in app message popup if exists.
  Future setNavigation(String? screenName);

  /// You can send tag items to Dengage api.
  //Future setTags(List<TagItem> tags);
  Future setTags(List<Object> tags);

  /// You should send push message data, if you are using your own firebase or huawei messaging service receivers.
  Future onMessageReceived(Object? data);

  /// You can use our embedded test pages if you want to show or manipulate any data on Dengage sdk. It is useful for your development or qa team. Test pages contain;
  /// * Push Message ui and events
  /// * In App Message ui and events
  /// * Getting your device's info on Dengage sdk (Contains copy paste)
  /// * Getting your device's cache on Dengage sdk (Contains copy paste)
  /// * Manipulating fetch times of device parameters
  /// * Showing last 200 logs of Dengage sdk operations (Contains copy paste)
  Future showTestPage();

  /// You can save rfm scores to local storage if you will use rfm item sorting.
  Future saveRFMScores(List<Object> scores);

  /// You can update rfm score of viewed category.
  Future categoryView(String categoryId);

  /// You can sort rfm items with respect to rfm scores saved to local storage. Returns list of the sorted rfm items
  /// You can use RFMItem directly. Also you can create your own rfm item object that extends RFMItem. Then sort your own items like below:
  Future sortRFMItems(Object rfmGender, List<Object> rfmItems);

  ///other
  Future requestLocationPermissions();
  Future sendLoginEvent();
  Future sendLogoutEvent();
  Future sendRegisterEvent();

  // flutter
  Stream<Object?> handleNotificationActionBlock();
  //Event Methods start
  /// You can send events to Dengage sdk. Available event methods listed below. But you can send your own custom events also.
  Future pageView(Object data);

  Future sendCartEvents(Object data, String eventType);

  Future addToCart(Object data);

  Future removeFromCart(Object data);

  Future viewCart(Object data);

  Future beginCheckout(Object data);

  Future cancelOrder(Object data);

  Future order(Object data);

  Future search(Object data);

  Future sendWishListEvents(Object data, String eventType);

  Future addToWishList(Object data);

  Future removeFromWishList(Object data);

  Future sendCustomEvent(String tableName, String key, Object data);

  Future sendDeviceEvent(String tableName, Object data);

  // Future sendOpenEvent(String buttonId, String itemId, Message? message);
  Future sendOpenEvent(String buttonId, String itemId, Object? message);
//Event Methods end
}
