package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class InAppInlineFactory(private val activity: Activity) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as HashMap<String, Any>
        return InAppInline(context,creationParams,activity)
    }
}