# Dengage Flutter SDK — Comprehensive Integration Guide

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Adding the SDK](#2-adding-the-sdk)
3. [Dengage API endpoints](#3-dengage-api-endpoints)
4. [Android integration](#4-android-integration)
5. [iOS integration](#5-ios-integration)
6. [Rich and carousel push (Android & iOS)](#6-rich-and-carousel-push-android--ios)
7. [Flutter API reference](#7-flutter-api-reference)
8. [In-app inline and App Story](#8-in-app-inline-and-app-story)
9. [Inbox, deep links, and utilities](#9-inbox-deep-links-and-utilities)
10. [Example app and troubleshooting](#10-example-app-and-troubleshooting)

---

## 1. Prerequisites

- **Flutter** SDK (e.g. 3.x) and `flutter doctor` passing for Android and iOS.
- **Android**: Android Studio, NDK if needed, and a **Firebase** project with `google-services.json`.
- **iOS**: Xcode, CocoaPods, and **Apple Push Notification** credentials (certificate or key).
- **Dengage**: Integration keys (Firebase for Android, iOS integration key for iOS) from the Dengage dashboard.
- *(Optional)* **Huawei**: For Huawei devices, `agconnect-services.json` and HMS configuration.
- *(Optional)* **Geofence**: If using location-based campaigns, configure location permissions and geofence modules.

---

## 2. Adding the SDK

### 2.1 Pub dependency

In your app’s `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dengage_flutter: ^1.1.3   # use latest from pub.dev or git
```

Then run:

```bash
flutter pub get
```

### 2.2 Using a local path (development)

To iterate on the plugin locally:

```yaml
dependencies:
  dengage_flutter:
    path: ../dengage-flutter-sdk
```

---

## 3. Dengage API endpoints

The native Dengage SDK (Android and iOS) reads backend URLs from configuration. **Your backend team will provide the actual URL values** for each environment (e.g. dev, staging, production). You must add these **keys** in your app and set the **value** for each key to the URL given by the backend team.

### 3.1 Android keys (`AndroidManifest.xml` → `<meta-data>`)

Use these as `android:name` inside `<application>` under a `<meta-data>` tag. The `android:value` is the URL from the backend team.

| Key | Purpose |
|-----|---------|
| `den_event_api_url` | Event ingestion endpoint. All events (page view, cart, order, custom events) are sent here. |
| `den_push_api_url` | Push notification API. Used for token registration and push delivery. |
| `den_device_id_api_url` | Device identity endpoint. Used for contact/device registration and sync. |
| `den_in_app_api_url` | In-app message API. Used to fetch and display in-app campaigns. |
| `den_geofence_api_url` | Geofence API. Used when geofence module is enabled for location-based campaigns. |
| `fetch_real_time_in_app_api_url` | Real-time in-app API. Used when you call `showRealTimeInApp` to fetch an in-app message for the current screen. |

**Example (value is placeholder — get real value from backend):**

```xml
<meta-data android:name="den_event_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
<meta-data android:name="den_push_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
<meta-data android:name="den_device_id_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
<meta-data android:name="den_in_app_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
<meta-data android:name="den_geofence_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
<meta-data android:name="fetch_real_time_in_app_api_url" android:value="<BACKEND_TEAM_WILL_PROVIDE>" />
```

### 3.2 iOS keys (`Runner/Info.plist`)

Use these as the plist key; the value is a string (the URL from the backend team).

| Key | Purpose |
|-----|---------|
| `DengageEventApiUrl` | Event ingestion endpoint. |
| `DengageDeviceIdApiUrl` | Device identity endpoint. |
| `DengageApiUrl` | Push / main API base URL. |
| `DengageGeofenceApiUrl` | Geofence API URL (when using geofence). |
| `fetchRealTimeINAPPURL` | Real-time in-app API URL. |

**Example (value is placeholder — get real value from backend):**

```xml
<key>DengageEventApiUrl</key>
<string><BACKEND_TEAM_WILL_PROVIDE></string>
<key>DengageDeviceIdApiUrl</key>
<string><BACKEND_TEAM_WILL_PROVIDE></string>
<key>DengageApiUrl</key>
<string><BACKEND_TEAM_WILL_PROVIDE></string>
<key>DengageGeofenceApiUrl</key>
<string><BACKEND_TEAM_WILL_PROVIDE></string>
<key>fetchRealTimeINAPPURL</key>
<string><BACKEND_TEAM_WILL_PROVIDE></string>
```

- **Android**: Add each key as `<meta-data android:name="KEY" android:value="URL_FROM_BACKEND" />` in `AndroidManifest.xml` (see Section 4).
- **iOS**: Add each key and its string value in `Runner/Info.plist` (see Section 5).

---

## 4. Android integration

### 4.1 App-level `build.gradle` (application, not the plugin)

Path: `android/app/build.gradle`.

- Apply the **Google Services** plugin so Firebase is configured from `google-services.json`:

```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    id "com.google.gms.google-services"   // required for FCM
}
```

- Ensure **Dengage** and **Firebase** are available. The app (or the plugin) must depend on the Dengage Android SDK and FCM. In the **application** `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34
    // ...
    defaultConfig {
        applicationId "com.yourcompany.yourapp"
        minSdkVersion 21
        targetSdkVersion 34
        // ...
    }
    // ...
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22"
    implementation "com.google.android.material:material:1.11.0"
    implementation "com.google.firebase:firebase-core:21.1.1"
    implementation "com.google.firebase:firebase-messaging:23.4.0"
    implementation "com.google.firebase:firebase-analytics:21.5.0"
    implementation "com.github.dengage-tech.dengage-android-sdk:sdk:6.0.89"
    implementation "com.github.dengage-tech.dengage-android-sdk:sdk-hms:6.0.89"   // optional, for Huawei
}
```

- **Root-level** `android/build.gradle` (or `settings.gradle` plugin block) must have the **Google Services** classpath; with the new plugin DSL it is often in `settings.gradle`:

```gradle
plugins {
    id "com.android.application" version '8.5.0' apply false
    id "org.jetbrains.kotlin.android" version "1.9.22" apply false
    id "com.google.gms.google-services" version "4.4.0" apply false
}
```

- **Repositories**: ensure JitPack and Google are available (e.g. in root `build.gradle` or `settings.gradle`):

```gradle
repositories {
    google()
    mavenCentral()
    maven { url 'https://jitpack.io' }
    maven { url 'https://developer.huawei.com/repo/' }   // if using HMS
}
```

### 4.2 `AndroidManifest.xml`

Path: `android/app/src/main/AndroidManifest.xml`.

- **FCM service** (required for push):

```xml
<application ...>
    <!-- ... -->
    <service
        android:name="com.dengage.sdk.push.FcmMessagingService"
        android:exported="false">
        <intent-filter>
            <action android:name="com.google.firebase.MESSAGING_EVENT" />
        </intent-filter>
    </service>
</application>
```

- **Optional: Huawei messaging service** (uncomment if using HMS):

```xml
<!--
<service
    android:name="com.dengage.sdk.HmsMessagingService"
    android:exported="false">
    <intent-filter>
        <action android:name="com.huawei.push.action.MESSAGING_EVENT" />
    </intent-filter>
</service>
-->
```

- **Push and carousel receiver**: required for handling notification open/delete and **carousel item click**:

```xml
<receiver
    android:name=".push.PushNotificationReceiver"
    android:exported="false">
    <intent-filter>
        <action android:name="com.dengage.push.intent.RECEIVE" />
        <action android:name="com.dengage.push.intent.OPEN" />
        <action android:name="com.dengage.push.intent.DELETE" />
        <action android:name="com.dengage.push.intent.ACTION_CLICK" />
        <action android:name="com.dengage.push.intent.ITEM_CLICK" />
        <action android:name="com.dengage.push.intent.CAROUSEL_ITEM_CLICK" />
    </intent-filter>
</receiver>
```

Use your own package for `android:name` (e.g. `com.yourcompany.yourapp.push.PushNotificationReceiver`) and implement the class as in Section 6.

- **Dengage meta-data** (endpoints): Add one `<meta-data>` per key. The **value** for each key must be provided by your backend team (see Section 3.1 for the list of keys).

```xml
<meta-data android:name="den_event_api_url" android:value="<integration team will provide>" />
<meta-data android:name="den_push_api_url" android:value="<integration team will provide>" />
<meta-data android:name="den_device_id_api_url" android:value="<integration team will provide>" />
<meta-data android:name="den_in_app_api_url" android:value="<integration team will provide>" />
<meta-data android:name="den_geofence_api_url" android:value="<integration team will provide>" />
<meta-data android:name="fetch_real_time_in_app_api_url" android:value="<integration team will provide>" />
```

### 4.3 Native initialization in `MainActivity`

Initialize Dengage **before** the Flutter engine runs. Use `DengageCoordinator` from the plugin:

```kotlin
package com.yourcompany.yourapp

import android.os.Bundle
import com.example.dengage_flutter.DengageCoordinator
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DengageCoordinator.sharedInstance.setupDengage(
            true,                                    // logStatus
            "YOUR_FIREBASE_INTEGRATION_KEY",         // firebaseKey
            null,                                    // huaweiKey (or HMS key if using Huawei)
            false,                                   // restartApplication
            false,                                   // disableWebOpenUrl
            applicationContext
        )
    }
}
```

- **Huawei**: pass the Huawei integration key as the third argument and ensure `sdk-hms` is included and HMS is configured.
- **Geofence**: the plugin’s `android/build.gradle` can add `sdk-geofence` via a property; ensure your app has location permissions and endpoint meta-data.

### 4.4 Place `google-services.json`

Put your Firebase `google-services.json` in `android/app/`. Do not commit keys; use env or CI secrets for production.

---

## 5. iOS integration

### 5.1 Podfile — native Dengage and extensions

Path: `ios/Podfile`.

- Set a minimum iOS version (e.g. 13.0):

```ruby
platform :ios, '13.0'
```

- Add the **Dengage** pod (and optionally **DengageGeofence**) **inside** the `Runner` target, **before** `flutter_install_all_ios_pods`:

```ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  pod 'Dengage', :git => 'https://github.com/dengage-tech/dengage-ios-sdk.git', :tag => '5.90'
  pod 'DengageGeofence', :git => 'https://github.com/dengage-tech/dengage-ios-sdk.git', :tag => '5.90'   # optional

  target 'DengageNotificationServiceExtension' do
    use_frameworks!
    inherit! :search_paths
  end

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

- **DengageNotificationServiceExtension**: required for **rich notifications** (image/media and carousel). Create this target in Xcode (File → New → Target → Notification Service Extension), name it `DengageNotificationServiceExtension`, and add the `Dengage` dependency to it (or rely on search_paths from Runner). The extension’s only job is to call `Dengage.didReceiveNotificationRequest(_:withContentHandler:)` (see Section 6).

- **DengageContentExtension**: required for **carousel UI** on iOS. Create a **Notification Content Extension** target (e.g. `DengageContentExtension`), set its **NSExtensionMainStoryboard** to the storyboard that uses your carousel view controller (e.g. `DengageNotificationViewController`), and set **UNNotificationExtensionCategory** to the category ID you use for carousel (e.g. `DENGAGE_CAROUSEL_CATEGORY`). See Section 6.

Then:

```bash
cd ios && pod install && cd ..
```

### 5.2 Capabilities and Info.plist

- In Xcode, enable **Push Notifications** and **Background Modes → Remote notifications** for the **Runner** app.
- In `Runner/Info.plist` add the endpoint keys listed in Section 3.2. The **string value** for each key must be provided by your backend team.

```xml
<key>DengageEventApiUrl</key>
<string><integration team will provide></string>
<key>DengageDeviceIdApiUrl</key>
<string><integration team will provide></string>
<key>DengageApiUrl</key>
<string><integration team will provide></string>
<key>DengageGeofenceApiUrl</key>
<string><integration team will provide></string>
<key>fetchRealTimeINAPPURL</key>
<string><integration team will provide></string>
```

- For **geofence** and **location**, add the usual usage descriptions (e.g. `NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`). These are required by iOS when the app or the Dengage geofence module uses location.

### 5.3 AppDelegate — initialize Dengage and forward push

In `ios/Runner/AppDelegate.swift` (or `.m` if using Objective-C):

```swift
import UIKit
import Flutter
import dengage_flutter
import UserNotifications
import Dengage

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let coordinator = DengageCoordinator.staticInstance
        coordinator.setupDengage(
            key: "YOUR_IOS_INTEGRATION_KEY",
            launchOptions: launchOptions as NSDictionary?,
            application: application,
            askNotificationPermission: false,
            disableOpenURL: false,
            badgeCountReset: false
        )
        UNUserNotificationCenter.current().delegate = self
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let coordinator = DengageCoordinator.staticInstance
        coordinator.registerForPushToken(deviceToken: deviceToken)
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let coordinator = DengageCoordinator.staticInstance
        coordinator.didReceivePush(center, response, withCompletionHandler: completionHandler)
    }

    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .sound, .badge])
    }
}
```

- Replace `YOUR_IOS_INTEGRATION_KEY` with the key from the Dengage dashboard.
- The plugin’s `DengageCoordinator` calls `Dengage.setIntegrationKey`, `Dengage.initWithLaunchOptions`, and forwards token and notification response to the native SDK.

---

## 6. Rich and carousel push (Android & iOS)

This section describes how the Flutter SDK supports **rich push** (notifications with image/media) and **carousel push** (notifications with multiple swipeable items). Both require native code on Android and iOS; the Flutter example app in this repo includes full implementations.

### 6.1 Overview

- **Rich push**: A push notification that includes an image or other media attachment. On **iOS**, the system does not download attachments by default; you must use a **Notification Service Extension**. The extension receives the notification, calls the Dengage API so it can modify the content (e.g. download the image and attach it), then delivers the updated content. On **Android**, the Dengage SDK can show a big picture or rich layout when the payload contains media; FCM delivers the payload to `FcmMessagingService`, and the SDK handles the display.
- **Carousel push**: A push notification that shows multiple “items” (each with image, title, description, and optional link). The user can swipe left/right to see previous/next items and tap an item to open its link. On **Android**, you implement a custom **BroadcastReceiver** that extends Dengage’s `NotificationReceiver`, override `onCarouselRender`, and build a custom notification with `RemoteViews` (collapsed + expanded layout). On **iOS**, you add a **Notification Content Extension** that reads the carousel payload from `userInfo`, displays a `UICollectionView` (or similar), and handles tap and optional NEXT/PREVIOUS actions.

### 6.2 Android — carousel implementation

**Why this is needed:** When the backend sends a carousel push, the payload contains multiple items (each with image URL, title, description, target URL). The Dengage Android SDK does not render the carousel UI for you by default; it invokes your app’s `NotificationReceiver` with the carousel data. You must provide the UI (collapsed + expanded) and handle left/right navigation and item click.

1. **Receiver class**  
   Create a class that extends `com.dengage.sdk.push.NotificationReceiver` and override `onCarouselRender`. This method is called when a carousel notification is received. Register this class in `AndroidManifest.xml` as in Section 4.2, and include the action `com.dengage.push.intent.CAROUSEL_ITEM_CLICK` so item taps are delivered to your receiver.

2. **Layouts**  
   You need XML layouts for the notification:
   - **Collapsed state**: The small view shown in the notification shade (e.g. title, body text, small image). Typically named something like `den_carousel_collapsed.xml`.
   - **Expanded portrait**: The big view when the user expands the notification — usually three image slots (left, current, right), left/right arrow buttons, and the current item’s title and description. Typically `den_carousel_portrait.xml`.
   - *(Optional)* **Landscape**: A variant for horizontal/landscape layout if you want a different look when the device is in landscape; e.g. `den_carousel_landscape.xml`.

   All of these use standard Android views (TextView, ImageView, etc.) and are inflated into `RemoteViews`, because notification content is rendered in the system UI process.

3. **Implementation pattern**  
   Inside `onCarouselRender`, the SDK passes you:
   - `Message`: the main notification (title, body, etc.)
   - `leftCarouselItem`, `currentCarouselItem`, `rightCarouselItem`: three adjacent items from the carousel (type `com.dengage.sdk.domain.push.model.CarouselItem`). Each has image URL, title, description, target URL.

   The base class `NotificationReceiver` provides helper methods that return `PendingIntent`s for: item click, left arrow (previous), right arrow (next), content click, and delete. You create `RemoteViews` for the collapsed and expanded layouts, set the title/message and item title/description text, and assign the pending intents to the arrow buttons and the current item area. You then load the images asynchronously into the `RemoteViews` image views (the Dengage SDK provides a helper like `loadCarouselImageToView` that loads from URL and updates the `RemoteViews`). Finally you build the `Notification` with `setCustomContentView(collapsedView)` and `setCustomBigContentView(carouselView)`, and display it with `NotificationManagerCompat.notify(message.messageId, notification)` so the same notification is updated when the user swipes.

Example structure (package and layout names from the Flutter example):

```kotlin
class PushNotificationReceiver : NotificationReceiver() {
    override fun onCarouselRender(
        context: Context,
        intent: Intent,
        message: Message,
        leftCarouselItem: CarouselItem,
        currentCarouselItem: CarouselItem,
        rightCarouselItem: CarouselItem
    ) {
        super.onCarouselRender(...)
        val itemIntent = getItemClickIntent(intent.extras, context.packageName)
        val leftIntent = getLeftItemIntent(intent.extras, context.packageName)
        val rightIntent = getRightItemIntent(intent.extras, context.packageName)
        // Build RemoteViews for R.layout.den_carousel_collapsed and R.layout.den_carousel_portrait
        // Set title, message, item title/description; setOnClickPendingIntent for arrows and item
        // loadCarouselImageToView for left/current/right image views
        // NotificationCompat.Builder(...).setCustomContentView(collapsed).setCustomBigContentView(carouselView).build()
        // NotificationManagerCompat.from(context).notify(message.messageId, notification)
    }
}
```

4. **Resources**  
   Copy or adapt from the Flutter example app:
   - `android/app/src/main/res/layout/den_carousel_collapsed.xml`
   - `android/app/src/main/res/layout/den_carousel_portrait.xml`
   - `android/app/src/main/res/layout/den_carousel_landscape.xml` (optional)
   - `android/app/src/main/kotlin/.../push/PushNotificationReceiver.kt`

### 6.3 iOS — rich push (Notification Service Extension)

**Why this is needed:** On iOS, when a push payload contains a URL for an image or media, the system does not automatically download and attach it. You must add a **Notification Service Extension**. The extension runs in a separate process when a push arrives; it receives the `UNNotificationRequest`, can modify the `UNMutableNotificationContent` (e.g. download the image and add it as an attachment), and then call the content handler with the modified content. The Dengage iOS SDK provides an API that does this: it reads the payload, downloads the media, and attaches it to the content. You must call that API from your extension.

1. In Xcode, add a new target: **File → New → Target → Notification Service Extension**. Name it e.g. `DengageNotificationServiceExtension`.
2. In the extension’s `NotificationService.swift`, implement `didReceive(_:withContentHandler:)`. Inside it, get a mutable copy of the request’s content, then call Dengage so it can modify the content (download and attach media). After that, call the content handler with the (possibly modified) content so iOS displays the notification.

```swift
import UserNotifications
import Dengage

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent
        if let bestAttemptContent = bestAttemptContent {
            Dengage.didReceiveNotificationRequest(bestAttemptContent, withContentHandler: contentHandler)
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
```

3. The extension target must link against the Dengage framework. In the Podfile, add a target for the extension (e.g. `DengageNotificationServiceExtension`) with `inherit! :search_paths` so it uses the same pods as Runner (including `Dengage`). Run `pod install` so the extension can import and call Dengage.

### 6.4 iOS — carousel (Notification Content Extension)

**Why this is needed:** For carousel notifications on iOS, the payload contains an array of items (each with image URL, title, description, link). The default notification UI only shows title and body. To show a swipeable list of items, you add a **Notification Content Extension**. The extension gets the notification payload, parses the carousel items, and presents a custom UI (e.g. a horizontal collection view). The category of the notification (set by the backend) must match the extension’s `UNNotificationExtensionCategory` so iOS uses your extension for that category.

1. In Xcode, add a new target: **File → New → Target → Notification Content Extension**. Name it e.g. `DengageContentExtension`.
2. **Info.plist** for the extension:
   - `NSExtension` → `NSExtensionPointIdentifier`: must be `com.apple.usernotifications.content-extension`.
   - `NSExtensionMainStoryboard`: the storyboard that contains your carousel view controller (e.g. `MainInterface`).
   - Under `NSExtensionAttributes`, set `UNNotificationExtensionCategory` to the **category identifier** that the backend sends for carousel notifications (e.g. `DENGAGE_CAROUSEL_CATEGORY`). This must match exactly so iOS routes carousel pushes to this extension.
   - `UNNotificationExtensionDefaultContentHidden`: set to `true` if your custom UI replaces the default title/body; otherwise the system shows both.

3. **View controller**  
   Your view controller must conform to `UNNotificationContentExtension`. In `didReceive(_ notification: UNNotification)`:
   - Read the payload from `notification.request.content.userInfo`. The carousel items are typically under a key like `carouselContent` — an array of dictionaries.
   - Each dictionary has keys such as `mediaUrl`, `title`, `desc` (or `description`). Map these to a simple model (e.g. a struct or class with `image`, `title`, `description`).
   - Store the array and reload your UI (e.g. a `UICollectionView`) so each cell shows one carousel item.

4. **Cell**  
   Use a custom `UICollectionViewCell` (e.g. with a XIB: image view, title label, description label). In `cellForItemAt`, set the labels and load the image from the item’s `mediaUrl` asynchronously (e.g. `URLSession.dataTask`), then set the image on the image view on the main queue.

5. **Actions**  
   If the backend defines notification actions (e.g. “Next”, “Previous”), implement `didReceive(_ response: UNNotificationResponse, completionHandler:)`. For “Next”/“Previous”, scroll the collection view to the next/previous item and call `completionHandler(.doNotDismiss)`. When the user taps the notification itself or an action that should open the app/link, call `completionHandler(.dismissAndForwardAction)`.

6. **Storyboard**  
   In the extension’s main storyboard, set the root view controller to your carousel view controller and connect the collection view outlet so it loads correctly when the extension runs.

A full reference implementation is in this repo under `example/ios/DengageContentExtension/`: `DengageNotificationViewController.swift`, `CarouselNotificationCell.swift`, `DengageRecievedMessage.swift`, `MainInterface.storyboard`, and `Info.plist`.

---

## 7. Flutter API reference

Call these after the app (and native SDK) are ready. Prefer calling from a `State` after `initState` or after `WidgetsBinding.instance.addPostFrameCallback`, so that native init has run.

### 7.1 Identity and device

| Method | Description |
|--------|-------------|
| `DengageFlutter.setContactKey(String? contactKey)` | Bind device to your user/customer ID. |
| `DengageFlutter.getContactKey()` | Returns current contact key. |
| `DengageFlutter.setIntegerationKey(String key)` | iOS only: set integration key from Dart. |
| `DengageFlutter.setFirebaseIntegrationKey(String key)` | Android only: set Firebase integration key. |
| `DengageFlutter.setHuaweiIntegrationKey(String key)` | Android only: set Huawei integration key. |
| `DengageFlutter.setPartnerDeviceId(String adid)` | Sync partner device ID (e.g. advertising ID). |
| `DengageFlutter.setLogStatus(bool isVisible)` | Enable/disable SDK logging. |

### 7.2 Push and permissions

| Method | Description |
|--------|-------------|
| `DengageFlutter.getToken()` | Get FCM/APNs token. |
| `DengageFlutter.setToken(String token)` | Manually set token. |
| `DengageFlutter.promptForPushNotifications()` | iOS: show system permission dialog. |
| `DengageFlutter.promptForPushNotificationsWithPromise()` | Returns `bool?` (granted/denied on iOS). |
| `DengageFlutter.setUserPermission(bool hasPermission)` | Set opt-in state. |
| `DengageFlutter.getUserPermission()` | Android: get current permission. |
| `DengageFlutter.registerForRemoteNotifications(bool enabled)` | iOS only. |
| `DengageFlutter.getLastPushPayload()` | Last received push payload. |

### 7.3 Commerce and events

| Method | Description |
|--------|-------------|
| `DengageFlutter.pageView(Object data)` | Page view event (e.g. `{ "screenName": "home" }`). |
| `DengageFlutter.addToCart(Object data)` | Add to cart. |
| `DengageFlutter.removeFromCart(Object data)` | Remove from cart. |
| `DengageFlutter.viewCart(Object data)` | View cart. |
| `DengageFlutter.beginCheckout(Object data)` | Begin checkout. |
| `DengageFlutter.placeOrder(Object data)` | Place order. |
| `DengageFlutter.cancelOrder(Object data)` | Cancel order. |
| `DengageFlutter.addToWishList(Object data)` | Add to wishlist. |
| `DengageFlutter.removeFromWishList(Object data)` | Remove from wishlist. |
| `DengageFlutter.search(Object data)` | Search event. |
| `DengageFlutter.sendDeviceEvent(String tableName, Object data)` | Custom event to a Dengage table. |
| `DengageFlutter.setTags(List<Object> tags)` | Attach tags to the device. |

### 7.4 Navigation and real-time in-app

| Method | Description |
|--------|-------------|
| `DengageFlutter.setNavigation()` | Notify current screen (default). |
| `DengageFlutter.setNavigationWithName(String screenName)` | Set screen for targeting. |
| `DengageFlutter.setCity(String city)` | Set city context. |
| `DengageFlutter.setState(String state)` | Set state context. |
| `DengageFlutter.setCartAmount(String amount)` | Cart total for RTS. |
| `DengageFlutter.setCartItemCount(String count)` | Cart item count for RTS. |
| `DengageFlutter.setCategoryPath(String path)` | Category path. |
| `DengageFlutter.showRealTimeInApp(String screenName, Object data)` | Request real-time in-app for the screen. |

### 7.5 Inbox

| Method | Description |
|--------|-------------|
| `DengageFlutter.getInboxMessages(int offset, int limit)` | Paginated inbox messages. |
| `DengageFlutter.deleteInboxMessage(String id)` | Delete one message. |
| `DengageFlutter.setInboxMessageAsClicked(String id)` | Mark as clicked/read. |

### 7.6 Configuration and geofence

| Method | Description |
|--------|-------------|
| `DengageFlutter.setInAppLinkConfiguration(String deepLink)` | Override in-app link handling. |
| `DengageFlutter.requestLocationPermissions()` | Request location (e.g. for geofence). |
| `DengageFlutter.startGeofence()` | Start geofence. |
| `DengageFlutter.stopGeofence()` | Stop geofence. |

### 7.7 Subscription (Android)

| Method | Description |
|--------|-------------|
| `DengageFlutter.getSubscription()` | Raw subscription metadata (integration key, tokens, device IDs). |

---

## 8. In-app inline and App Story

### 8.1 In-app inline

Use the **InAppInline** widget where you want a native inline in-app block (e.g. banner or slot). It embeds the native view via platform view.

```dart
import 'package:dengage_flutter/dengage_flutter.dart';

InAppInline(
  propertyId: '1',
  screenName: 'home-inline',
  customParams: HashMap<String, String>(),
  hideIfNotFound: false,
)
```

- Call `setNavigationWithName(screenName)` before showing the widget so targeting matches.
- Give the widget a bounded height (e.g. `SizedBox(height: 244, child: InAppInline(...))`).

### 8.2 App Story

Use the **AppStoryView** widget to show the native stories list. The widget embeds the native Dengage story view (a horizontal list of story items that the user can tap and swipe through). The content and targeting are configured in the Dengage dashboard (Content > Marketing > In-App, Story template); you only need to pass the same `propertyId` and `screenName` that you configured there.

```dart
import 'package:dengage_flutter/dengage_flutter.dart';

AppStoryView(
  propertyId: '4',
  screenName: 'appstory',
  customParams: HashMap<String, String>(),
)
```

- Configure property and screen names in the Dengage dashboard (Content > Marketing > In-App, Story template).
- Give it a fixed height (e.g. 320) so the list lays out correctly.

---

## 9. Inbox, deep links, and utilities

- **Inbox**: When the backend sends messages with “Save to Inbox” enabled, they are stored locally. Use `getInboxMessages(offset, limit)` to fetch a page of messages (each has id, title, message, receiveDate, isClicked, etc.). Use `deleteInboxMessage(id)` to remove one message and `setInboxMessageAsClicked(id)` to mark it as read/clicked. You can build a simple inbox screen that lists these and handles delete/click.
- **Deep links**: When the user taps a link inside an in-app message or a push notification, the Dengage SDK can open a URL (in-app browser or external). If you want to handle certain URLs inside your app (e.g. open a specific screen), set `setInAppLinkConfiguration(deepLink)` to your app’s URL scheme or universal link host. The plugin also exposes an event channel (e.g. `com.dengage.flutter/inAppLinkRetrieval`) so you can listen in Dart for link callbacks when the user taps a link — check the plugin source for the exact channel name and payload format.
- **Notification click**: When the user taps a notification, the native SDK handles it (e.g. open app, track click). If you need to react in Flutter (e.g. navigate to a screen), listen on the plugin’s notification event channel (e.g. `com.dengage.flutter/onNotificationClicked`). The plugin streams the payload or notification data when a notification is opened; see the plugin’s iOS/Android implementation for the exact event name and data shape.

---

## 10. Example app and troubleshooting

### 10.1 Running the example

```bash
cd dengage-flutter-sdk/example
flutter pub get
# Android: place google-services.json in example/android/app/
# iOS: cd ios && pod install && cd ..
flutter run
```

Replace integration keys in:
- `example/android/app/src/main/kotlin/.../MainActivity.kt` (Firebase key, optional Huawei key).
- `example/ios/Runner/AppDelegate.swift` (iOS integration key).

### 10.2 Troubleshooting

| Issue | Check |
|-------|------|
| Push not received (Android) | `google-services.json` in `android/app/`, FCM service in manifest, Firebase key in Dengage dashboard and in `setupDengage`. |
| Push not received (iOS) | Capabilities: Push Notifications + Remote notifications; APNs key/cert in Dengage; `registerForPushToken` in AppDelegate; correct integration key. |
| In-app not showing | `setNavigationWithName(screenName)` called; screen name matches campaign targeting; endpoint meta-data/Info.plist correct. |
| Carousel not showing (Android) | Receiver registered with `CAROUSEL_ITEM_CLICK`; `onCarouselRender` implemented; layouts and notification channel created. |
| Rich/carousel not showing (iOS) | Service Extension calls `Dengage.didReceiveNotificationRequest`; Content Extension category matches payload; storyboard and view controller wired. |
| Build errors (iOS) | `pod install`; minimum iOS version in Podfile; Dengage pod version matches what the plugin expects. |
| Build errors (Android) | Repositories (JitPack, Google); Dengage SDK version; minSdk 21; Java 17 if required. |

### 10.3 Example project structure (reference)

```
example/
├── lib/
│   ├── main.dart
│   └── screens/
│       ├── home_screen.dart
│       ├── notification_screen.dart
│       ├── device_info_screen.dart
│       ├── contact_key_screen.dart
│       ├── inbox_messages_screen.dart
│       ├── in_app_message_screen.dart
│       ├── rt_in_app_messages_screen.dart
│       ├── real_time_in_app_filters_screen.dart
│       ├── event_history_screen.dart
│       ├── cart_screen.dart
│       ├── geofence_screen.dart
│       ├── in_app_inline_screen.dart
│       └── app_story_screen.dart
├── android/
│   ├── app/
│   │   ├── build.gradle          # App deps: Firebase, Dengage, google-services
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   ├── kotlin/.../MainActivity.kt
│   │   │   ├── kotlin/.../push/PushNotificationReceiver.kt
│   │   │   └── res/layout/
│   │   │       ├── den_carousel_collapsed.xml
│   │   │       ├── den_carousel_portrait.xml
│   │   │       └── den_carousel_landscape.xml
├── ios/
│   ├── Podfile                   # Dengage + DengageGeofence pods; extension targets
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   └── Info.plist
│   ├── DengageNotificationServiceExtension/
│   │   └── NotificationService.swift
│   └── DengageContentExtension/
│       ├── Info.plist
│       ├── MainInterface.storyboard
│       ├── DengageNotificationViewController.swift
│       ├── CarouselNotificationCell.swift
│       ├── CarouselNotificationCell.xib
│       └── DengageRecievedMessage.swift
```

---

## Resources

- Flutter SDK: [https://github.com/dengage-tech/dengage-flutter-sdk](https://github.com/dengage-tech/dengage-flutter-sdk)
- Android SDK: [https://github.com/dengage-tech/dengage-android-sdk](https://github.com/dengage-tech/dengage-android-sdk)
- iOS SDK: [https://github.com/dengage-tech/dengage-ios-sdk](https://github.com/dengage-tech/dengage-ios-sdk)

---


