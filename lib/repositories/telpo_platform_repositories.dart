import 'dart:developer';

import 'package:flutter/services.dart';

class PlatformRepository {
  //creating method channel as per created in main_activity.kt
  var platform = const MethodChannel('flutter.native/telpo');

  Future<int> getDeviceStatus() async {
    try {
      final int result = await platform.invokeMethod("getDeviceStatus");
      return result;
    } on PlatformException catch (e) {
      log(e.toString());
      return 2;
    }
  }

  Future<int> turnOnFingerPrintService() async {
    try {
      final int status = await platform.invokeMethod("fingerprint_on");
      return status;
    } on PlatformException catch (e) {
      log(e.toString());
      return 2;
    }
  }

  Future<int> turnOffFingerPrintService() async {
    try {
      final int status = await platform.invokeMethod("fingerprint_off");
      return status;
    } on PlatformException catch (e) {
      log(e.toString());
      return 2;
    }
  }

  Future<dynamic> getIsCapturing() async {
    try {
      final dynamic status = await platform.invokeMethod("is_capturing");
      log(status.toString() + "IS CAPTURING STATUS");
      return status;
    } on PlatformException catch (e) {
      log(e.toString());
      return 2;
    }
  }
}
