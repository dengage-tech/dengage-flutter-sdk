import UIKit
import Flutter
import dengage_flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let coordinator = DengageCoordinator.staticInstance;
    coordinator.setupDengage(key: "K8sbLq1mShD52Hu2ZoHyb3tvDE_s_l_h99xFTF60WiNPdHhJtvmOqekutthtzRIPiMTbAa3y_p_l_PZqpon8nanH8YnJ8yYKocDb4GCAp7kOsi5qv7mDR_p_l_qOFLLp9_p_l_lloC6ds97X", launchOptions: launchOptions as NSDictionary?);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let coordinator = DengageCoordinator.staticInstance;
            coordinator.registerForPushToken(deviceToken:deviceToken)
        }
}
