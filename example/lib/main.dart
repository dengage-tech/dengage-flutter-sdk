import 'package:dengage_flutter/dengage_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Object result = await DengageFlutter.setIntegerationKey("");
    print("result: $result");
  } on PlatformException catch (error) {
    print("error: $error");
  } on Exception catch (error) {
    print("exception: $error");
  }
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text("Dengage Flutter Sample App"),
        ),
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Image(
            image: AssetImage("lib/images/diamond.png"),
          ),
        ),
      ),
    ),
  );
}
