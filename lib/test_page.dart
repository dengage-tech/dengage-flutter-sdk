import 'dart:math';

import 'package:dengage_flutter/dengage_flutter_platform_interface.dart';
import 'package:dengage_flutter/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    super.initState();
    DengageFlutterPlatform.instance.getPlatformVersion().then((value) {
      Log.i("getPlatformVersion : $value");
    });

    DengageFlutterPlatform.instance.getToken().then((value) {
      Log.i("getToken : $value");
    });

    DengageFlutterPlatform.instance.getSubscription().then((value) {
      Log.i("getSubscription : ${value.toString()}");

      Log.i("appVersion ${value?.appVersion}");
    });
/*
    DengageFlutterPlatform.instance
        .handleNotificationActionBlock()
        .listen((event) {
      Log.i('event : ${event}');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dengage CDMP'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance.showTestPage();
              },
              child: const Text("Native Test Page")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance
                    .getInboxMessages(10, 0)
                    .then((value) {
                  showSnackBar(scaffoldMessenger, "getInboxMessages : $value");
                }).onError((error, stackTrace) {
                  showSnackBar(scaffoldMessenger, "getInboxMessages : $error",
                      isError: true);
                });
              },
              child: const Text("getInboxMessages")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance
                    .getUserPermission()
                    .then((value) {
                  showSnackBar(scaffoldMessenger, "getUserPermission : $value");
                }).onError((error, stackTrace) {
                  showSnackBar(scaffoldMessenger, "getUserPermission : $error",
                      isError: true);
                });
              },
              child: const Text("getUserPermission")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance.getToken().then((value) {
                  showSnackBar(scaffoldMessenger, "Token : $value");
                }).onError((error, stackTrace) {
                  showSnackBar(scaffoldMessenger, "Token : $error",
                      isError: true);
                });
              },
              child: const Text("getToken")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance
                    .setToken('${Random().nextInt(99)}')
                    .then((_) {
                  showSnackBar(scaffoldMessenger, "setToken");
                });
              },
              child: const Text("setToken")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance
                    .getInboxMessages(10, 1)
                    .then((v) {
                  showSnackBar(scaffoldMessenger, "getInboxMessages");
                }).onError((PlatformException error, stackTrace) {
                  showSnackBar(scaffoldMessenger, error.message.toString(),
                      isError: true);
                });
              },
              child: const Text("getInboxMessages")),
          ElevatedButton(
              onPressed: () {
                DengageFlutterPlatform.instance.setNavigation('test');
              },
              child: const Text("setNavigation")),
        ],
      ),
    );
  }

  showSnackBar(ScaffoldMessengerState scaffoldMessenger, String value,
      {bool isError = false}) {
    Log.i(value);
    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.blue,
    ));
  }
}
