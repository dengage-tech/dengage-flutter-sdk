package com.example.dengage_flutter_example

import android.os.Bundle
import com.example.dengage_flutter.DengageCoordinator
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DengageCoordinator.sharedInstance.setupDengage(
            true,
            "iDaLcms9gAObZ_s_l_wv47OqqDFbBwCjj0Xzo6X93kEFaVDfuPFE_s_l_LcCEemlf_p_l_SKqCUeTXkySY5_p_l_7r2oUif0K1cZonyTyzmSY2MHxHaY0tN_s_l_gk2nPpkbZ8hkU9p1ZycYNPCECKXBmzzaPA9hr_p_l_L5aZvpXA_e_q__e_q_",
            "your-huawei-key-here",
            true,false,
            applicationContext
        )
    }
}
