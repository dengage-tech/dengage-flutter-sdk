//
//  DengageCoordinator.swift
//  dengage_flutter
//
//  Created by Kamran Younis on 22/04/2021.
//

import Foundation
import Flutter
import Dengage

@objc(DengageCoordinator)
public class DengageCoordinator: NSObject {
    @objc public static let staticInstance: DengageCoordinator = DengageCoordinator()

    // todo: will remove in case not used.
    @objc var integerationKey: String?
    @objc var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    @objc(setupDengage:launchOptions:application:askNotificaionPermission:disableOpenURL:badgeCountReset:)
    public func setupDengage(key:NSString, launchOptions:NSDictionary?,application:UIApplication?,askNotificaionPermission:DarwinBoolean,disableOpenURL:DarwinBoolean,badgeCountReset:DarwinBoolean) {
        Dengage.setIntegrationKey(key: key as String)
        
        if (launchOptions != nil) {
            
            let options = DengageOptions.init(disableOpenURL: disableOpenURL.boolValue, badgeCountReset: badgeCountReset.boolValue, disableRegisterForRemoteNotifications: false)
            
            Dengage.initWithLaunchOptions(application: application ?? UIApplication.shared, withLaunchOptions: launchOptions as! [UIApplication.LaunchOptionsKey : Any], dengageOptions: options)
           
        } else {
                        
            let options = DengageOptions.init(disableOpenURL: disableOpenURL.boolValue, badgeCountReset: badgeCountReset.boolValue, disableRegisterForRemoteNotifications: false)

            Dengage.initWithLaunchOptions(application: application ?? UIApplication.shared, withLaunchOptions: [:], dengageOptions: options)
            
        }
        
        
        Dengage.promptForPushNotifications()
        Dengage.setHybridAppEnvironment()
        
        
    }
    
    @objc(registerForPushToken:)
    public func registerForPushToken(deviceToken: Data) {
        var token = "";
        if #available(iOS 13.0, *){
            token = deviceToken.map { String(format: "%02x", $0) }.joined()
        }
        else {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            token = tokenParts.joined()
        }
        //sendToken(token)
        
        Dengage.register(deviceToken: deviceToken)
    }
    
    private func sendToken(_ token: String ){
        Dengage.setToken(token: token)
    }
    
    @objc(didReceivePush:response:withCompletionHandler:)
    public func didReceivePush(_ center: UNUserNotificationCenter,
                                            _ response: UNNotificationResponse,
                                            withCompletionHandler completionHandler: @escaping () -> Void) {

        Dengage.didReceivePush(center, response, withCompletionHandler: completionHandler)

    }
    
    @objc(didReceive:)
    public func didReceive(with userInfo: [AnyHashable: Any]) {
        
        Dengage.didReceive(with: userInfo)
        
    }
    
}
