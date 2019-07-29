import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_location_manager/flutter_location_manager.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_location_manager');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterLocationManager.platformVersion, '42');
  });
}
