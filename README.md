# dengage_flutter

**D·engage Customer Driven Marketing Platform (CDMP)** serves as a customer data platform (CDP) with built-in omnichannel marketing features. It replaces your marketing automation and cross-channel campaign management.
For further details about D·engage please [visit here](https://dev.dengage.com).

This package makes it easy to integrate, D·engage, with your React-Native iOS and/or Android apps. Following are instructions for installation of react-native-dengage SDK to your react-native applications.

#### Quick Video Guide 
Here is a quick video guide on how to install dengage_flutter SDK to your flutter application using this documentation. 
Guide consists of 2 parts please watch both in sequence.

[Part 1] (https://youtu.be/YP1WZdn7rgE)
[Part 2] (https://youtu.be/SMmAtPCtZUY)


## Installation

a) Edit your project's `pubspec.yaml` file to include the `dengage_flutter` SDK:

```sh

dependencies:
    dengage_flutter: ^0.0.8
    
```

b) Run `flutter pub get` to install the SDK.

c)  In your Dart code, access DengageFlutter with:

```
// at top in imports
import 'package:dengage_flutter/dengage_flutter.dart'

// somewhere down in the code
  try {
    Object result = await DengageFlutter.setIntegerationKey("");
    print("result: $result");
  } on PlatformException catch (error) {
    print("error: $error");
  } on Exception catch (error) {
    print("exception: $error");
  }
```

## Platform Specific Extra Steps
Following extra steps after the installation of the `dengage_flutter` SDK are required for it to work properly.

<details>
  <summary> iOS Specific Extra steps </summary>
  
  #### Requirements
  - D·engage Integration Key
  - iOS Push Cerificate
  - iOS Device (you need to test on a real device for notifications)
  - A mac with latest Xcode

  ### Steps
  
  #### 1. Endpoint Configuration in PInfo.list
  For initial setup, if you have given URL addresses by D·engage Support team, you need to setup url address by using ```Info.plist``` file. Otherwise you don’t need to add anything to ```Info.plist``` file. Following screenshot for the keys in ```Info.plist``` file.
  
  ![Info.plist screenshot](https://raw.githubusercontent.com/whitehorse-technology/Dengage.Framework/master/docs/img/Screen%20Shot%202020-09-25%20at%2015.41.27.png)

> Note: Please see API Endpoints by Datacenter documentation in this section for end points. [here is link](https://dev.dengage.com/mobile-sdk/api-endpoints)

  #### 2. Add Required Capabilities
  In Xcode, select the root project and main app target. In ***Signing & Capabilities***, select ***All*** and ***+ Capability***. Add "Push Notifications" and ***Background Modes***. Kindly make sure to tick ***Remote Notifications*** in Background Modes.
  <summary> screenshot 1 </summary>

  ![push notifications](https://files.readme.io/17798af-dengage_push_Step1.png)
  
  <summary> screenshot 2 </summary>
  
  ![background modes](https://files.readme.io/badc90e-dengage_push_step2.png)

  #### 3. Add Notification Service Extension (required only if using rich notifications)
  The ```DengageNotificationServiceExtension``` allows your application to receive rich notifications with images and/or buttons, and to report analytics about which notifications users receive.
  3.1 In Xcode Select ```File``` > ```New``` > ```Target```
  3.2 Select ```Notification Service Extension``` then press ```Next```
  
  ![step 3.2 screenshot](https://github.com/whitehorse-technology/Dengage.Framework/raw/master/docs/img/extension.png)
  
  3.3 Enter the product name as ```DengageNotificationServiceExtension``` and press ```Finish```.
  
  > Do NOT press "Activate" on the dialog shown after this.
  
  ![step 3.3 screenshot](https://github.com/whitehorse-technology/Dengage.Framework/raw/master/docs/img/settings.png)
  
  3.4 Press ```Cancel``` on the Activate scheme prompt.
  
  ![step 3.4 screenshot](https://github.com/whitehorse-technology/Dengage.Framework/raw/master/docs/img/activate.png)

  > By canceling, you are keeping Xcode debugging your app, instead of just the extension. If you activate by accident, you can always switch back to debug your app within Xcode (next to the play button).
  
  3.5 In the ***Project Navigator***, select the top-level project directory and select the ```DengageNotificationServiceExtension``` target in the ***project and targets list***. Ensure the ```Deployment Target``` is set to ```iOS 10``` for maximum platform compatibility.
  
  ![step 3_5 screenshot](https://files.readme.io/c834169-step3_5_iOS_version.png)

  3.6 Finish Notification Service Extension Setup
  
  If you did not use ***Cocoapods***, follow [these steps](google.com).
  
  > Note: non-cocoapods steps yet to be determined.
  
  Otherwise, continue with the following setup:
  - In your ```Project Root``` > ```iOS``` > ```Podfile```, add the notification service extension outside the main target (should be at the same level as your main target):
  
  ```Ruby
    target 'DengageNotificationServiceExtension' do
      pod 'Dengage.Framework',‘~> 3.0.6’
    end
  ```
  
  Close Xcode. While still in the ```ios``` directory, run ```pod install``` again.
  
  - Open the ```.xcworkspace``` file in Xcode. In the ```DengageNotificationServiceExtension directory``` > ```NotificationService.swift``` file, replace the whole file contents with the code below:
  
  ```Swift
      override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
         
        if let bestAttemptContent = bestAttemptContent {
            
            // add this line of code
            Dengage.didReceiveNotificationExtentionRequest(receivedRequest: request, with: bestAttemptContent)
            contentHandler(bestAttemptContent)
        }
    }
  ```
  > Ignore any build errors at this point, we will resolve these later by importing the D·engage library.
  
  ![NotificationService.swift screenshot](https://files.readme.io/56a0fd9-3_6_NotificationService_screenshot.png)

  ### 4. Setup Dengage SDK (it include two steps of the iOS native SDK. 1. Setting Integration Key  2. Initialization with Launch Options)
  ***Integration Key*** is genereted by CDMP Platform while defining application. It is a hash string which contains information about application.
  At the beginning of your application cycle you must set Integration Key and right after initialize sdk with launch options.
  Following sample shows how to do that in your `AppDelegate.swift` file:

***Sample:***
In the ```AppDelegate.swift```
```
import UIKit
import Flutter
import dengage_flutter          // ADD THIS IN IMPORTS

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    /************* FLutter Setup Code Starts here ********************/
    // please Node key here is the integeration Key received while registering your iOS Application on Dengage Dashboard.
    let coordinator = DengageCoordinator.staticInstance;
    coordinator.setupDengage(key: "K8sbLq1mShD52Hu2ZoHyb3tvDE_s_l_h99xFTF60WiNPdHhJtvmOqekutthtzRIPiMTbAa3y_p_l_PZqpon8nanH8YnJ8yYKocDb4GCAp7kOsi5qv7mDR_p_l_qOFLLp9_p_l_lloC6ds97X", launchOptions: launchOptions as NSDictionary?);
     /************* FLutter Setup Code Ends here ********************/
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    override func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let coordinator = DengageCoordinator.staticInstance;
            coordinator.registerForPushToken(deviceToken:deviceToken)
    }
}

```
  
  ### 5. Register for remote notification with device token
  To register for remote notifications with device token, add following method and code inside your `AppDelegate.swift` file:
  ```
import UIKit
import Flutter
import dengage_flutter          // ADD THIS IN IMPORTS

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // ... other things here ...
    
    /**************** Here this method override *****************/
    override func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let coordinator = DengageCoordinator.staticInstance;
            coordinator.registerForPushToken(deviceToken:deviceToken)
    }
}
  ```
</details>

<details>
  <summary> android Specific Extra Steps </summary>
  
  ### Firebase SDK Setup (Follow these steps only if you're using firebase for push, for Huawei [follow these steps](#huawei-sdk-setup))<a name="firebase-sdk-setup" />
  
  #### Requirements
  - Google Firebase App Configuration
  - Android Studio
  - Android Device or Emulator
  
  D·engage Android SDK provides an interface which handles push notification messages easily. Optionally, It also gives to send event functionality such as open and subscription to dEngage Platform.

  Supports Android API level 4.1.x or higher.

  For detailed steps for firebase SDK setup and it's integeration with D·engage, [click here](https://dev.dengage.com/mobile-sdk/android/firebase)
  
  ### Huawei SDK Setup (Note: use these steps only if you're using HUAWEI Messaging Service for push, if using firebase, [follow these steps](#firebase-sdk-setup))<a name="huawei-sdk-setup" />
  
  #### Requirements
  
  - Huawei Developer Account
  - Java JDK installation package
  - Android SDK package
  - Android Studio 3.X
  - HMS Core (APK) 4.X or later
  - Huawei Device or Huawei Cloud Debugging

  Supports Android API level 4.4 or higher. (Note that Huawei AdID service requires min target SDK version 19)
  
  **D·engage Huawei SDK** provides an interface which handles push notification messages that delivered by `Huawei Messaging Service (HMS)`. It is similar to Firebase but has a bit different configuration process that contains [steps mentioned here.](https://dev.dengage.com/mobile-sdk/android/huawei)
  
  ### Create DengageManager instance
  
  First, you need to create DengageManager instance in your main or launcher activity.
  
  ```Java
    // import statement
    import com.example.dengage_flutter.DengageCoordinator;
    
    // ...
    @Override
    protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      // Following line need to be added
      DengageCoordinator.sharedInstance.setupDengage(
                true,
                "FEYl27JxJfay6TxiYCdlkP2FXeuhNfEoI8WkxI_p_l__s_l_5sLbzKmc9c88mSZxRCrLuqMK4y0e8nHajQnBt8poBNDMvNtIytYKZ6byBQZOE8kqkkgDnlye2Lb5AcW3tuIWQjYz",
                "your-huawei-key-here",
                applicationContext
        )    
    }
  ```
  
  After these steps, You will be able to send a push notification message to your app.
  
  ### Change Subscription Api Endpoint
  You can change subscription api endpoint by adding following metadata tag in `YourProject/android/src/main/AndroidManifest.xml` 
  
```
        // for prod
        <meta-data
            android:name="den_push_api_url"
            android:value="https://push.dengage.com" />

        // for dev
        <!--    android:value="https://pushdev.dengage.com" />-->  
```
  
  Note: Please see API Endpoints By Datacenter to set your subscription end point.
  
  ### Changing Event Api Endpoint
  similar to subscription endpoints, you can change event api endpoints by setting following metadata tag in `YourProject/android/src/main/AndroidManifest.xml` 
  ```
        // for prod
        <meta-data
            android:name="den_event_api_url"
            android:value="https://event.dengage.com" />
        
        // for dev
        <!--      android:value="https://eventdev.dengage.com" />-->
  ```
  
  Note: Please see API Endpoints By Datacenter to set your event end point.

  Now you can setContactKey like mentioned [here](#setting-contact-key)
</details>

## Supported Versions 

<details>
  <summary> iOS </summary>
  
  D·engage Mobile SDK for IOS supports version IOS 10 and later.
</details>

<details>
  <summary> android </summary>
  
  D·engage Mobile SDK for Android supports version 4.4 (API Level 19) and later.

  <summary> Huawei </summary>
  
  D·engage Mobile SDK for Huawei supports all new versions.
</details>


## Usage

### Subscription
****Subscription is a process which is triggered by sending subscription event to D·engage. It contains necessary informations about application to send push notifications to clients.****

Subscriptions are self managed by D·engage SDK and subcription cycle starts with Prompting user permission. SDK will automaticlly send subscription events under following circumstances:

- Initialization
- Setting Contact key
- Setting Token
- Setting User Permission (if you have manual management of permission)

### Asking User Permission for Notification
> Note: Android doesn't require to ask for push notifications explicitly. Therefore, you can only ask for push notification's permissions on iOS.

IOS uses shared `UNUserNotificationCenter` by itself while asking user to send notification. D·engage SDK manager uses `UNUserNotificationCenter` to ask permission as well. [Apple Doc Reference](https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications)

If in your application, you want to get UserNotification permissions explicitly, you can do by calling one of the following methods:

```Javascript
// At the top import
import 'package:dengage_flutter/dengage_flutter.dart';

// somewhere in your javascript/typescript code
DengageFlutter.promptForPushNotifications()
```

OR

```Javascript
// At the top import
import 'package:dengage_flutter/dengage_flutter.dart';

// somewhere in your javascript/typescript code
Object result = await DengageFlutter.promptForPushNotificationsWitCallback()
```

### Setting Contact Key
***Contact Key represents user id in your system. There are two types of devices. Anonymous Devices and Contact Devices. Contact Devices contains Contact Key.***

To track devices by their contacts you need to set contact key on SDK.

> Note: It is recommended to call this method, if you have user information. You should call in every app open and on login, logout pages.

```
// import statement
import 'package:dengage_flutter/dengage_flutter.dart';

// in js/ts code
Object result = await DengageFlutter.setContactKey(userId: String)


// You may need getting current contact key from SDK. In that case you can use getContactKey
Object result = await DengageFlutter.getContactKey()
```


### Manual Management of Tokens

If you need to get current token or if you are managing token subscription process manually, you can use setToken and getToken functions.

```Javascript
// At the top import
import 'package:dengage_flutter/dengage_flutter.dart';

// somewhere in your javascript/typescript code
Object result = await DengageFlutter.getToken()

// setting the token that is taken manually
DengageFlutter.setToken(token)
```


### User Permission Management (optional)
If you manage your own user permission states on your application you may send user permission by using `setUserPermission` method.
```Javascript
// At the top import
import 'package:dengage_flutter/dengage_flutter.dart';

// somewhere in your javascript/typescript code
DengageFlutter.setUserPermission(true)

// For getting last permission set by user
Object result = await DengageFlutter.getUserPermission(true)
```

### Logging
SDK can provide logs for debuging. It displays queries and payloads which are sent to REST API’s.

To validate your inputs you can enable SDK’s log by a method.

```
// isVisible is Boolean. By default isVisible set to false.
DengageFlutter.setLogStatus(isVisible)
```

### Handling Notification Action using onNotificationClicked event
SDK provides a listener if you want to get and parse payload manually, whenever a push notification is clicked.

```
// declare as class level static variable
  static const EventChannel eventChannel = EventChannel("com.dengage.flutter/onNotificationClicked");

  @override
  void initState() {
    // rest of code here ...

    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    super.initState();
  }

  void _onEvent(Object event) {
    print("in on Event object is: ");
    print(event);
  }

  void _onError(Object error) {
    print("in on Error Object is: ");
    print(error);
  }

```

### DeepLinking
SDK supports URL schema deeplink. If target url has a valid link, it will redirect to the related link.
Please see related links below about deeplinking.
<details>
  <summary> iOS Specific Links </summary>
  
  
   [Apple Url Scheme Links](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app)
  
   [Apple Universal Link](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content)
</details>

<details>
  <summary> android Specific Links </summary>
  
  
   [Create a deep link for a destination](https://developer.android.com/guide/navigation/navigation-deep-link)

   [Create Deep Links to App Content](https://developer.android.com/training/app-links/deep-linking)
</details>

### Rich Notifications <a name="rich_push" />
Rich Notifications is a notification type which supports image, gif, video content. D·engage SDK supports varieties of contents and handles notification.
Rich Notifications supports following media types:
- Image
- Video
- Gif

For further details about rich notification and its setup on iOS side please follow [this link](https://dev.dengage.com/mobile-sdk/ios/richnotification)

> Note: on Android there is no special setup required for rich notifications.

### Carousel Push <a name="carousel_push" />
Carousel Push is a notification type which has a different UI than Rich Notification. SDK will handle notification payload and displays UI if it’s a carousel push. Carousel Push functionality allows you to show your notification with a slideshow.

<details>
  <summary> iOS </summary>
  
  ### Requirements
  - iOS 10 or higher
  - Notification Service Extension
  - Notification Content Extension
  - Dengage.Framework.Extensions

  to setup Carousel Push on iOS you can follow [this link](https://dev.dengage.com/mobile-sdk/ios/carousel-push)
</details>

<details>
  <summary> android </summary>
  
  ### Requirements
  - Android SDK 2.0.0+
  
  to setup Carousel Push on android you can follow [this link](https://dev.dengage.com/mobile-sdk/android/carousel-push)
</details>

### Action Buttons <a name="action_buttons" />
Android SDK allows you to put clickable buttons under the notification. Action buttons are supported in Android SDK 2.0.0+.
For further setup of Action Buttons, follow [this link](https://dev.dengage.com/mobile-sdk/android/action-buttons).

### Event Collection <a name="event_collection" />
In order to collect android mobile events and use that data to create behavioral segments in D·engage you have to determine the type of events and data that needs to collected. Once you have determined that, you will need to create a “Big Data” table in D·engage. Collected events will be stored in this table. Multiple tables can be defined depending on your specific need.

Any type of event can be collected. The content and the structure of the events are completely flexible and can be changed according to unique business requirements. You will just need to define a table for events.

Once defined, all you have to do is to send the event data to these tables. D·engage SDK has only two functions for sending events: `sendDeviceEvent` and `sendCustomEvent`. Most of the time you will just need the `sendDeviceEvent` function.

### 1. Login / Logout Action
If the user loggs in or you have user information, this means you have contact_key for that user. You can set contact_key in order to match user with the browser. There are two functions for getting and setting contact_key.

### 1.a setContactKey
If user logged in set user id. This is important for identifying your users. You can put this function call in every page. It will not send unnecessary events.
[code example is here](#setting-contact-key)

### 1.b getContactKey
to get the current user information from SDK getContactKey method can be used.
```Dart
// in imports
import 'package:dengage_flutter/dengage_flutter.dart';

// in the code, where user information required
Object result = await DengageFlutter.getContactKey()
```

### 2. Event Collection
If your D·engage account is an ecommerce account, you should use standard ecommerce events in the SDK. If you need some custom events or your account is not standard ecommerce account, you should use custom event functions.

### 2.1 Events for Ecommerce Accounts
There are standard ecommerce events in D·engage SDK.

- [**Page View Events**](#page-view-events-details)
  - Home page view
  - Product page view
  - Category page view
  - Promotion page view
  
- [**Shopping Cart Events**](#shopping-cart-events)
  - Add to cart
  - Remove from cart
  - View Cart
  - Begin Checkout
  
- [**Order Events**](#order-events)
  - Order
  - Cancel order

- [**Wishlist Events**](#wishlist-events)
  - Add to wishlist
  - Remove from wishlist

- [**Search Event**](#search-event)

For these event there are related tables in your account. Following are the details and sample codes for each of above events.

**Page View Events** <a name="page-view-events-details" />
Page view events will be sent to `page_view_events` table. If you add new columns to this table. You can send these in the event data.
```Javascript
// import at top
import 'package:dengage_flutter/dengage_flutter.dart';
...


// Home page view
DengageFlutter.pageView({
    "page_type":"home"
    // ... extra columns in page_view_events table, can be added here
})

// Category page view
DengageFlutter.pageView({
    "page_type":"category",
    "category_id":"1"
    // ... extra columns in page_view_events table, can be added here
})

// Product page view
DengageFlutter.pageView({
    "page_type":"product",
    "product_id":"1"
    // ... extra columns in page_view_events table, can be added here
})

//promotion page view
DengageFlutter.pageView({
    "page_type":"promotion",
    "promotion_id":"1"
    // ... extra columns in page_view_events table, can be added here
})

//custom page view
DengageFlutter.pageView({
    "page_type":"custom"
    // ... extra columns in page_view_events table, can be added here
})

// For other pages you can send anything as page_type
```

### Shopping Cart Events <a name="shopping-cart-events" />
These events will be stored in `shopping_cart_events` and `shopping_cart_events_detail`. There are 4 shopping cart event functions. `addToCart`, `removeFromCart`, `viewCart`, `beginCheckout` Every shopping cart event function needs all items in cart as an array. You must send last version of the shopping cart.

For example: If there is one item in cart and item id is 5. And after that, an add to cart action is happened with the item id 10. You have to send 10 as `product_id` in event parameters and you must send current version of cart items. Meaning [5, 10]

```Dart
// import statement
import 'package:dengage_flutter/dengage_flutter.dart';

// All items currently exists in shopping cart must be added to an array
const cartItem = {}, // cartItem will be an object with key:value types as String:Any

cartItem["product_id"] = 1
cartItem["product_variant_id"] = 1
cartItem["quantity"] = 1
cartItem["unit_price"] = 10.00
cartItem["discounted_price"] = 9.99
// ... extra columns in shopping_cart_events_detail table, can be added in cartItem

let cartItems = []
cartItems.push(cartItem) 
cartItems.push(cartItem2) 


// Add to cart action
const addParams = {
    "product_id":1,
    "product_variant_id":1,
    "quantity":1,
    "unit_price":10.00,
    "discounted_price":9.99,
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems":cartItems // all items in cart
}
DengageFlutter.addToCart(addParams)

// ....
// Remove from cart action
const removeParams = {
    "product_id":1,
    "product_variant_id":1,
    "quantity":1,
    "unit_price":10.00,
    "discounted_price":9.99,
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems":cartItems // all items in cart
}
DengageFlutter.removeFromCart(removeParams)

// view cart action
const viewParams = {
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems":cartItems
}
DengageFlutter.viewCart(viewParams)

// begin checkout action
var checkoutParams = {
    // ... extra columns in shopping_cart_events table, can be added here
    "cartItems":cartItems
}
DengageFlutter.beginCheckout(checkoutParams)
```

### Order Events <a name="order-events" />
Orders events will be sent to order_events and order_events_detail tables.
```Dart
// Ordered items or canceled items must be added to an array
// import statement
import 'package:dengage_flutter/dengage_flutter.dart';

const cartItem = {}

cartItem["product_id"] = 1
cartItem["product_variant_id"] = 1
cartItem["quantity"] = 1
cartItem["unit_price"] = 10.00
cartItem["discounted_price"] = 9.99
// ... extra columns in order_events_detail table, can be added in cartItem

const cartItems = []
cartItems.push(cartItem) 
cartItems.push(cartItem2) 
// ... ordered or canceled items must be added


// Place order action
const placeOrderParams = {
    "order_id":1,
    "item_count":1, // total ordered item count
    "total_amount":1, // total price
    "discounted_price":9.99, // use total price if there is no discount
    "payment_method":"card",
    "shipping":5,
    "coupon_code":"",
    // ... extra columns in order_events table, can be added here
    "cartItems":cartItems //ordered items
}
DengageFlutter.placeOrder(placeOrderParams)

// Cancel order action
const cancelParams = {
    "order_id":1, // canceled order id
    "item_count":1, // canceled total item count
    "total_amount":1, // canceled item's total price
    "discounted_price":9.99, // use total price if there is no discount
    // ... extra columns in order_events table, can be added here
    "cartItems":cartItems // // canceled items 
}
DengageFlutter.cancelOrder(cancelParams)
```

### Wishlist Event <a name="wishlist-events" />
These events will be stored in `wishlist_events` and `wishlist_events_detail`. 
There are 2 wishlist event functions. `addToWishlist`, `removeFromWishlist`. In every event call, you can send all items in wishlist. It makes it easy to track current items in wishlist.

```Dart
  // import statement 
  import 'package:dengage_flutter/dengage_flutter.dart';

  // Current items in wishlist
  const wishListItem = {}
  wishListItem["product_id"] = 1

  const wishListItems = []
  wishListItems.push(wishListItem)


  // Add to wishlist action
  const params = [
      "product_id": 1,
      // ... extra columns in wishlist_events table, can be added here
      "items": wishlistItems // current items
  ]
  DengageFlutter.addToWishList(params)

  // Remove from wishlist action
  const removeParams = [
      "product_id": 1,
      // ... extra columns in wishlist_events table, can be added here
      "items": wishlistItems // current items
  ]
  DengageFlutter.removeFromWishList(removeParams)
```

### Search Event <a name="search-event"/>
Search events will be stored in `search_events` table.

```Dart
  const params = {
      "keywords":"some product name", // text in the searchbox
      "result_count":12,
      "filters":"" //you can send extra filters selected by user here. Formating is not specified
      // ... extra columns in search_events table, can be added here
  }
  DengageFlutter.search(params)
```

### 2.1 Custom Events
#### Send device specific events
You can use `sendDeviceEvent` function for sending events for the device. Events are sent to a big data table defined in your D·engage account. That table must have relation to the `master_device` table. If you set `contact_key` for that device. Collected events will be associated for that user.
```Dart
// for example if you have a table named "events"
// and events table has "key", "event_date", "event_name", "product_id" columns
// you just have to send the columns except "key" and "event_date", because those columns sent by the SDK
// methodSignature => dengage(‘sendDeviceEvent’, tableName: String, dataObject, callback);
  Map data = new HashMap<String, dynamic>();
  data["name"] = "Kamran Younis";
  await DengageFlutter.sendDeviceEvent("tableName", data);
```

### App Inbox
App Inbox is a screen within a mobile app that stores persistent messages. It’s kind of like an email inbox, but it lives inside the app itself. App Inbox differs from other mobile channels such as push notifications or in-app messages. For both push and in-app messages, they’re gone once you open them.

In other words, D·engage admin panel lets you keep selected messages on the platform and Mobile SDK may retreive and display these messages when needed.

In order to save messages into App Inbox, you need to select “Save to Inbox” option when sending messages in D·engage admin panel by assigning an expire date to it.

Inbox messages are kept in the memory storage of the phone until app is completely closed or for a while and D·engage SDK provides functions for getting and managing these messages.

  #### Requirements
  - *Android*: D·engage SDK 3.2.3+
  - *iOS*: D·engage SDK 2.5.21+

  #### Methods
  There are 3 methods to manage App Inbox Messages
  
  - To get app inbox messages from the server
    ```
      Object result = await DengageFlutter.getInboxMessages(offset, limit).catch(err => err)
      // where offset: Int, limit: Int = 20
      // inboxMessages now either have array of Inbox messages or an error.
    ```
  - To delete a specific message from the inbox.
    ```
      Object result = await DengageFlutter.deleteInboxMessage(id).catch(err => err)
      // where id: String
      // delMsgResponse now either have {success: true, id: "id-of-msg-deleted"} or an error
    ```

  - to mark a specific message as clicked.
    ```
      Object result = await DengageFlutter.setInboxMessageAsClicked(id).catch(err => err)
      // where id: String &
      // msgSetAsClicked now either have {success: true, id: "id-of-msg-deleted"} or an error
    ```

### In-App Messaging
In-app message is a type of mobile message where the notification is displayed within the app. It is not sent in a specific time but it is show to user when user are using the app. Examples include popups, yes/no prompts, banners, and more. In order to show in-app messages, there is no permission requirement.

  #### Requirements
  - iOS: D·engage SDK 3.2.3+
  - android: D·engage SDK 3.2.3+

  #### Methods  
  Created messages will be stored in D·engage backend and will be served to mobile SDKs. If you integrated mobile SDK correctly for push messages, for using in-app features you just have to add setNavigtion function to every page navigation.
If you want to use screen name filter, you should send screen name to setNavigation function in every page navigation.

  #### Simple In App Messaging
  ```
    DengageFlutter.setNavigation()
  ```

  #### In App Messaging with Screen Name
  ```
    DengageFlutter.setNavigation('cart')
  ```

  #### In App Messaging with Screen Name and Page Data

  ```
  //
  // (Coming soon)
  // Scheduled: April 2021
  // if you have extra information 
  // you can send them to use screen data filters.
  Object screenData = {productId: "~hs7674", price: 1200}
  DengageFlutter.setNavigation('product', screenData)
  ```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
