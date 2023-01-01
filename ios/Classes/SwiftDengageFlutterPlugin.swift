import Flutter
import UIKit
import Dengage

enum EventChannelName {
  static let onNotificationClicked = "com.dengage.flutter/onNotificationClicked"
}

public class SwiftDengageFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  private var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dengage_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftDengageFlutterPlugin()

    let notificationEventChannel = FlutterEventChannel(name: EventChannelName.onNotificationClicked,
                                                       binaryMessenger: registrar.messenger())
    notificationEventChannel.setStreamHandler(instance.self)

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func onListen(withArguments arguments: Any?,
                         eventSink: @escaping FlutterEventSink) -> FlutterError? {
      self.eventSink = eventSink
      self.listenForNotification()
      return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "dEngage#getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break;
    case "dEngage#setIntegerationKey":
        self.setIntegrationKey(call: call, result: result)
        break;
    case "dEngage#promptForPushNotifications":
        self.promptForPushNotifications(call: call, result: result)
        break;
    case "dEngage#promptForPushNotificationsWithPromise":
        self.promptForPushNotificationsWithPromise(call: call, result: result)
        break;
    case "dEngage#setUserPermission":
        self.setUserPermission(call: call, result: result)
        break;
    case "dEngage#registerForRemoteNotifications":
        self.registerForRemoteNotifications(call: call, result: result)
        break;
    case "dEngage#getToken":
        self.getToken(call: call, result: result)
        break;
    case "dEngage#getContactKey":
        self.getContactKey(call: call, result: result)
        break;
    case "dEngage#setToken":
        self.setToken(call: call, result: result)
        break;
    case "dEngage#setLogStatus":
        self.setLogStatus(call: call, result: result)
        break;
    case "dEngage#setContactKey":
        self.setContactKey(call: call, result: result)
        break;
    case "dEngage#handleNotificationActionBlock":
        self.handleNotificationActionBlock(call: call, result: result)
        break;
    case "dEngage#pageView":
        self.pageView(call: call, result: result)
        break;
    case "dEngage#addToCart":
        self.addToCart(call: call, result: result)
        break;
    case "dEngage#removeFromCart":
        self.removeFromCart(call: call, result: result)
        break;
    case "dEngage#viewCart":
        self.viewCart(call: call, result: result)
        break;
    case "dEngage#beginCheckout":
        self.beginCheckout(call: call, result: result)
        break;
    case "dEngage#placeOrder":
        self.placeOrder(call: call, result: result)
        break;
    case "dEngage#cancelOrder":
        self.cancelOrder(call: call, result: result)
        break;
    case "dEngage#addToWithList":
        self.addToWithList(call: call, result: result)
        break;
    case "dEngage#removeFromWishList":
        self.removeFromWishList(call: call, result: result)
        break;
    case "dEngage#search":
        self.search(call: call, result: result)
        break;
    case "dEngage#sendDeviceEvent":
        self.sendDeviceEvent(call: call, reply: result)
        break;
    case "dEngage#getSubscription":
        self.getSubscription(call: call, result: result)
        break;
    case "dEngage#getInboxMessages":
        self.getInboxMessages(call: call, reply: result)
        break;
    case "dEngage#deleteInboxMessage":
        self.deleteInboxMessage(call: call, reply: result)
        break;
    case "dEngage#setInboxMessageAsClicked":
        self.setInboxMessageAsClicked(call: call, reply: result)
        break;
    case "dEngage#setNavigation":
        self.setNavigation(call: call, reply: result)
        break;
    case "dEngage#setNavigationWithName":
        self.setNavigationWithName(call: call, reply: result)
        break;
    case "dEngage#setTags":
        self.setTags(call: call, reply: result)
        break;
    case "dEngage#showRealTimeInApp":
        self.showRealTimeInApp(call: call, reply: result)
        break;
    case "dEngage#setCity":
        self.setCity(call: call, result: result)
        break;
    case "dEngage#setState":
        self.setState(call: call, result: result)
        break;
    case "dEngage#setCartAmount":
        self.setCartAmount(call: call, result: result)
        break;
    case "dEngage#setCartItemCount":
        self.setCartItemCount(call: call, result: result)
        break;
    case "dEngage#setCategoryPath":
        self.setCategoryPath(call: call, result: result)
        break;
    case "dEngage#setPartnerDeviceId":
        self.setPartnerDeviceId(call: call, result: result)
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
    private func promptForPushNotificationsWithPromise(call: FlutterMethodCall, result: @escaping FlutterResult) {
        Dengage.promptForPushNotifications() { hasPermission in
            result(hasPermission)
        }
    }

    /**
     Method to set the user permission
     */
    private func setUserPermission (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let permission = arguments["hasPermission"] as! Bool
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
       // Dengage.registerForRemoteNotifications(enable: enabled)
        
        Dengage.promptForPushNotifications()
        
        result(nil)
    }

    /**
     Method to getToken
     */
    private func getToken (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let token = Dengage.getDeviceToken()
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
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.pageView(parameters: data)
        result(nil)
    }

    /**
     * Method to addToCart
     */
    func addToCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.addToCart(parameters: data)
    }

    /**
     * Method to addToCart
     */
    func removeFromCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.removeFromCart(parameters: data)
    }

    /**
     * Method to viewCart
     */
    func viewCart (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.viewCart(parameters: data)
        
    }

    /**
     * Method to beginCheckout
     */
    func beginCheckout (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.beginCheckout(parameters: data)
    }

    /**
     * Method to place an order
     */
    func placeOrder (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.order(parameters: data)
    }

    /**
     * Method to cancel an order
     */
    func cancelOrder (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.cancelOrder(parameters: data)
    }

    /**
     * Method to addToWithList
     */
    func addToWithList (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.addToWithList(parameters: data)
    }

    /**
     * Method to removeFromWishList
     */
    func removeFromWishList (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String : Any]
        let data = arguments["data"] as! [String : Any]
        Dengage.removeFromWithList(parameters: data)
    }

    /**
     * Method to search
     */
    func search (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String:Any]
        let data = arguments["data"] as! [String:Any]
        Dengage.search(parameters: data)
    }

    /**
     * Method to sendDeviceEvent
     */
    func sendDeviceEvent (call: FlutterMethodCall, reply: @escaping FlutterResult) -> Void {
        let arguments = call.arguments as! [String:Any]
        let withData = arguments["data"] as! [String:Any]
        let tableName = arguments["tableName"] as! String
        Dengage.sendCustomEvent(eventTable: tableName, parameters: withData)
        reply(true)
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

                        var arrDict = [[String:Any]]()
                        var arrCarousel = [[String:String]]()

                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                        formatter.timeZone = TimeZone(abbreviation: "UTC")


                        for dict in resultType
                        {
                            if let items = dict.carouselItems
                            {
                                for carousel in items
                                {
                                    arrCarousel.append(["id": carousel.id ?? "", "title":carousel.title ?? "" , "descriptionText":carousel.descriptionText ?? "" , "mediaUrl": carousel.mediaUrl ?? "" ,  "targetUrl":carousel.targetUrl ?? ""])


                                }

                                arrDict.append(["message_json" : ["iosMediaUrl": dict.mediaURL ?? "", "iosTargetUrl":dict.targetUrl ?? "" , "iosCarouselContent": arrCarousel, "mediaUrl":dict.mediaURL ?? "" , "message": dict.message ?? "" , "receiveDate": formatter.string(from: dict.receiveDate ?? Date()) ?? "", "targetUrl":dict.targetUrl ?? "" , "title": dict.title ?? "" ], "is_clicked": dict.isClicked, "smsg_id": dict.id])
                            }
                            else
                            {
                                arrDict.append(["message_json" : ["iosMediaUrl": dict.mediaURL ?? "", "iosTargetUrl":dict.targetUrl ?? "" , "iosCarouselContent": [], "mediaUrl":dict.mediaURL ?? "" , "message": dict.message ?? "" , "receiveDate": formatter.string(from: dict.receiveDate ?? Date()) ?? "", "targetUrl":dict.targetUrl ?? "" , "title": dict.title ?? "" ], "is_clicked": dict.isClicked, "smsg_id": dict.id])
                            }



                        }

                        let encodedData = try JSONSerialization.data(withJSONObject: arrDict, options: .prettyPrinted)

                        let jsonString = String(data: encodedData,
                                                encoding: .utf8)
                        print("JSON String of inbox API \(jsonString)")
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

    /**
     * Method to setNavigationWithName
     */
    func setTags(call: FlutterMethodCall, reply: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let data = arguments["tags"] as! [NSDictionary]

        var tags: [TagItem] = []
        for tag in data {
            let tagItem:TagItem = TagItem.init(
                tagName: tag["tagName"] as! String,
                tagValue: tag["tagValue"] as! String,
                changeTime: tag["changeTime"] as! Date?,
                removeTime: tag["removeTime"] as! Date?,
                changeValue: tag["changeValue"] as! String?
            )
            tags.append(tagItem)
        }
        Dengage.setTags(tags)
        reply(nil)
    }

    /**
     * Method to setupDengage
     */
    func setupDengage(call: FlutterMethodCall, reply: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary

        let integrationKey = arguments["integrationKey"] as! NSString
        let application = arguments["application"] as? UIApplication


        DengageCoordinator.staticInstance.setupDengage(key: integrationKey, launchOptions: nil, application: application)

        reply(nil)
    }


    /**
     * Method to listen for notification click.
     */

    func listenForNotification () {
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

            guard let eventSink = self.eventSink else {
              return
            }
            eventSink([response])
        }
    }


    /**
     * Method to sendDeviceEvent
     */
    func showRealTimeInApp (call: FlutterMethodCall, reply: @escaping FlutterResult)  {
        let arguments = call.arguments as! [String:Any]
        let data = arguments["data"] as! Dictionary<String, String>?
        let screenName = arguments["screenName"] as! String
        Dengage.showRealTimeInApp(screenName: screenName, params: data)
        reply(nil)
    }
    
    private func setCity (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let city = arguments["city"] as! String
      
        Dengage.setCity(name: city)
        result(nil)
    }
    
    private func setState (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let state = arguments["state"] as! String
      
        Dengage.setState(name: state)
        result(nil)
    }
    
    private func setCartAmount (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let amount = arguments["amount"] as! String
      
        Dengage.setCart(amount: amount)
        result(nil)
    }
    
    private func setCartItemCount (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let count = arguments["count"] as! String
      
        Dengage.setCart(itemCount: count)
        result(nil)
    }
    
    private func setCategoryPath (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let path = arguments["path"] as! String
      
        Dengage.setCategory(path: path)
        result(nil)
    }
    
    private func setPartnerDeviceId (call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let adid = arguments["adid"] as! String
      
        Dengage.setPartnerDeviceId(adid: adid)
        result(nil)
    }
}
