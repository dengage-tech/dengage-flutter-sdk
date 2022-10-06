package com.example.dengage_flutter

import android.content.Context
import com.dengage.sdk.DengageManager

class DengageCoordinator private constructor() {
    var dengageManager: DengageManager? = null

    fun setupDengage(
        logStatus: Boolean,
        firebaseKey: String?,
        huaweiKey: String?,
        enableGeoFence: Boolean,
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
                    .init()
            }
            firebaseKey == null -> {
                dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .init()
            }
            else -> {
                dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setHuaweiIntegrationKey(huaweiKey)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .init()
            }
        }
    }

    companion object {
        var sharedInstance = DengageCoordinator()
    }
}
