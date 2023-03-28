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
            "FtbMV5Z720x5tmG4nrmFeIg8PQolnQStKyPskmsf8O7m1aTsua7twzdHe_s_l_94qq2iKjyt_s_l_gzPRIvU3R5B_s_l_vAN01t3EmCg9EQI6ylCYMcX36wXgoNthZPyQdUn_s_l_NSZSwjdROB_s_l_oAPL77HLw8TeRh2muA_e_q__e_q_",
            "your-huawei-key-here",
            applicationContext
        )
    }
}
