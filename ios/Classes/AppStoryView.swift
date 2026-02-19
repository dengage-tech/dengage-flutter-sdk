import Foundation
import Flutter
import UIKit
import Dengage

class AppStoryView: NSObject, FlutterPlatformView {
    private var _containerView: UIView

    func view() -> UIView {
        return _containerView
    }

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) {
        _containerView = UIView(frame: frame)
        _containerView.backgroundColor = .clear
        super.init()

        guard let data = args as? [String: Any] else {
            print("[DengageFlutter/AppStory] init: args nil or not a dictionary")
            return
        }
        guard let propertyId = data["propertyId"] as? String, !propertyId.isEmpty else {
            print("[DengageFlutter/AppStory] init: propertyId missing or empty, skipping showAppStory")
            return
        }
        let customParams = data["customParams"] as? [String: String]
        let screenName = data["screenName"] as? String
        print("[DengageFlutter/AppStory] init: propertyId=\(propertyId), screenName=\(screenName ?? "nil"), thread=\(Thread.isMainThread ? "main" : "background")")

        // Run on main thread like Android's runOnUiThread (Cordova/RN do the same)
        let block = { [weak self] in
            guard let self = self else { return }
            print("[DengageFlutter/AppStory] calling Dengage.showAppStory(propertyId=\(propertyId), screenName=\(screenName ?? "nil"))")
            Dengage.showAppStory(
                storyPropertyID: propertyId,
                inAppInlineElement: nil,
                screenName: screenName,
                customParams: customParams,
                hideIfNotFound: false
            ) { [weak self] storiesListView in
                if storiesListView == nil {
                    print("[DengageFlutter/AppStory] storyCompletion called with nil (no matching story or SDK blocked)")
                }
                guard let self = self, let storiesListView = storiesListView else { return }
                let container = self._containerView
                DispatchQueue.main.async {
                    let storyView = storiesListView as UIView
                    storyView.translatesAutoresizingMaskIntoConstraints = false
                    container.addSubview(storyView)
                    NSLayoutConstraint.activate([
                        storyView.topAnchor.constraint(equalTo: container.topAnchor),
                        storyView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                        storyView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                        storyView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
                    ])
                    print("[DengageFlutter/AppStory] story view added to container")
                }
            }
        }
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
