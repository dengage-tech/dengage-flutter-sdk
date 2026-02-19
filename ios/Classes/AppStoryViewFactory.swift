import Foundation
import Flutter
import UIKit

class AppStoryViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        print("[DengageFlutter/AppStory] Factory.create: id=\(viewId), args=\(String(describing: args))")
        return AppStoryView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args
        )
    }

    public func createArgsCodec() -> (any FlutterMessageCodec & NSObjectProtocol) {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
