import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_location_manager/flutter_location_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _content = '';
  bool _isMoving = false;

  JsonEncoder encoder = new JsonEncoder.withIndent("     ");

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion = 'platformVersion: ';
    try {
      platformVersion += await FlutterLocationManager.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }


    if (!mounted) return;

    setState(() {
      _content = platformVersion;
    });
  }

  void onLocation(Location location){
    print(">>> onLocation: $location");
    String content = 'CurrentPosition: ';
    content += encoder.convert(location.toMap());
    setState(() {
      _content = content;
    });
  }
  void onLocationError(LocationError error){
    print(">>> onLocationError: ${error.toString()}");
  }


  void _onClickChangePace() {

    setState(() {
      _isMoving = !_isMoving;
    });

    print("[onClickChangePace] -> $_isMoving");

    _isMoving ? FlutterLocationManager.startLocation(onLocation) : FlutterLocationManager.stopLocation();
  }

  Future<void> _onClickGetCurrentPosition() async {

    FlutterLocationManager.getCurrentPosition().then(onLocation).catchError((error) {
      String content = 'getCurrentPosition: ';
      content += error.toString();
      setState(() {
        _content = content;
      });
      print('[getCurrentPosition] ERROR: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Location Manager Plugin'),
        ),
        body: Center(
          child: Text('$_content\n'),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.gps_fixed),
                        onPressed: _onClickGetCurrentPosition,
                      ),
                      MaterialButton(
                          child: Icon((_isMoving) ?
                            Icons.pause :
                            Icons.play_arrow,
                              color: Colors.white),
                          color: (_isMoving) ?
                            Colors.red :
                            Colors.green,
                          onPressed: _onClickChangePace
                      )
                    ]
                )
            )
        ),
      ),
    );
  }
}
