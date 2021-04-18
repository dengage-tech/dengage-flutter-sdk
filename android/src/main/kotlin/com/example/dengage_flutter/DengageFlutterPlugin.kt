package com.example.dengage_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result




// import io.flutter.plugin.common.PluginRegistry.Registrar

/** DengageFlutterPlugin */
class DengageFlutterPlugin: FlutterPlugin, MethodCallHandler, DengageResponder {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dengage_flutter")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      if (call.method == "getPlatformVersion") {
        replySuccess(result, "Android ${android.os.Build.VERSION.RELEASE}")
      } else if (call.method == "setContactKey") {
        val contactKey: String? = call.argument("contactKey")
        if (contactKey != null) {
          DengageCoordinator.sharedInstance.dengageManager?.setContactKey(contactKey)
          replySuccess(result, true)
        } else {
          throw Exception("required argument contactKey is missing.");
        }
      } else if (call.method == "setHuaweiIntegrationKey") {
        val key: String? = call.argument("key")
        if (key != null) {
          DengageCoordinator.sharedInstance.dengageManager?.setHuaweiIntegrationKey(key)
        }
      } else if (call.method == "setFirebaseIntegrationKey") {
        val key: String? = call.argument("key")
        if (key != null) {
          DengageCoordinator.sharedInstance.dengageManager?.setFirebaseIntegrationKey(key)
        }
      } else if (call.method == "setLogStatus") {
        val logStatus: Boolean? = call.argument("logStatus") ?: false
        DengageCoordinator.sharedInstance.dengageManager?.setLogStatus(logStatus)
      } else if (call.method == "setPermission") {
        val hasPermission: Boolean? = call.argument("hasPermission") ?: false
        DengageCoordinator.sharedInstance.dengageManager?.setUserPermission(hasPermission)
      } else if (call.method == "setToken") {
        val token: String? = call.argument("token")
        if (token != null) {
          DengageCoordinator.sharedInstance.dengageManager?.setToken(token)
        }
      } else if (call.method == "getToken") {
        try {
          val token = DengageCoordinator.sharedInstance.dengageManager?.subscription?.token
          if (token !== null) {
            // promise.resolve(token)
            return
          }
          throw Exception("unable to get token.");
        } catch (ex: Exception) {
          // promise.reject(ex)
        }
      } else if (call.method == "getContactKey") {
        // return contact key here.
      } else if (call.method == "getUserPermission") {
        // return contact key here.
      } else if (call.method == "getSubscription") {
        // return contact key here.
      } else if (call.method == "pageView") {
        // call.argument("data")
      } else if (call.method == "addToCart") {
        // call.argument("data")
      } else if (call.method == "removeFromCart") {
        // call.argument("data")
      } else if (call.method == "viewCart") {
        // call.argument("data")
      } else if (call.method == "beginCheckout") {
        // call.argument("data")
      } else if (call.method == "placeOrder") {
        // call.argument("data")
      } else if (call.method == "cancelOrder") {
        // call.argument("data")
      } else if (call.method == "addToWishList") {
        // call.argument("data")
      } else if (call.method == "removeFromWishList") {
        // call.argument("data")
      } else if (call.method == "search") {
        // call.argument("data")
      } else if (call.method == "sendDeviceEvent") {
        // call.argument("data")
      } else if (call.method == "getInboxMessages") {
        // call.argument("offset")
        // call.argument("limit")
      } else if (call.method == "deleteInboxMessage") {
        // call.argument("id")
      } else if (call.method == "setInboxMessageAsClicked") {
      } else if (call.method == "setNavigation") {
        //
      } else if (call.method == "setNavigationWithName") {
        // call.argument("screenName")
      } else {
        result.notImplemented()
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
// call.argument("id")
