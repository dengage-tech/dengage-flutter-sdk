import 'package:dengage_flutter/dengage_flutter_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:dengage_flutter/test_page.dart';

var androidKey =
    "7VJRT9FBZdxMBoe2pNX4_s_l_7z3SkzvQTMEoZ_s_l_MmV9QvULukRdACg_s_l_GyMduz_s_l_qlxyO4Bs9W4B6U007IgfiNCxvKL4fDz29kxT9qUUJHSzOLbaI24Co0N4Dw1sZrBuAWkKQCEV_p_l_0vXZtOSXV_s_l_jizKYpqGg_e_q__e_q_";
var iosKey =
    "K8sbLq1mShD52Hu2ZoHyb3tvDE_s_l_h99xFTF60WiNPdHhJtvmOqekutthtzRIPiMTbAa3y_p_l_PZqpon8nanH8YnJ8yYKocDb4GCAp7kOsi5qv7mDR_p_l_qOFLLp9_p_l_lloC6ds97X";
void main() async {
  await DengageFlutterPlatform.instance.init(
    androidIntegrationKey: androidKey,
    iosIntegrationKey: iosKey,
  );
  DengageFlutterPlatform.instance.setLogStatus(true);

  runApp(const MaterialApp(home: TestPage()));
}
