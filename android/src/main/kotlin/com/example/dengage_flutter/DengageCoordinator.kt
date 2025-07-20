package com.example.dengage_flutter

import android.content.Context
import com.dengage.hms.DengageHmsManager
import com.dengage.sdk.Dengage
import com.dengage.sdk.DengageManager


class DengageCoordinator private constructor() {

    fun setupDengage(
        logStatus: Boolean,
        firebaseKey: String?,
        huaweiKey: String?,
        restartApplication :Boolean?,
        disableWebOpenUrl :Boolean?,
        context: Context
    ) {
        if (firebaseKey == null && huaweiKey == null) {
            throw Error("Both firebase key and huawei key can't be null at the same time.");
        }

        val dengageHmsManager = DengageHmsManager()
        Dengage.init(context = context,
           firebaseIntegrationKey = firebaseKey,
            huaweiIntegrationKey = huaweiKey,
            dengageHmsManager = dengageHmsManager,
            disableOpenWebUrl = disableWebOpenUrl,
        )
        if (restartApplication != null) {
            Dengage.restartApplicationAfterPushClick(restartApplication)
        }
        Dengage.setLogStatus(logStatus)
    }

    companion object {
        var sharedInstance = DengageCoordinator()
    }
}
