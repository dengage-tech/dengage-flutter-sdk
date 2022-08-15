package com.emintolgahanpolat.dengage_flutter

import android.app.Activity
import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import com.dengage.sdk.Dengage
import com.dengage.sdk.callback.DengageCallback
import com.dengage.sdk.callback.DengageError
import com.dengage.sdk.domain.configuration.model.AppTracking
import com.dengage.sdk.domain.inboxmessage.model.InboxMessage
import com.dengage.sdk.domain.push.model.Message
import com.dengage.sdk.domain.rfm.model.RFMGender
import com.dengage.sdk.domain.rfm.model.RFMItem
import com.dengage.sdk.domain.rfm.model.RFMScore
import com.dengage.sdk.domain.tag.model.TagItem
import com.dengage.sdk.util.DengageLifecycleTracker
import com.google.gson.Gson

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DengageFlutterPlugin */
class DengageFlutterPlugin: FlutterPlugin, MethodCallHandler , ActivityAware {

  private lateinit var channel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dengage_flutter")
    channel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "dengageEvent")


    eventChannel.setStreamHandler(PushNotificationReceiverStreamHandler(context))
  }


  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {


    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "init" -> {
        Dengage.init(
          context,
          call.argument("androidIntegrationKey"),
          call.argument("huaweiIntegrationKey"),
          null,
          call.argument("geofenceEnabled") ?: false
        )
        result.success(null)
      }
      "setLogStatus" -> {
        result.success(Dengage.setLogStatus(call.argument("enable") ?: false))
      }
      "setFirebaseIntegrationKey" -> {
        val value: String? = call.argument("integrationKey")
        if (value != null) {
          Dengage.setFirebaseIntegrationKey(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setHuaweiIntegrationKey" -> {
        val value: String? = call.argument("integrationKey")
        if (value != null) {
          Dengage.setHuaweiIntegrationKey(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "getSubscription" -> {
        result.success(Gson().toJson(Dengage.getSubscription()))
      }
      "setDeviceId" -> {
        val value: String? = call.argument("deviceId")
        if (value != null) {
          Dengage.setDeviceId(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setCountry" -> {
        val value: String? = call.argument("country")
        if (value != null) {
          Dengage.setCountry(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setContactKey" -> {
        val value: String? = call.argument("contactKey")
        if (value != null) {
          Dengage.setContactKey(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setUserPermission" -> {
        Dengage.setUserPermission(call.argument("permission") ?: false)
        result.success(null)
      }
      "getUserPermission" -> {
        result.success(Dengage.getUserPermission())
      }
      "setToken" -> {
        val value: String? = call.argument("token")
        if (value != null) {
          Dengage.setToken(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "getToken" -> {
        result.success(Dengage.getToken())
      }
      "onNewToken" -> {
        val value: String? = call.argument("token")
        if (value != null) {
          Dengage.onNewToken(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setNotificationChannelName" -> {
        val value: String? = call.argument("name")
        if (value != null) {
          Dengage.setNotificationChannelName(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "startAppTracking" -> {
        val value: List<AppTracking>? = call.argument("appTrackings") // gson
        if (value != null) {
          Dengage.startAppTracking(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "getInboxMessages" -> {
        val limit: Int? = call.argument("limit")
        val offset: Int? = call.argument("offset")
        if (limit != null && offset != null) {
          Dengage.getInboxMessages(
            limit,
            offset,
            object : DengageCallback<MutableList<InboxMessage>> {
              override fun onError(error: DengageError) {
                result.error(
                  "getInboxMessages",
                  error.errorMessage,
                  "getInboxMessages"
                )
              }

              override fun onResult(result1: MutableList<InboxMessage>) {
                result.success(Gson().toJson(result1))
              }
            })

        } else {
          result.error("", "", "")
        }

      }
      "deleteInboxMessage" -> {
        val value: String? = call.argument("messageId")
        if (value != null) {
          Dengage.deleteInboxMessage(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setInboxMessageAsClicked" -> {
        val value: String? = call.argument("messageId")
        if (value != null) {
          Dengage.setInboxMessageAsClicked(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setNavigation" -> {
        val value: String? = call.argument("screenName")
        if (value != null) {
          Dengage.setNavigation(activity, value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "setTags" -> {
        val value: List<TagItem>? = call.argument("tags") // gson
        if (value != null) {
          Dengage.setTags(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "onMessageReceived" -> {
        val data: Map<String, String?>? = call.argument("data")
        if (data != null) {
          Dengage.onMessageReceived(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "showTestPage" -> {
        Dengage.showTestPage(activity)
        result.success(null)
      }
      "saveRFMScores" -> {
        val value: MutableList<RFMScore>? = call.argument("scores") // gson
        if (value != null) {
          Dengage.saveRFMScores(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "categoryView" -> {
        val value: String? = call.argument("categoryId")
        if (value != null) {
          Dengage.categoryView(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "sortRFMItems" -> {
        val rfmGender: RFMGender? = call.argument("")
        val rfmItems: MutableList<RFMItem>? = call.argument("")
        if (rfmGender != null && rfmItems != null) {
          result.success(Gson().toJson(Dengage.sortRFMItems<Any>(rfmGender, rfmItems)))

        } else {
          result.error("", "", "")
        }
      }
      "pageView" -> {
        val value: HashMap<String, Any>? = call.argument("data")
        if (value != null) {
          Dengage.pageView(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "sendCartEvents" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        val eventType: String? = call.argument("eventType")
        if (data != null && eventType != null) {
          Dengage.sendCartEvents(data, eventType)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "addToCart" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        if (data != null) {
          Dengage.addToCart(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "removeFromCart" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        if (data != null) {
          Dengage.removeFromCart(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "viewCart" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        if (data != null) {
          Dengage.viewCart(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "beginCheckout" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        if (data != null) {
          Dengage.beginCheckout(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "cancelOrder" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        if (data != null) {
          Dengage.cancelOrder(data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "order" -> {
        val value: HashMap<String, Any>? = call.argument("data")
        if (value != null) {
          Dengage.order(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "search" -> {
        val value: HashMap<String, Any>? = call.argument("data")
        if (value != null) {
          Dengage.search(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "sendWishListEvents" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        val eventType: String? = call.argument("eventType")
        if (data != null && eventType != null) {
          Dengage.sendWishListEvents(data, eventType)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "addToWishList" -> {
        val value: HashMap<String, Any>? = call.argument("data")
        if (value != null) {
          Dengage.addToWishList(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "removeFromWishList" -> {
        val value: HashMap<String, Any>? = call.argument("data")
        if (value != null) {
          Dengage.removeFromWishList(value)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "sendCustomEvent" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        val tableName: String? = call.argument("tableName")
        val key: String? = call.argument("key")
        if (tableName != null && key != null && data != null) {
          Dengage.sendCustomEvent(tableName, key, data)
          result.success(null)
        } else {
          result.error("", "", "")
        }

      }
      "sendDeviceEvent" -> {
        val data: HashMap<String, Any>? = call.argument("data")
        val tableName: String? = call.argument("tableName")
        if (tableName != null && data != null) {
          Dengage.sendDeviceEvent(tableName, data)
          result.success(null)
        } else {
          result.error("", "", "")
        }
      }
      "sendOpenEvent" -> {

        val buttonId: String? = call.argument("buttonId")
        val itemId: String? = call.argument("itemId")
        val message: Message? = call.argument("message")
        if (buttonId != null && itemId != null && message != null) {
          Dengage.sendOpenEvent(itemId, buttonId, message)
          result.success(null)
        } else {
          result.error("", "", "")
        }

      }
      "requestLocationPermissions" -> {
        Dengage.requestLocationPermissions(activity)
        result.success(null)
      }
      "sendLoginEvent" -> {
        Dengage.sendLoginEvent()
        result.success(null)
      }
      "sendLogoutEvent" -> {
        Dengage.sendLogoutEvent()
        result.success(null)
      }
      "sendRegisterEvent" -> {
        Dengage.sendRegisterEvent()
        result.success(null)
      }
      else -> {

        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    registerActivity(binding);
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    registerActivity(binding);
  }

  private fun registerActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      activity.registerActivityLifecycleCallbacks(DengageLifecycleTracker())
    }
  }

  override fun onDetachedFromActivity() {

  }

}
