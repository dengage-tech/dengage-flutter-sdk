package com.example.dengage_flutter

import android.content.Context
import com.dengage.sdk.Dengage
import com.dengage.sdk.push.IDengageHmsManager

class DengageCoordinator private constructor() {

    fun setupDengage(
        logStatus: Boolean,
        firebaseKey: String?,
        huaweiKey: String?,
        restartApplication: Boolean?,
        disableWebOpenUrl: Boolean?,
        context: Context
    ) {
        if (firebaseKey == null && huaweiKey == null) {
            throw Error("Both firebase key and huawei key can't be null at the same time.")
        }

        val hmsManager = if (huaweiKey != null && isHmsManagerAvailable()) {
            createHmsManager()
        } else null

        if (hmsManager != null) {
            Dengage.init(
                context,
                firebaseIntegrationKey = firebaseKey,
                huaweiIntegrationKey = huaweiKey,
                dengageHmsManager = hmsManager,
                disableOpenWebUrl = disableWebOpenUrl
            )
        } else {
            Dengage.init(
                context,
                firebaseIntegrationKey = firebaseKey,
                huaweiIntegrationKey = huaweiKey,
                disableOpenWebUrl = disableWebOpenUrl
            )
        }

        restartApplication?.let { Dengage.restartApplicationAfterPushClick(it) }
        Dengage.setLogStatus(logStatus)
    }

    private fun isHmsManagerAvailable(): Boolean {
        return try {
            Class.forName("com.dengage.hms.DengageHmsManager")
            true
        } catch (e: ClassNotFoundException) {
            false
        }
    }

    private fun createHmsManager(): IDengageHmsManager {
        val clazz = Class.forName("com.dengage.hms.DengageHmsManager")
        val instance = clazz.getConstructor().newInstance()
        return instance as IDengageHmsManager
    }

    companion object {
        var sharedInstance = DengageCoordinator()
    }
}
