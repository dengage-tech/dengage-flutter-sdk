package com.emintolgahanpolat.dengage_flutter

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import io.flutter.plugin.common.EventChannel


class PushNotificationReceiverStreamHandler(private val context: Context): EventChannel.StreamHandler {
    var pushNotificationReceiver : PushNotificationReceiver?= null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if(events != null){
            pushNotificationReceiver = createNotifierReceiver(events)
            val filter = IntentFilter()
            filter.addAction("com.dengage.push.intent.RECEIVE")
            filter.addAction("com.dengage.push.intent.OPEN")
            context.registerReceiver(pushNotificationReceiver, filter)
        }
    }

    override fun onCancel(arguments: Any?) {
        context.unregisterReceiver(pushNotificationReceiver)
        pushNotificationReceiver = null
    }


    private fun createNotifierReceiver(events: EventChannel.EventSink): PushNotificationReceiver {
        return object : PushNotificationReceiver() {
            override fun onReceive(context: Context, intent: Intent?) {
                events.success("dengage")
            }
        }
    }
}