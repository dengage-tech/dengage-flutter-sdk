package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import androidx.appcompat.app.AppCompatActivity
import com.dengage.sdk.DengageEvent
import com.dengage.sdk.callback.DengageCallback
import com.dengage.sdk.models.DengageError
import com.dengage.sdk.models.InboxMessage
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import android.content.Intent
import com.dengage.sdk.NotificationReceiver
import android.content.IntentFilter
import android.util.Log
import com.dengage.sdk.models.Message
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import org.json.JSONObject

/** DengageFlutterPlugin */
class DengageFlutterPlugin: FlutterPlugin, MethodCallHandler, DengageResponder(), ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var appContext: Context
  private lateinit var appActivity: Activity

  private val ON_NOTIFICATION_CLICKED = "com.dengage.flutter/onNotificationClicked"

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dengage_flutter")
    channel.setMethodCallHandler(this)

    var notifReceiver: NotificationReceiver? = null
    EventChannel(flutterPluginBinding.flutterEngine.dartExecutor, ON_NOTIFICATION_CLICKED).setStreamHandler(
            object : StreamHandler {
              override fun onListen(arguments: Any?, events: EventSink?) {
                Log.d("den/flutter", "RegisteringNotificationListeners.")

                val filter = IntentFilter()
                filter.addAction("com.dengage.push.intent.RECEIVE")
                filter.addAction("com.dengage.push.intent.OPEN")
                notifReceiver = createNotifReciever(events)

                appContext.registerReceiver(notifReceiver, filter)
              }

              override fun onCancel(arguments: Any?) {
                appContext.unregisterReceiver(notifReceiver)
                notifReceiver = null
              }
            }
    )

    appContext = flutterPluginBinding.applicationContext
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    appActivity = binding.activity
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    appActivity = binding.activity
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      if (call.method == "dEngage#setIntegerationKey") {
        setIntegerationKey(call, result)
      }
      else if (call.method == "dEngage#setContactKey") {
        setContactKey(call, result)
      } else if (call.method == "dEngage#setHuaweiIntegrationKey") {
        this.setHuaweiIntegrationKey(call, result)
      } else if (call.method == "dEngage#setFirebaseIntegrationKey") {
        this.setFirebaseIntegrationKey(call, result)
      } else if (call.method == "dEngage#setLogStatus") {
        this.setLogStatus(call, result)
      } else if (call.method == "dEngage#setPermission") {
        this.setUserPermission(call, result)
      } else if (call.method == "dEngage#setToken") {
        this.setToken(call, result)
      } else if (call.method == "dEngage#getToken") {
        this.getToken(call, result)
      } else if (call.method == "dEngage#getContactKey") {
        this.getContactKey(call, result)
      } else if (call.method == "dEngage#getUserPermission") {
        this.getUserPermission(call, result)
      } else if (call.method == "dEngage#getSubscription") {
        this.getSubscription(call, result)
      } else if (call.method == "dEngage#pageView") {
        this.pageView(call, result)
      } else if (call.method == "dEngage#addToCart") {
        this.addToCart(call, result)
      } else if (call.method == "dEngage#removeFromCart") {
        this.removeFromCart(call, result)
      } else if (call.method == "dEngage#viewCart") {
        this.viewCart(call, result)
      } else if (call.method == "dEngage#beginCheckout") {
        this.beginCheckout(call, result)
      } else if (call.method == "dEngage#placeOrder") {
        this.placeOrder(call, result)
      } else if (call.method == "dEngage#cancelOrder") {
        this.cancelOrder(call, result)
      } else if (call.method == "dEngage#addToWishList") {
        this.addToWishList(call, result)
      } else if (call.method == "dEngage#removeFromWishList") {
        this.removeFromWishList(call, result)
      } else if (call.method == "dEngage#search") {
        this.search(call, result)
      } else if (call.method == "dEngage#sendDeviceEvent") {
        this.sendDeviceEvent(call, result)
      } else if (call.method == "dEngage#getInboxMessages") {
        this.getInboxMessages(call, result)
      } else if (call.method == "dEngage#deleteInboxMessage") {
        this.deleteInboxMessage(call, result)
      } else if (call.method == "dEngage#setInboxMessageAsClicked") {
        this.setInboxMessageAsClicked(call, result)
      } else if (call.method == "dEngage#setNavigation") {
        this.setNavigation(call, result)
      } else if (call.method == "dEngage#setNavigationWithName") {
        this.setNavigationWithName(call, result)
      } else {
        result.notImplemented()
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  private fun createNotifReciever(events: EventSink?): NotificationReceiver? {
    return object : NotificationReceiver() {
      override fun onReceive(context: Context?, intent: Intent) {
        Log.d("den/Flutter", "inOnReceiveOfCreateNotifReceiver.")
        val intentAction = intent.action
        if (intentAction != null) {
          when (intentAction.hashCode()) {
            -825236177 -> {
              if (intentAction == "com.dengage.push.intent.RECEIVE") {
                Log.d("den/Flutter", "received new push.")
                val message: Message = intent.getExtras()?.let { Message(it) }!!
                if (events != null) {
                  // todo: later when required emit seperate event for onNotificationReceived
//                  events.success(Gson().toJson(message))
                } else {
                  Log.d("den/flutter", "events is null while received push")
                }
              }
            }
            -520704162 -> {
              // intentAction == "com.dengage.push.intent.RECEIVE"
              Log.d("den/Flutter", "push is clicked.")
              val message: Message = intent.getExtras()?.let { Message(it) }!!
              if (events != null) {
                events.success(Gson().toJson(message))
              } else {
                Log.d("den/flutter", "events is null while clicked push")
              }
            }
          }
        }
      }
    }
  }

  /**
   * Method to set the integeration key.
   */
  private fun setIntegerationKey (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      throw Exception("This method is not available in android. please use 'setHuaweiIntegrationKey' OR 'setFirebaseIntegrationKey' instead.")
    } catch (ex: Exception) {
      replyError(result, "Error:Method not available", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set contact key
   * by setting contactKey, subscription get activated automatically.
   */
  private fun setContactKey (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val contactKey: String? = call.argument("contactKey")
      if (contactKey != null) {
        DengageCoordinator.sharedInstance.dengageManager?.setContactKey(contactKey)
        replySuccess(result, true)
      } else {
        throw Exception("required argument 'contactKey' is missing.");
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set the value for Huawei Integeration Key
   */
  private fun setHuaweiIntegrationKey (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val key: String? = call.argument("key")
      if (key != null) {
        DengageCoordinator.sharedInstance.dengageManager?.setHuaweiIntegrationKey(key)
      } else {
        throw Exception("required arugment 'key' is missing.")
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set the value for Firebase Integration Key
   */
  private fun setFirebaseIntegrationKey (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val key: String? = call.argument("key")
      if (key != null) {
        DengageCoordinator.sharedInstance.dengageManager?.setFirebaseIntegrationKey(key)
      } else {
        throw Exception("required arugment 'key' is missing.")
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set Log Status
   */
  private fun setLogStatus (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val logStatus: Boolean? = call.argument("isVisible") ?: false
      DengageCoordinator.sharedInstance.dengageManager?.setLogStatus(logStatus)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set user permission
   */
  private fun setUserPermission (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val hasPermission: Boolean? = call.argument("hasPermission") ?: false
      DengageCoordinator.sharedInstance.dengageManager?.setPermission(hasPermission)
      replySuccess(result, null)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set the user's token.
   */
  private fun setToken (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val token: String? = call.argument("token")
      if (token != null) {
        DengageCoordinator.sharedInstance.dengageManager?.subscription?.token = token
      } else {
        throw Exception("required argument 'token' is missing.")
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get the user's token
   */
  private fun getToken (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val token = DengageCoordinator.sharedInstance.dengageManager?.subscription?.token
      if (token !== null) {
        replySuccess(result, token)
        return
      }
      throw Exception("unable to get token.");
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get user's ContactKey
   */
  private fun getContactKey (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val contactKey = DengageCoordinator.sharedInstance.dengageManager?.subscription?.contactKey
      replySuccess(result, contactKey)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get current permission status
   */
  private fun getUserPermission (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val userPermission = DengageCoordinator.sharedInstance.dengageManager?.subscription?.permission
      replySuccess(result, userPermission)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get current subscription
   */
  private fun getSubscription (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val subscription = DengageCoordinator.sharedInstance.dengageManager?.subscription
      replySuccess(result, Gson().toJson(subscription))
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set pageView events
   */
  private fun pageView (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).pageView(data)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to add items To Cart
   */
  private fun addToCart (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).addToCart(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to remove items from cart
   */
  private fun removeFromCart (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).removeFromCart(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to view cart
   */
  private fun viewCart (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).viewCart(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to begin checkout
   */
  private fun beginCheckout (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).beginCheckout(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to place an Order
   */
  private fun placeOrder (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).order(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to cancel an Order
   */
  private fun cancelOrder (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).cancelOrder(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to add an order to WishList
   */
  private fun addToWishList (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).addToWishList(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to remove an order from WishList
   */
  private fun removeFromWishList (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).removeFromWishList(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to search
   */
  private fun search (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      DengageEvent.getInstance(appContext).search(data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to sendDeviceEvent
   */
  private fun sendDeviceEvent (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      val tableName: String = call.argument("tableName")!!
      DengageEvent.getInstance(appContext).sendDeviceEvent(tableName, data)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to getInboxMessages
   */
  private fun getInboxMessages (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val offset: Int = call.argument("offset")!!
      val limit: Int = call.argument("limit") ?: 15
      val callback = object : DengageCallback<List<InboxMessage>> {
        override fun onError(error: DengageError) {
          replyError(result, "error", error.errorMessage, error)
        }

        override fun onResult(response: List<InboxMessage>) {
          replySuccess(result, Gson().toJson(response))
        }
      }
      DengageCoordinator.sharedInstance.dengageManager?.getInboxMessages(limit, offset, callback)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to deleteInboxMessage
   */
  private fun deleteInboxMessage (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val id: String = call.argument("id")!!
      DengageCoordinator.sharedInstance.dengageManager!!.deleteInboxMessage(id)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setInboxMessageAsClicked
   */
  private fun setInboxMessageAsClicked (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val id: String = call.argument("id")!!
      DengageCoordinator.sharedInstance.dengageManager!!.setInboxMessageAsClicked(id)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setNavigation
   */
  private fun setNavigation (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      DengageCoordinator.sharedInstance.dengageManager!!.setNavigation(appActivity as AppCompatActivity)
      replySuccess(result, true)
    } catch (ex: Exception){
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setNavigation with screen name.
   */
  private fun setNavigationWithName (@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val screenName: String = call.argument("screenName")!!
      DengageCoordinator.sharedInstance.dengageManager!!.setNavigation(appActivity as AppCompatActivity, screenName)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity () {
    // todo: could be used for clearing app Activity.
  }

  override fun onDetachedFromActivityForConfigChanges () {
    // todo: could be used for clearing app Activity.
  }
}
