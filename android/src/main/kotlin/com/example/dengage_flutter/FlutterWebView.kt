package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import android.view.View
import android.webkit.WebView
import android.webkit.WebViewClient
import com.dengage.sdk.Dengage
import com.dengage.sdk.ui.inappmessage.InAppInlineElement
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView


class FlutterWebView internal constructor(
    context: Context,
    creationParams:HashMap<String, Any>,
    activity: Activity
) :
    PlatformView {
    private lateinit var inAppInlineElement: InAppInlineElement
    override fun getView(): View {
        return inAppInlineElement
    }

    init {
        inAppInlineElement = InAppInlineElement(context)
        inAppInlineElement.webViewClient = WebViewClient()
        val propertyId = creationParams["propertyId"] as String
        val customParams = creationParams["customParams"] as HashMap<String, String>?
        val screenName = creationParams["screenName"] as String?
        val hideIfNotFound = creationParams["hideIfNotFound"] as Boolean?
        Dengage.showInlineInApp(activity=activity, propertyId = propertyId, inAppInlineElement = inAppInlineElement, customParams = customParams, hideIfNotFound = hideIfNotFound, screenName = screenName)

        //inAppInlineElement.loadUrl(propertyId)

    }




    override fun dispose() {
        inAppInlineElement.destroy()
    }

}