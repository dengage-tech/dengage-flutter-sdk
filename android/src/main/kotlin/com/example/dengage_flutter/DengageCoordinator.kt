package com.example.dengage_flutter

import android.content.Context
import com.dengage.sdk.Dengage
import com.dengage.sdk.DengageManager

class DengageCoordinator private constructor() {
    var dengageManager: DengageManager? = null

    fun setupDengage(
        logStatus: Boolean,
        firebaseKey: String?,
        huaweiKey: String?,
        enableGeoFence: Boolean,
        restartApplication :Boolean?,
        context: Context
    ) {
        if (firebaseKey == null && huaweiKey == null) {
            throw Error("Both firebase key and huawei key can't be null at the same time.");
        }

        when {
            huaweiKey == null -> {
                dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .setGeofenceStatus(enableGeoFence)
                    .init()
            }
            firebaseKey == null -> {
                dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .setGeofenceStatus(enableGeoFence)
                    .init()
            }
            else -> {
                dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .setGeofenceStatus(enableGeoFence)
                    .init()
            }
        }
        try {
            if (restartApplication != null) {
                Dengage.restartApplicationAfterPushClick(restartApplication)
            }
        }
        catch (e : Exception){}
    }

    companion object {
        var sharedInstance = DengageCoordinator()
    }
}
