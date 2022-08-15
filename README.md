# dengage_flutter

**D·engage Customer Driven Marketing Platform (CDMP)** serves as a customer data platform (CDP) with built-in omnichannel marketing features. It replaces your marketing automation and cross-channel campaign management.
For further details about D·engage please [visit here](https://dev.dengage.com).

This package makes it easy to integrate, D·engage, with your React-Native iOS and/or Android apps. Following are instructions for installation of react-native-dengage SDK to your react-native applications.


// Add Firebase to your Flutter app
// https://firebase.flutter.dev/docs/manual-installation
android > build.gradle
    classpath 'com.google.gms:google-services:4.3.13'
    apply plugin: 'com.google.gms.google-services' 

android > app > src > build.gradle
    apply plugin: 'com.google.gms.google-services'


lib > main.dart 
void main() async {
  await DengagePlatform.instance
      .init(firebaseIntegrationKey: firebaseIntegrationKey);
  runApp(const MaterialApp(home: TestPage()));
}


android > app > src > main > AndroidManifest.xml

             <!-- Event api url of Dengage -->
        <meta-data
            android:name="den_event_api_url"
            android:value="https://tr-event.dengage.com/api/event" />

        <!-- Push api url of Dengage -->
        <meta-data
            android:name="den_push_api_url"
            android:value="https://tr-push.dengage.com" />

                    <!-- Push api url of Dengage -->
        <meta-data
            android:name="den_geofence_api_url"
            android:value="https://tr-geofence.dengage.com/geoapi" />




#ios

info.plist

	<key>DengageApiUrl</key>
	<string>https://tr-push.dengage.com</string>
	<key>DengageEventApiUrl</key>
	<string>https://tr-event.dengage.com</string>