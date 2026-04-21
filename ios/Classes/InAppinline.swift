import Flutter
import UIKit
import Dengage

class InAppinline: NSObject, FlutterPlatformView {
    private let nativeWebView: InAppInlineElementView
    private let channel: FlutterMethodChannel
    private var lastReportedHidden: Bool?
    private var hiddenSinceUptime: TimeInterval?
    private var pollTimer: Timer?
    private let hiddenDebounceSec: TimeInterval = 0 // 600

    func view() -> UIView { nativeWebView }

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        messenger: FlutterBinaryMessenger
    ) {
        nativeWebView = InAppInlineElementView()
        channel = FlutterMethodChannel(
            name: "plugins.dengage/inappinline_\(viewId)",
            binaryMessenger: messenger
        )
        super.init()

        if let data = args as? [String: Any],
           let propertyId = data["propertyId"] as? String {
            let customParams = data["customParams"] as? [String: String]
            let screenName = data["screenName"] as? String
            let hideIfNotFound = data["hideIfNotFound"] as? Bool
            Dengage.showInAppInLine(
                propertyID: propertyId,
                inAppInlineElement: nativeWebView,
                screenName: screenName,
                customParams: customParams,
                hideIfNotFound: (hideIfNotFound ?? false)
            )
        }

        startVisibilityPolling()
    }

    private func startVisibilityPolling() {
        pollTimer?.invalidate() // withTimeInterval: 0.25
        pollTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self else { return }

            let rawHidden = self.nativeWebView.isHidden
            let now = ProcessInfo.processInfo.systemUptime
            let debouncedHidden: Bool
            if rawHidden {
                if self.hiddenSinceUptime == nil { self.hiddenSinceUptime = now }
                debouncedHidden = (now - (self.hiddenSinceUptime ?? now)) >= self.hiddenDebounceSec
            } else {
                self.hiddenSinceUptime = nil
                debouncedHidden = false
            }

            if self.lastReportedHidden == nil || self.lastReportedHidden != debouncedHidden {
                self.lastReportedHidden = debouncedHidden
                self.channel.invokeMethod("onVisibilityChanged", arguments: ["isHidden": debouncedHidden])
            }
        }
    }

    deinit {
        pollTimer?.invalidate()
    }
}