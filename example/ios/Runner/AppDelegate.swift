import UIKit
import Flutter
import dengage_flutter
import UserNotifications
import Dengage

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

    //  UNUserNotificationCenter.current().delegate = self

          Dengage.handleNotificationActionBlock { (notificationResponse) in

                  var response:Dictionary<String,Any> = Dictionary()// = [String:Any?]();
                  response["actionIdentifier"] = notificationResponse.actionIdentifier

                  var notification:Dictionary<String,Any> = Dictionary()
                  notification["date"] = notificationResponse.notification.date.description

                  var notificationReq:Dictionary<String,Any> = Dictionary()
                  notificationReq["identifier"] = notificationResponse.notification.request.identifier
                  if (notificationResponse.notification.request.trigger?.repeats != nil) {
                      var notificationReqTrigger:Dictionary<String,Any> = Dictionary()
                      notificationReqTrigger["repeats"] = notificationResponse.notification.request.trigger?.repeats ?? nil
                      notificationReq["trigger"] = notificationReqTrigger
                  }

                  var reqContent:Dictionary<String,Any> = Dictionary()
                  var contentAttachments = [Dictionary<String,Any>]()
                  for attachement in notificationResponse.notification.request.content.attachments {
                      var contentAttachment:Dictionary<String,Any> = Dictionary()
                      contentAttachment["identifier"] = attachement.identifier
                      contentAttachment["url"] = attachement.url.absoluteString
                      contentAttachment["type"] = attachement.type
                      contentAttachments.append(contentAttachment)
                  }
                  reqContent["badge"] = notificationResponse.notification.request.content.badge
                  reqContent["body"] = notificationResponse.notification.request.content.body
                  reqContent["categoryIdentifier"] = notificationResponse.notification.request.content.categoryIdentifier
                  reqContent["launchImageName"] = notificationResponse.notification.request.content.launchImageName
      //
      //            // @NSCopying open var sound: UNNotificationSound? { get }
      //            //reqContent["sound"] = notificationResponse.notification.request.content.sound // this yet ignored, will include later.
      //
                  reqContent["subtitle"] = notificationResponse.notification.request.content.subtitle
                  reqContent["threadIdentifier"] = notificationResponse.notification.request.content.threadIdentifier
                  reqContent["title"] = notificationResponse.notification.request.content.title
                  reqContent["userInfo"] = notificationResponse.notification.request.content.userInfo
                  // todo: make sure it is RCTCovertible & doesn't break the code

                 // todo: will include this only if required.
                 if #available(iOS 12.0, *) {
                     reqContent["summaryArgument"] = notificationResponse.notification.request.content.summaryArgument
                     reqContent["summaryArgumentCount"] = notificationResponse.notification.request.content.summaryArgumentCount
                 }

                 if #available(iOS 13.0, *) {
                     reqContent["targetContentIdentifier"] = notificationResponse.notification.request.content.targetContentIdentifier
                 }


                  reqContent["attachments"] = contentAttachments
                  notificationReq["content"] = reqContent
                  notification["request"] = notificationReq
                  response["notification"] = notification

               print(response)
              }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    override func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let coordinator = DengageCoordinator.staticInstance;
            coordinator.registerForPushToken(deviceToken:deviceToken)
        }

    
}
