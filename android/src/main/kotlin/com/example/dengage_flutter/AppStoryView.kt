package com.example.dengage_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import com.dengage.sdk.Dengage
import com.dengage.sdk.ui.story.StoriesListView
import io.flutter.plugin.platform.PlatformView

class AppStoryView internal constructor(
    context: Context,
    private val creationParams: HashMap<String, Any?>,
    private val activity: Activity
) : PlatformView {

    companion object {
        private const val TAG = "DengageFlutter/AppStory"
    }

    private val container: FrameLayout = FrameLayout(context)
    private val storiesListView: StoriesListView = StoriesListView(context)

    init {
        Log.d(TAG, "init: creationParams keys=${creationParams.keys}, thread=${Thread.currentThread().name}")
        container.addView(storiesListView, FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        ))
        val propertyId = creationParams["propertyId"] as? String
        Log.d(TAG, "init: propertyId=$propertyId (isEmpty=${propertyId.isNullOrEmpty()})")
        if (!propertyId.isNullOrEmpty()) {
            val storyPropertyId = propertyId.trim()
            val screenName = creationParams["screenName"] as? String ?: ""
            val customParamsRaw = creationParams["customParams"]
            val customParams: HashMap<String, String>? = when (customParamsRaw) {
                is Map<*, *> -> {
                    val map = hashMapOf<String, String>()
                    (customParamsRaw as Map<*, *>).forEach { (k, v) ->
                        if (k is String && v is String) map[k] = v
                    }
                    if (map.isEmpty()) null else map
                }
                else -> null
            }
            Log.d(TAG, "init: screenName='$screenName', customParams=$customParams, activity=${activity.javaClass.simpleName}")
            // Cordova/RN run story display on UI thread; ensure we do the same
            activity.runOnUiThread {
                Log.d(TAG, "runOnUiThread: about to call Dengage.showStoriesList(propertyId=$storyPropertyId, screenName=$screenName)")
                try {
                    Dengage.showStoriesList(
                        storyPropertyId = storyPropertyId,
                        storiesListView = storiesListView,
                        activity = activity,
                        customParams = customParams,
                        screenName = screenName.ifEmpty { null }
                    )
                    Log.d(TAG, "runOnUiThread: Dengage.showStoriesList completed")
                } catch (e: Exception) {
                    Log.e(TAG, "runOnUiThread: Dengage.showStoriesList failed", e)
                }
            }
        } else {
            Log.w(TAG, "init: skipping showStoriesList - propertyId is null or empty")
        }
    }

    override fun getView(): View = container

    override fun dispose() {
        Log.d(TAG, "dispose")
    }
}
