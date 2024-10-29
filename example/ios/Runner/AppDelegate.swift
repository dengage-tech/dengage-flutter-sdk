import UIKit
import Flutter
import dengage_flutter
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
    let coordinator = DengageCoordinator.staticInstance;
   // coordinator.setupDengage(key: "K8sbLq1mShD52Hu2ZoHyb3tvDE_s_l_h99xFTF60WiNPdHhJtvmOqekutthtzRIPiMTbAa3y_p_l_PZqpon8nanH8YnJ8yYKocDb4GCAp7kOsi5qv7mDR_p_l_qOFLLp9_p_l_lloC6ds97X", launchOptions: launchOptions as NSDictionary?);
      
      coordinator.setupDengage(key: "4vPb6ldynxkMe5_p_l_j5mk_s_l_Mzf5IDjqoARjx_s_l_KQEBB1iw6c2EDnH7bz6QTIHsdGSCkeJP2kO7ZSD_s_l_PDTkB6jyG8ebacnSdRsenDLujyQwFZTxQNOUiiGgoLCoEJ_s_l_NhkNVg2UQOFMZPpAXr6P_p_l_R6PXBujw_e_q__e_q_", enableGeoFence : true,launchOptions: launchOptions as NSDictionary?, application: application,askNotificationPermission:true,disableOpenURL:false,badgeCountReset: false);
      
      UNUserNotificationCenter.current().delegate = self
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let coordinator = DengageCoordinator.staticInstance;
            coordinator.registerForPushToken(deviceToken:deviceToken)
        }
    
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let coordinator = DengageCoordinator.staticInstance;
        coordinator.didReceivePush(center, response, withCompletionHandler: completionHandler)
        
    }
    
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
        
    }
    
}
