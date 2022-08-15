import Flutter
import UIKit
import Dengage

public class SwiftDengageFlutterPlugin: NSObject, FlutterPlugin, FlutterApplicationLifeCycleDelegate {
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        print("register")
        let channel = FlutterMethodChannel(name: "dengage_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftDengageFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        let event_channel = FlutterEventChannel(name: "dengageEvent", binaryMessenger: registrar.messenger())
        registrar.addApplicationDelegate(instance)
        
    }
    var launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        self.launchOptions = launchOptions as! [UIApplication.LaunchOptionsKey : Any]?
        return true
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        var token = "";
        if #available(iOS 13.0, *){
            
            token = deviceToken.map { String(format: "%02x", $0) }.joined()
        }
        else{
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            token = tokenParts.joined()
        }
        print(token)
        Dengage.register(deviceToken: deviceToken)
        
        
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        
        switch call.method  {
        case "getPlatformVersion": result("iOS " + UIDevice.current.systemVersion)
            break;
        case "init":
            
            if let key:String = call.args("iosIntegrationKey"){
                
                Dengage.start(apiKey: key, application: UIApplication.shared, launchOptions: self.launchOptions,dengageOptions:  DengageOptions(disableOpenURL: false, badgeCountReset: true, disableRegisterForRemoteNotifications: false))
                Dengage.promptForPushNotifications()
                Dengage.set(permission: true)
                result(nil)
            }else{
                result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "Init Error"))
            }
            
            break;
        case "setLogStatus":
            Dengage.setLog(isVisible: call.args("enable") ?? false)
            result(nil)
            break;
        case "setFirebaseIntegrationKey":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "setFirebaseIntegrationKey only android"))
            break;
        case "setHuaweiIntegrationKey":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "setHuaweiIntegrationKey only android"))
            break;
        case "getSubscription":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "getSubscription only android"))
            break;
        case "setDeviceId":
            if let key:String = call.args("deviceId"){
                Dengage.set(deviceId: key)
                result(nil)
            }else{
                result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "Init Error"))
            }
            break;
        case "setCountry":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "setCountry only android"))
            break;
        case "setContactKey":
            if let key:String = call.args("contactKey"){
                Dengage.set(contactKey:  key)
                result(nil)
            }else{
                result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "Init Error"))
            }
            break;
        case "setUserPermission":
            result(Dengage.set(permission: true))
            break;
        case "getUserPermission":
            result(Dengage.getPermission())
            break;
        case "setToken":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "setToken only android"))
            break;
        case "getToken":
            result(Dengage.getDeviceToken())
            break;
        case "onNewToken":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "onNewToken only android"))
            
            break;
        case "setNotificationChannelName":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "setNotificationChannelName only android"))
            break;
        case "startAppTracking":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "startAppTracking only android"))
            break;
        case "getInboxMessages":
            
            if let offset:Int = call.args("offset"), let limit:Int = call.args("limit"){
                Dengage.getInboxMessages(offset: offset, limit: limit, success: {(v)  in
                    
                    do {
                        let encodedData = try JSONSerialization.data(withJSONObject:v,options:[])
                        let jsonString = String(data: encodedData,encoding: .utf8)
                        result(jsonString)
                    }catch{
                        result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "getInboxMessages Error"))
                    }
                    
                }, error:{(v) in
                    result(FlutterError.init(code: "Dengage Flutter IOS", message: "Error", details: v.localizedDescription))
                    
                })
                
            }else{
                result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "getInboxMessages Error"))
            }
            
            
            break;
        case "deleteInboxMessage":
            result(FlutterError.init(code: "Dengage  Flutter IOS", message: "Error", details: "deleteInboxMessage Error"))
            
            break;
        case "setInboxMessageAsClicked": break;
        case "setNavigation": break;
        case "setTags": break;
        case "onMessageReceived": break;
        case "showTestPage":
            Dengage.showTestPage()
            result(nil)
            break;
        case "saveRFMScores": break;
        case "categoryView": break;
        case "sortRFMItems": break;
        case "pageView": break;
        case "sendCartEvents": break;
        case "addToCart": break;
        case "removeFromCart": break;
        case "viewCart": break;
        case "beginCheckout": break;
        case "cancelOrder": break;
        case "order": break;
        case "search": break;
        case "sendWishListEvents": break;
        case "addToWishList": break;
        case "removeFromWishList": break;
        case "sendCustomEvent": break;
        case "sendDeviceEvent": break;
        case "sendOpenEvent": break;
        case "requestLocationPermissions": break;
        case "sendLoginEvent": break;
        case "sendLogoutEvent": break;
        case "sendRegisterEvent": break;
        default:
            result("not implemented.")
        }
    }
}


extension FlutterMethodCall{
    func args<T>(_ key:String) -> T? {
        let data = arguments as? [String: Any]
        return data?[key] as? T
    }
}
