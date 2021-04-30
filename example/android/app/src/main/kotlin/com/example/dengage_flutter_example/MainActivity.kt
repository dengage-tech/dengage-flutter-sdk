package com.example.dengage_flutter_example

import android.os.Bundle
import com.example.dengage_flutter.DengageCoordinator
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DengageCoordinator.sharedInstance.setupDengage(
                true,
                "FEYl27JxJfay6TxiYCdlkP2FXeuhNfEoI8WkxI_p_l__s_l_5sLbzKmc9c88mSZxRCrLuqMK4y0e8nHajQnBt8poBNDMvNtIytYKZ6byBQZOE8kqkkgDnlye2Lb5AcW3tuIWQjYz",
                "your-huawei-key-here",
                applicationContext
        )
    }
}
