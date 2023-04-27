package com.example.dengage_flutter

import android.content.Context
import com.dengage.sdk.Dengage
import com.dengage.sdk.DengageManager

class DengageCoordinator private constructor() {
    var dengageManager: DengageManager? = null

    fun setupDengage(
        logStatus: Boolean,
        firebaseKey: String?,
        restartApplication :Boolean?,
        context: Context
    ) {
        if (firebaseKey == null ) {
            throw Error("Firebase key cannot be null");
        }
        dengageManager = DengageManager.getInstance(context)
                    .setLogStatus(logStatus)
                    .setFirebaseIntegrationKey(firebaseKey)
                    .init()
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
