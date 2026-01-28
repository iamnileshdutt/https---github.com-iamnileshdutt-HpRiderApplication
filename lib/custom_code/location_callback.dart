import 'dart:isolate';
import 'dart:ui';
import 'package:background_locator_2/location_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCallbackHandler {
  static const String isolateName = 'LocatorIsolate';
  static SendPort? uiSendPort;

  static void initCallback(Map<String, dynamic> params) {
    print('*** initCallback');
  }

  static void disposeCallback() {
    print('*** disposeCallback');
  }

  static Future<void> callback(LocationDto locationDto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'last_location', '${locationDto.latitude},${locationDto.longitude}');
    print(
        'Background location: ${locationDto.latitude}, ${locationDto.longitude}');
  }
}
