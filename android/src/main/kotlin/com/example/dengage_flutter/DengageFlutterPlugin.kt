package com.example.dengage_flutter

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import com.dengage.sdk.Dengage
import com.dengage.sdk.DengageManager
import com.dengage.sdk.callback.DengageCallback
import com.dengage.sdk.callback.DengageError
import com.dengage.sdk.domain.inboxmessage.model.InboxMessage
import com.dengage.sdk.domain.push.model.Message
import com.dengage.sdk.domain.tag.model.TagItem
import com.dengage.sdk.inapp.InAppBroadcastReceiver
import com.dengage.sdk.push.NotificationReceiver
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.util.*
import kotlin.collections.HashMap


/** DengageFlutterPlugin */
class DengageFlutterPlugin : FlutterPlugin, MethodCallHandler, DengageResponder(), ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var appContext: Context
  private lateinit var appActivity: Activity
  private lateinit var flutterPluginBindingGlobal: FlutterPlugin.FlutterPluginBinding

  private val ON_NOTIFICATION_CLICKED = "com.dengage.flutter/onNotificationClicked"

  private val INAPP_LINK_RETRIEVAL = "com.dengage.flutter/inAppLinkRetrieval"


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterPluginBindingGlobal=flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dengage_flutter")
    channel.setMethodCallHandler(this)

    var notifReceiver: NotificationReceiver? = null
    var inappReceiver: InAppBroadcastReceiver? = null
    EventChannel(flutterPluginBinding.flutterEngine.dartExecutor,
      ON_NOTIFICATION_CLICKED).setStreamHandler(
      object : StreamHandler {
        override fun onListen(arguments: Any?, events: EventSink?) {
          Log.d("den/flutter", "RegisteringNotificationListeners.")

          val filter = IntentFilter()
          filter.addAction("com.dengage.push.intent.RECEIVE")
          filter.addAction("com.dengage.push.intent.OPEN")
          notifReceiver = createNotifReciever(events)

          @SuppressLint("UnspecifiedRegisterReceiverFlag")
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            appContext.registerReceiver(notifReceiver, filter, RECEIVER_EXPORTED)
          } else {
            appContext.registerReceiver(notifReceiver, filter)
          }
//                try {
//
//                  var pushPayload =Dengage.getLastPushPayload()
//                  if (!pushPayload.isNullOrEmpty()) {
//
//                    Log.d("den/flutter", "RegisteringNotificationListeners.fsdf $pushPayload")
//                    events?.success(pushPayload)
//                  }
//                }
//                catch (e:Exception){}
        }

        override fun onCancel(arguments: Any?) {
          appContext.unregisterReceiver(notifReceiver)
          notifReceiver = null
        }
      }
    )

    EventChannel(flutterPluginBinding.flutterEngine.dartExecutor,
      INAPP_LINK_RETRIEVAL).setStreamHandler(
      object : StreamHandler {
        override fun onListen(arguments: Any?, events: EventSink?) {
          Dengage.setDevelopmentStatus(true)
          Dengage.inAppLinkConfiguration("ddd")
          Log.d("den/flutter", "RegisteringNotificationListeners.")

          val filter = IntentFilter()
          filter.addAction("com.dengage.inapp.LINK_RETRIEVAL")
          inappReceiver = createInAppLinkReciever(events)
          @SuppressLint("UnspecifiedRegisterReceiverFlag")
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            appContext.registerReceiver(inappReceiver, filter, RECEIVER_EXPORTED)
          } else {
            appContext.registerReceiver(inappReceiver, filter)
          }
//                try {
//
//                  var pushPayload =Dengage.getLastPushPayload()
//                  if (!pushPayload.isNullOrEmpty()) {
//
//                    Log.d("den/flutter", "RegisteringNotificationListeners.fsdf $pushPayload")
//                    events?.success(pushPayload)
//                  }
//                }
//                catch (e:Exception){}
        }

        override fun onCancel(arguments: Any?) {
          appContext.unregisterReceiver(inappReceiver)
          notifReceiver = null
        }
      }
    )

    appContext = flutterPluginBinding.applicationContext
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    appActivity = binding.activity
    flutterPluginBindingGlobal.platformViewRegistry.registerViewFactory(
      "plugins.dengage/inappinline",InAppInlineFactory(appActivity))
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    appActivity = binding.activity
    flutterPluginBindingGlobal.platformViewRegistry.registerViewFactory(
      "plugins.dengage/inappinline",InAppInlineFactory(appActivity))
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      if (call.method == "dEngage#setIntegerationKey") {
        setIntegerationKey(call, result)
      } else if (call.method == "dEngage#setContactKey") {
        setContactKey(call, result)
      }  else if (call.method == "dEngage#setFirebaseIntegrationKey") {
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
      } else if (call.method == "dEngage#setTags") {
        this.setTags(call, result)
      } else if (call.method == "dEngage#showRealTimeInApp") {
        this.showRealTimeInApp(call, result)
      } else if (call.method == "dEngage#setCity") {
        this.setCity(call, result)
      } else if (call.method == "dEngage#setState") {
        this.setState(call, result)
      } else if (call.method == "dEngage#setCartAmount") {
        this.setCartAmount(call, result)
      } else if (call.method == "dEngage#setCartItemCount") {
        this.setCartItemCount(call, result)
      } else if (call.method == "dEngage#setCategoryPath") {
        this.setCategoryPath(call, result)
      } else if (call.method == "dEngage#setPartnerDeviceId") {
        this.setPartnerDeviceId(call, result)
      } else if (call.method == "dEngage#setInAppLinkConfiguration") {
        this.setInAppLinkConfiguration(call, result)
      }
      if (call.method == "dEngage#getLastPushPayload") {
        this.getLastPushPayload(call, result)
      } else {
        // result.notImplemented()
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  private fun createNotifReciever(events: EventSink?): NotificationReceiver? {
    return object : NotificationReceiver() {
      override fun onReceive(context: Context, intent: Intent?) {
        Log.d("den/Flutter", "inOnReceiveOfCreateNotifReceiver.")
        val intentAction = intent?.action
        if (intentAction != null) {
          when (intentAction.hashCode()) {
            -825236177 -> {
              if (intentAction == "com.dengage.push.intent.RECEIVE") {
                Log.d("den/Flutter", "received new push.")
                //  val message: Message = intent?.getExtras()?.let { Message(it) }!!
                if (events != null) {
                  // todo: later when required emit seperate event for onNotificationReceived
//                  events.success(Gson().toJson(message))
                } else {
                  Log.d("den/flutter", "events is null while received push")
                }
              }
            }
            -520704162 -> {
              Dengage.getLastPushPayload()
              // intentAction == "com.dengage.push.intent.RECEIVE"
              Log.d("den/Flutter", "push is clicked.")
              val message: Message =
                intent?.getExtras()?.let { Message.createFromIntent(it) }!!
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

  private fun createInAppLinkReciever(events: EventSink?): InAppBroadcastReceiver? {
    return object : InAppBroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("den/Flutter", "inInAppRetrieval.")

        val jsonObject = JSONObject()
        jsonObject.put("targetUrl", intent?.extras?.getString("targetUrl"))

        if (events != null) {
          events.success(Gson().toJson(jsonObject.toString()))
        } else {
          Log.d("den/flutter", "events is null while clicked push")
        }
      }
    }
  }

  /**
   * Method to set the integeration key.
   */
  private fun setIntegerationKey(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun setContactKey(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val contactKey: String? = call.argument("contactKey")
      DengageCoordinator.sharedInstance.dengageManager?.setContactKey(contactKey)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to set the value for Firebase Integration Key
   */
  private fun setFirebaseIntegrationKey(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun setLogStatus(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun setUserPermission(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun setToken(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun getToken(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun getContactKey(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val contactKey =
        DengageCoordinator.sharedInstance.dengageManager?.subscription?.contactKey
      replySuccess(result, contactKey)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get current permission status
   */
  private fun getUserPermission(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val userPermission =
        DengageCoordinator.sharedInstance.dengageManager?.subscription?.permission
      replySuccess(result, userPermission)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to get current subscription
   */
  private fun getSubscription(@NonNull call: MethodCall, @NonNull result: Result) {
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
  private fun pageView(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.pageView(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to add items To Cart
   */
  private fun addToCart(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.addToCart(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to remove items from cart
   */
  private fun removeFromCart(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.removeFromCart(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to view cart
   */
  private fun viewCart(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.viewCart(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to begin checkout
   */
  private fun beginCheckout(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.beginCheckout(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to place an Order
   */
  private fun placeOrder(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.order(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to cancel an Order
   */
  private fun cancelOrder(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.cancelOrder(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to add an order to WishList
   */
  private fun addToWishList(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.addToWishList(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to remove an order from WishList
   */
  private fun removeFromWishList(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.removeFromWishList(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to search
   */
  private fun search(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      Dengage.search(data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to sendDeviceEvent
   */
  private fun sendDeviceEvent(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      val tableName: String = call.argument("tableName")!!
      Dengage.sendDeviceEvent(tableName, data as HashMap<String, Any>)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to getInboxMessages
   */
  private fun getInboxMessages(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val offset: Int = call.argument("offset")!!
      val limit: Int = call.argument("limit") ?: 15
      val callback = object : DengageCallback<List<InboxMessage>> {
        override fun onError(error: DengageError) {
          val list = mutableListOf<Map<String, Any?>>()
          replySuccess(result, list)
        }

        override fun onResult(response: List<InboxMessage>) {
          val list = mutableListOf<Map<String, Any?>>()
          for (message in response) {
            val json = Gson().toJson(message)
            android.util.Log.d("getInboxMessages", json)
            var map: Map<String, Any?> = HashMap<String, Any?>()
            map = Gson().fromJson(json, map::class.java)
            android.util.Log.d("getInboxMessages", map.size.toString())
            list.add(map)
          }
          replySuccess(result, list)
        }
      }
      DengageCoordinator.sharedInstance.dengageManager?.getInboxMessages(limit,
        offset,
        callback)
    } catch (ex: Exception) {
      val list = mutableListOf<Map<String, Any?>>()
      replySuccess(result, list)
    }
  }

  /**
   * Method to deleteInboxMessage
   */
  private fun deleteInboxMessage(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val id: String = call.argument("id")!!
      DengageCoordinator.sharedInstance.dengageManager!!.deleteInboxMessage(id)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setInboxMessageAsClicked
   */
  private fun setInboxMessageAsClicked(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val id: String = call.argument("id")!!
      DengageCoordinator.sharedInstance.dengageManager!!.setInboxMessageAsClicked(id)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setNavigation
   */
  private fun setNavigation(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      // todo: appActivity has to be AppCompatActivity but flutter activity isn't yet appcompat.
      DengageCoordinator.sharedInstance.dengageManager!!.setNavigation(appActivity)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setNavigation with screen name.
   */
  private fun setNavigationWithName(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val screenName: String = call.argument("screenName")!!
      DengageCoordinator.sharedInstance.dengageManager!!.setNavigation(appActivity,
        screenName)
      replySuccess(result, true)
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Method to setTags.
   */
  private fun setTags(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val data: List<HashMap<String, Any>> = call.argument("tags")!!
      Log.d("V/Den/RN/Android", data.toString())

      val finalTags = data.map {
        if (it["tagName"] != null && it["tagValue"] != null) {
          if (it["changeTime"] != null && it["changeValue"] != null && it["removeTime"] != null) {
            TagItem(
              it["tagName"] as String,
              it["tagValue"] as String,
              it["changeTime"] as Date?,
              it["changeValue"]?.toString(),
              it["removeTime"] as Date?
            )
          } else {
            TagItem(
              it["tagName"] as String,
              it["tagValue"] as String
            )
          }
        } else {
          throw Exception("required arugment 'tagName' Or 'tagValue' is missing.")
        }
      }

      DengageCoordinator.sharedInstance.dengageManager?.setTags(finalTags)
      replySuccess(result, true)
    } catch (ex: Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }



  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    // todo: could be used for clearing app Activity.
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // todo: could be used for clearing app Activity.
  }

  private fun setCartItemCount(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val count: String = call.argument("count")!!

      Dengage.setCartItemCount(count)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Set cart amount for using in real time in app comparisons
   */

  private fun setCartAmount(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val amount: String = call.argument("amount")!!

      Dengage.setCartAmount(amount)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }

  }

  /**
   * Set state for using in real time in app comparisons
   */

  private fun setState(@NonNull call: MethodCall, @NonNull result: Result) {

    try {
      val state: String = call.argument("state")!!


      Dengage.setState(state)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }


  }

  /**
   * Set city for using in real time in app comparisons
   */

  private fun setCity(@NonNull call: MethodCall, @NonNull result: Result) {

    try {
      val city: String = call.argument("city")!!

      Dengage.setCity(city)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }

  }


  private fun showRealTimeInApp(
    @NonNull call: MethodCall, @NonNull result: Result,
  ) {
    try {
      val data: Map<String, Any>? = call.argument("data")
      val screenName: String = call.argument("screenName")!!

      Dengage.showRealTimeInApp(appActivity, screenName, data as HashMap<String, String>?)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }
  }

  /**
   * Set category path for using in real time in app comparisons
   */

  private fun setPartnerDeviceId(@NonNull call: MethodCall, @NonNull result: Result) {

    try {
      val adid: String = call.argument("adid")!!
      Dengage.setPartnerDeviceId(adid)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }


  }


  /**
   * Set category path for using in real time in app comparisons
   */

  private fun setCategoryPath(@NonNull call: MethodCall, @NonNull result: Result) {

    try {
      val adid: String = call.argument("path")!!
      Dengage.setCategoryPath(adid)
      replySuccess(result, true)
    } catch (ex: java.lang.Exception) {
      Log.e("V/Den/RN/:setTagsErr", ex.localizedMessage)

      replyError(result, "error", ex.localizedMessage, ex)
    }


  }

  /**
   * Method to get the user's token
   */
  private fun getLastPushPayload(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val pushPayload = Dengage.getLastPushPayload()
      if (pushPayload !== null) {
        replySuccess(result, pushPayload)
        return
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }


  private fun setInAppLinkConfiguration(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val deeplink: String? = call.argument("deepLink")
      if (!deeplink.isNullOrEmpty()) {
        Dengage.inAppLinkConfiguration(deeplink)
      } else {
        throw Exception("required argument 'deepLink' is missing.")
      }
    } catch (ex: Exception) {
      replyError(result, "error", ex.localizedMessage, ex)
    }
  }
}
