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
            "7VJRT9FBZdxMBoe2pNX4_s_l_7z3SkzvQTMEoZ_s_l_MmV9QvULukRdACg_s_l_GyMduz_s_l_qlxyO4Bs9W4B6U007IgfiNCxvKL4fDz29kxT9qUUJHSzOLbaI24Co0N4Dw1sZrBuAWkKQCEV_p_l_0vXZtOSXV_s_l_jizKYpqGg_e_q__e_q_",
            "your-huawei-key-here",
            true,
            applicationContext
        )
    }
}
