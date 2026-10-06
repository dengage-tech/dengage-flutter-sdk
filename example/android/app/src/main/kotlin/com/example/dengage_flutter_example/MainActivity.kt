package com.example.dengage_flutter_example

import android.os.Bundle
import com.example.dengage_flutter.DengageCoordinator
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DengageCoordinator.sharedInstance.setupDengage(
            true,
            "9MBNB5X2IWf8oBfxaNjs5kWcmObGwc8g6bmJcqS2rprtPSJgAThZL_s_l_n1nypZLOoQApPKMzfFMoJpU_s_l_BQk9YpJMk3mn05bpF3_p_l_1XjtNC1jvrEkEZ3D8h5VmUz0U4xmiI0ycs7_s_l_BJ20fOwTQsOq5OXRA_e_q__e_q_",
            "9MBNB5X2IWf8oBfxaNjs5kWcmObGwc8g6bmJcqS2rprtPSJgAThZL_s_l_n1nypZLOoQApPKMzfFMoJpU_s_l_BQk9YpJMk3mn05bpF3_p_l_1XjtNC1jvrEkEZ3D8h5VmUz0U4xmiI0ycs7_s_l_BJ20fOwTQsOq5OXRA_e_q__e_q_",false,
            false,
            applicationContext
        )
    }
}
