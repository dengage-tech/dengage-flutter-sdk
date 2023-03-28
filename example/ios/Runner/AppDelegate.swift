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
      
      coordinator.setupDengage(key: "hVt7KpAkwbJXRO_s_l_p6To_p_l_9lIaG3HyOp2pYtPwnpzML4D5AGhv88nXj4tdG1MJOsDk0rE072ewsGRGyxdt7V7UAEO_s_l_mN01MRl6iQDiCbx_s_l_ndwua1_s_l_5KL8MXzpLiGbjvFol",launchOptions: launchOptions as NSDictionary?, application: application);
      
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
