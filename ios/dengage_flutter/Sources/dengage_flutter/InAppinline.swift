import Foundation
import Flutter
import UIKit
import Dengage
class InAppinline: NSObject, FlutterPlatformView {
    private var _nativeWebView: InAppInlineElementView
    
    func view() -> UIView {
        return _nativeWebView
    }
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) {
        _nativeWebView = InAppInlineElementView()
            
        super.init()
        if let data = args as? [String:Any]{
            
                if let propertyId = data["propertyId"] as? String{
                let customParams = data["customParams"] as? Dictionary<String,String>
                let screenName = data["screenName"] as? String?
                let hideIfNotFound = data["hideIfNotFound"] as? Bool?
                
                Dengage.showInAppInLine(propertyID: propertyId, inAppInlineElement: _nativeWebView, screenName: screenName ?? nil, customParams: customParams, hideIfNotFound: (hideIfNotFound ?? false) ?? false)
            }
            
            
        }
        else {
            
            
        }
        
      
        

    }


    
    
}
