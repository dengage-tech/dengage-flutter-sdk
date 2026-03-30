package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.view.View
import android.webkit.WebViewClient
import com.dengage.sdk.Dengage
import com.dengage.sdk.ui.inappmessage.InAppInlineElement
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class InAppInline internal constructor(
    context: Context,
    creationParams: HashMap<String, Any>,
    activity: Activity,
    messenger: BinaryMessenger,
    viewId: Int,
) : PlatformView {

    private val inAppInlineElement: InAppInlineElement = InAppInlineElement(context).apply {
        webViewClient = WebViewClient()
    }
    private val channel = MethodChannel(messenger, "plugins.dengage/inappinline_$viewId")
    private val handler = Handler(Looper.getMainLooper())
    private var lastReportedHidden: Boolean? = null
    private var hiddenSinceElapsed: Long? = null
    private var disposed = false

    init {
        val propertyId = creationParams["propertyId"] as String
        val customParams = creationParams["customParams"] as HashMap<String, String>?
        val screenName = creationParams["screenName"] as String?
        val hideIfNotFound = creationParams["hideIfNotFound"] as Boolean?
        Dengage.showInlineInApp(
            activity = activity,
            propertyId = propertyId,
            inAppInlineElement = inAppInlineElement,
            customParams = customParams,
            hideIfNotFound = hideIfNotFound,
            screenName = screenName,
        )
        startVisibilityPolling()
    }

    override fun getView(): View = inAppInlineElement

    private fun startVisibilityPolling() {
        handler.post(object : Runnable {
            override fun run() {
                if (disposed) return

                val notVisible = inAppInlineElement.visibility != View.VISIBLE
                val now = SystemClock.elapsedRealtime()
                val debouncedHidden = if (notVisible) {
                    if (hiddenSinceElapsed == null) hiddenSinceElapsed = now
                    (now - hiddenSinceElapsed!!) >= HIDDEN_DEBOUNCE_MS
                } else {
                    hiddenSinceElapsed = null
                    false
                }

                if (lastReportedHidden == null || lastReportedHidden != debouncedHidden) {
                    lastReportedHidden = debouncedHidden
                    channel.invokeMethod("onVisibilityChanged", mapOf("isHidden" to debouncedHidden))
                }

                handler.postDelayed(this, POLL_MS)
            }
        })
    }

    override fun dispose() {
        disposed = true
        inAppInlineElement.destroy()
    }

    private companion object {
        const val POLL_MS = 250L
        const val HIDDEN_DEBOUNCE_MS = 600L
    }
}
