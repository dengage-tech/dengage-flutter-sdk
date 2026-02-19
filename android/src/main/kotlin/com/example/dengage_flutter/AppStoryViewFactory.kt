package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AppStoryViewFactory(private val activity: Activity) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        private const val TAG = "DengageFlutter/AppStory"
    }

    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as? HashMap<String, Any?> ?: hashMapOf()
        Log.d(TAG, "Factory.create: id=$id, args=$creationParams")
        return AppStoryView(context, creationParams, activity)
    }
}
