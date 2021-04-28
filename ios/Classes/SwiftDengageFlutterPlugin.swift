import Flutter
import UIKit
import Dengage_Framework

public class SwiftDengageFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dengage_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftDengageFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break;
    case "setIntegerationKey":
        self.setIntegrationKey(call: call, result: result)
        break;
    case "promptForPushNotifications":
        self.promptForPushNotifications(call: call, result: result)
        break;
    case "promptForPushNotificationsWithCallback":
        self.promptForPushNotificationsWithCallback(call: call, result: result)
        break;
    case "setUserPermission":
        self.setUserPermission(call: call, result: result)
        break;
    case "registerForRemoteNotifications":
        self.registerForRemoteNotifications(call: call, result: result)
        break;
    case "getToken":
        self.getToken(call: call, result: result)
        break;
    case "getContactKey":
        self.getContactKey(call: call, result: result)
        break;
    case "setToken":
        self.setToken(call: call, result: result)
        break;
    case "setLogStatus":
        self.setLogStatus(call: call, result: result)
        break;
    case "setContactKey":
        self.setContactKey(call: call, result: result)
        break;
    case "handleNotificationActionBlock":
        self.handleNotificationActionBlock(call: call, result: result)
        break;
    case "pageView":
        self.pageView(call: call, result: result)
        break;
    case "addToCart":
        self.addToCart(call: call, result: result)
        break;
    case "removeFromCart":
        self.removeFromCart(call: call, result: result)
        break;
    case "viewCart":
        self.viewCart(call: call, result: result)
        break;
    case "beginCheckout":
        self.beginCheckout(call: call, result: result)
        break;
    case "placeOrder":
        self.placeOrder(call: call, result: result)
        break;
    case "cancelOrder":
        self.cancelOrder(call: call, result: result)
        break;
    case "addToWithList":
        self.addToWithList(call: call, result: result)
        break;
    case "removeFromWishList":
        self.removeFromWishList(call: call, result: result)
        break;
    case "search":
        self.search(call: call, result: result)
        break;
    case "sendDeviceEvent":
        self.sendDeviceEvent(call: call, reply: result)
        break;
    case "getSubscription":
        self.getSubscription(call: call, result: result)
        break;
    case "getInboxMessages":
        self.getInboxMessages(call: call, reply: result)
        break;
    case "deleteInboxMessage":
        self.deleteInboxMessage(call: call, reply: result)
        break;
    case "setInboxMessageAsClicked":
        self.setInboxMessageAsClicked(call: call, reply: result)
        break;
    case "setNavigation":
        self.setNavigation(call: call, reply: result)
        break;
    case "setNavigationWithName":
        self.setNavigationWithName(call: call, reply: result)
        break;
        default:
            result("not implemented.")
    }
  }
    
    /**
     Function to set Integeration key
        to the value from argument.
     */
    private func setIntegrationKey (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let key = arguments["key"] as! String
        if (key == nil || key.isEmpty) {
            print("key is empty or missing.")
            result(FlutterError.init(code: "error", message: "Required argument 'key' is missing or empty.", details: nil))
            return
        }
        print("key is non-null & is not empty and is: \(key)")
        Dengage.setIntegrationKey(key: key as! String)
        result(true)
    }
    
    /**
     Function to prompt push permission
     to take user's consent.
     */
    private func promptForPushNotifications (call: FlutterMethodCall, result: @escaping FlutterResult) {
        Dengage.promptForPushNotifications()
        result(nil)
    }
    
    /** Function to prompt for push notification and
        acknowledge back .
     */
    private func promptForPushNotificationsWithCallback(call: FlutterMethodCall, result: @escaping FlutterResult) {
        Dengage.promptForPushNotifications() { hasPermission in
            result(hasPermission)
        }
    }

    /**
     Method to set the user permission
     */
    private func setUserPermission (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let permission = arguments["permission"] as! Bool
        if (permission == nil) {
            result(FlutterError.init(code: "error", message: "Required argument 'permission' is missing.", details: nil))
            return
        }
        Dengage.setUserPermission(permission: permission)
        result(nil)
    }
    
    /**
     Method to register for remote notifications
     */
    private func registerForRemoteNotifications (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let enabled = arguments["enabled"] as! Bool
        if (enabled == nil) {
            result(FlutterError.init(code: "error", message: "Required argument 'enabled' is missing.", details: nil))
            return
        }
        Dengage.registerForRemoteNotifications(enable: enabled)
        result(nil)
    }
    
    /**
     Method to getToken
     */
    private func getToken (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let token = Dengage.getToken()
        result(token)
    }

    /**
     Method to getContactKey
     */
    private func getContactKey (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let contactKey = try Dengage.getContactKey()
        result(contactKey)
    }

    /**
     Method to setToken
     */
    private func setToken (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let token = arguments["token"] as! String
        if (token.isEmpty) {
            result(FlutterError.init(code: "error", message: "Required argument 'token' is missing.", details: nil))
            return
        }
        Dengage.setToken(token: token)
        result(nil)
    }

    /**
     Method to setLogStatus
     */
    private func setLogStatus (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let isVisible = arguments["isVisible"] as! Bool
        Dengage.setLogStatus(isVisible: isVisible)
        result(nil)
    }

    /**
     Method to setContactKey
     */
    private func setContactKey (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let contactKey = arguments["contactKey"] as! String
        Dengage.setContactKey(contactKey: contactKey)
        result(nil)
    }
    
    /**
     * Method to handle notification action block.
     */
    func handleNotificationActionBlock (call: FlutterMethodCall, result: @escaping FlutterResult) {
        Dengage.handleNotificationActionBlock { (notificationResponse) in
            var response = [String:Any?]();
            response["actionIdentifier"] = notificationResponse.actionIdentifier

            var notification = [String:Any?]()
            notification["date"] = notificationResponse.notification.date.description

            var notificationReq = [String:Any?]()
            notificationReq["identifier"] = notificationResponse.notification.request.identifier

            if (notificationResponse.notification.request.trigger?.repeats != nil) {
                var notificationReqTrigger = [String:Any?]()
                notificationReqTrigger["repeats"] = notificationResponse.notification.request.trigger?.repeats ?? nil
                notificationReq["trigger"] = notificationReqTrigger
            }

            var reqContent = [String:Any?]()
            var contentAttachments = [Any]()
            for attachement in notificationResponse.notification.request.content.attachments {
                var contentAttachment = [String:Any?]()
                contentAttachment["identifier"] = attachement.identifier
                contentAttachment["url"] = attachement.url
                contentAttachment["type"] = attachement.type
                contentAttachments.append(contentAttachment)
            }
            reqContent["badge"] = notificationResponse.notification.request.content.badge
            reqContent["body"] = notificationResponse.notification.request.content.body
            reqContent["categoryIdentifier"] = notificationResponse.notification.request.content.categoryIdentifier
            reqContent["launchImageName"] = notificationResponse.notification.request.content.launchImageName
            // @NSCopying open var sound: UNNotificationSound? { get }
            //reqContent["sound"] = notificationResponse.notification.request.content.sound // this yet ignored, will include later.
            reqContent["subtitle"] = notificationResponse.notification.request.content.subtitle
            reqContent["threadIdentifier"] = notificationResponse.notification.request.content.threadIdentifier
            reqContent["title"] = notificationResponse.notification.request.content.title
            reqContent["userInfo"] = notificationResponse.notification.request.content.userInfo // todo: make sure it is RCTCovertible & doesn't break the code
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

            result([response])
        }
    }
    
    /**
     * Method to send pageView event data
     */
    func pageView (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSDictionary
        DengageEvent.shared.pageView(params: data as! NSMutableDictionary)
        result(nil)
    }

    /**
     * Method to addToCart
     */
    func addToCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.addToCart(params: data)
    }
    
    /**
     * Method to addToCart
     */
    func removeFromCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.removeFromCart(params: data)
    }
    
    /**
     * Method to viewCart
     */
    func viewCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.viewCart(params: data)
    }

    /**
     * Method to beginCheckout
     */
    func beginCheckout (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.beginCheckout(params: data)
    }

    /**
     * Method to place an order
     */
    func placeOrder (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.order(params: data)
    }

    /**
     * Method to cancel an order
     */
    func cancelOrder (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.cancelOrder(params: data)
    }
    
    /**
     * Method to addToWithList
     */
    func addToWithList (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.addToWithList(params: data)
    }

    /**
     * Method to removeFromWishList
     */
    func removeFromWishList (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.removeFromWithList(params: data)
    }

    /**
     * Method to search
     */
    func search (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["data"] as! NSMutableDictionary
        DengageEvent.shared.search(params: data)
    }
    
    /**
     * Method to sendDeviceEvent
     */
    func sendDeviceEvent (call: FlutterMethodCall, reply: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! NSDictionary
        let withData = arguments["data"] as! NSMutableDictionary
        let tableName = arguments["tableName"] as! String
        Dengage.SendDeviceEvent(toEventTable: tableName, andWithEventDetails: withData)
    }
    
    /**
     * Method to getSubscription
     */
    func getSubscription(call: FlutterMethodCall, result: @escaping FlutterResult){
        // this method is yet not available in iOS
        result(FlutterError.init(code: "NO_NATIVE_METHOD_YET", message: "this method is yet not available in iOS", details: nil))
    }
    
    /**
     * Method to getInboxMessages
     */
    func getInboxMessages(call: FlutterMethodCall, reply: @escaping FlutterResult) {
        // offset: Int = 10, limit: Int = 20
        let arguments = call.arguments as! NSDictionary
        let offset = arguments["offset"] as! Int
        let limit = arguments["limit"] as! Int

        Dengage.getInboxMessages(offset: offset, limit: limit) { (result) in
            switch result {
                case .success(let resultType): // do something with the result
                    do {
                        let encodedData = try JSONEncoder().encode(resultType)
                        let jsonString = String(data: encodedData,
                                                encoding: .utf8)
                        reply(jsonString)
                    } catch {
                        reply(FlutterError.init(code: "error", message: error.localizedDescription , details: error))
                    }
                    break;
                case .failure(let error): // Handle the error
                    reply(FlutterError.init(code: "error", message: error.localizedDescription , details: error))
                    break;
            }
        }
    }
    
    /**
     * Method to deleteInboxMessage
     */
    func deleteInboxMessage (call: FlutterMethodCall, reply: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let id = arguments["id"] as! String
        Dengage.deleteInboxMessage(with: id) { (result) in
            switch result {
                case .success:
                    reply(["success": true, "id": id])
                    break;
                case .failure (let error):
                    reply(FlutterError.init(code: "error", message: error.localizedDescription , details: error))
                    break;
            }
        }
    }

    /**
     * Method to setInboxMessageAsClicked
     */
    func setInboxMessageAsClicked (call: FlutterMethodCall, reply: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let id = arguments["id"] as! String
        Dengage.setInboxMessageAsClicked (with: id) { (result) in
            switch result {
                case .success:
                    reply(["success": true, "id": id])
                    break;
                case .failure (let error):
                    reply(FlutterError.init(code: "error", message: error.localizedDescription , details: error))
                    break;
            }
        }
    }

    /**
     * Method to setNavigation
     */
    func setNavigation(call: FlutterMethodCall, reply: @escaping FlutterResult){
        Dengage.setNavigation()
        reply(nil)
    }

    /**
     * Method to setNavigationWithName
     */
    func setNavigationWithName(call: FlutterMethodCall, reply: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let screenName = arguments["screenName"] as! String
        Dengage.setNavigation(screenName: screenName)
        reply(nil)
    }
}
