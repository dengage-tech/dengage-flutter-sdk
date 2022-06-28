package com.example.dengage_flutter

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel
import java.util.*


abstract class DengageResponder {
    open lateinit var channel: MethodChannel

    /**
     * MethodChannel class is home to success() method used by Result class
     * It has the @UiThread annotation and must be run on UI thread, otherwise a RuntimeException will be thrown
     * This will communicate success back to Dart
     */
    fun replySuccess(reply: MethodChannel.Result, response: Any?) {
        //todo: check if this works without running on main Thread.
        // otherwise uncomment it and run on main thread.


        // runOnMainThread(Runnable { reply.success(response) })
        reply.success(response);
    }

    /**
     * MethodChannel class is home to error() method used by Result class
     * It has the @UiThread annotation and must be run on UI thread, otherwise a RuntimeException will be thrown
     * This will communicate error back to Dart
     */
    fun replyError(reply: MethodChannel.Result, tag: String, message: String?, response: Any?) {
        //todo: check if this works without running on main Thread.
        // otherwise uncomment it and run on main thread.

        // runOnMainThread(Runnable { reply.error(tag, message, response) })
        reply.error(tag, message, response)
    }

    /**
     * MethodChannel class is home to notImplemented() method used by Result class
     * It has the @UiThread annotation and must be run on UI thread, otherwise a RuntimeException will be thrown
     * This will communicate not implemented back to Dart
     */
    fun replyNotImplemented(reply: MethodChannel.Result) {
        //todo: check if this works without running on main Thread.
        // otherwise uncomment it and run on main thread.

//        runOnMainThread(Runnable { reply.notImplemented() })
        reply.notImplemented()
    }

    private fun runOnMainThread(runnable: Runnable) {
        if (Looper.getMainLooper().thread === Thread.currentThread()) runnable.run() else {
            val handler = Handler(Looper.getMainLooper())
            handler.post(runnable)
        }
    }

    fun invokeMethodOnUiThread(methodName: String?, map: HashMap<*, *>?) {
        val channel = channel
        runOnMainThread(Runnable { channel!!.invokeMethod(methodName!!, map) })
    }
}