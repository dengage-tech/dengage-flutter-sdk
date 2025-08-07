package com.example.dengage_flutter_example

import android.os.Bundle
import com.example.dengage_flutter.DengageCoordinator
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DengageCoordinator.sharedInstance.setupDengage(
            true,
            "LhuNnzuDciWsS33YvGYkczjdRCPqqjBnYsj59evZoxFvh9boPLRVfIKYRMB20EY7Q8BSWfCbDLlGOw5eTHUrfivUPtovcM7dxa7L0o7h_s_l_b3DSlOEE4pEmWP_p_l_WdAY2nc2U6AqUD4vyotWvedcILpKsg_e_q__e_q_",
            "8dwwj3Sw7zcZUiZvpZDZ_s_l_eQoDcttLq3nKtwPao_p_l_4jmlEft7RQjg3r5j4_p_l_8CuzL4qFpkdsyajnf0DnChCJHtL9ln6CAlVd9_p_l_UcqliZFk3smNT4NiSvC21zgsMPcL0vnfM0FoN9P41smQbgBlY28NAVA_e_q__e_q_",false,
            false,
            applicationContext
        )
    }
}
