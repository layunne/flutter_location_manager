library location_manager;

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:convert';

part 'models/location.dart';


const _PLUGIN_NAME = "flutter_location_manager";
const _EVENT_CHANNEL_LOCATION = "$_PLUGIN_NAME/location";
const _METHOD_CHANNEL_PLATFORM_VERSION = 'getPlatformVersion';
const _METHOD_CHANNEL_CURRENT_POSITION = 'getCurrentPosition';
const _METHOD_CHANNEL_START_LOCATION = 'startUpdatingLocation';
const _METHOD_CHANNEL_STOP_LOCATION = 'stopUpdatingLocation';

class FlutterLocationManager {

  static const MethodChannel _channel = const MethodChannel(_PLUGIN_NAME);

  static bool _keepAline = false;

  static const EventChannel _eventChannelLocation = const EventChannel(_EVENT_CHANNEL_LOCATION);
  static StreamSubscription _onLocationSubscription;
  static Stream<dynamic> _eventsLocation;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod<String>(_METHOD_CHANNEL_PLATFORM_VERSION);
    return version;
  }

  static Future<Location> getCurrentPosition() async {

    final dynamic result = await _channel.invokeMethod(_METHOD_CHANNEL_CURRENT_POSITION);
    print("🔴 result: $result");
    print("🔴 result: ${json.decode(result)}");
    return Location.fromMap(json.decode(result));
  }

  static void startLocation(Function(Location) onLocation, {double distanceFilter, double accuracy}) {
    _startLocationServices().then((_){
      _onLocation(distanceFilter: distanceFilter, accuracy: accuracy);
      _onLocationSubscription = _eventsLocation.listen((dynamic location) => onLocation(Location.fromMap(json.decode(location))));
    });
  }

  static void stopLocation(){
    _keepAline = false;
    if(_onLocationSubscription != null){
      _onLocationSubscription.cancel();
      _onLocationSubscription = null;
    }
    _channel.invokeMethod<String>(_METHOD_CHANNEL_STOP_LOCATION).then((_){return;});
  }


  static Future<void> _startLocationServices() async {
    await _channel.invokeMethod<String>(_METHOD_CHANNEL_START_LOCATION);
    return;
  }

  static void _onLocation({double distanceFilter, double accuracy}) {
    _keepAline = true;
    if (_eventsLocation == null) {
      _eventsLocation = _eventChannelLocation.receiveBroadcastStream({'distanceFilter':distanceFilter, 'accuracy':accuracy}).where((_) => _keepAline);
    }
  }
}
