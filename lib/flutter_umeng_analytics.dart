import 'dart:async';

import 'package:flutter/services.dart';

class Policy {
  static final int REALTIME = 0;
  static final int BATCH = 1;
  static final int SEND_INTERVAL = 6;
  static final int SMART_POLICY = 8;
}

class UMengAnalytics {
  static const DEVICE_TYPE_PHONE = 1;
  static const DEVICE_TYPE_BOX = 2;

  static const MethodChannel _channel =
      const MethodChannel('flutter_umeng_analytics');

  static Future<bool> init(
    String key, {
    int deviceType = DEVICE_TYPE_PHONE,
    String channel = 'default',
    int policy,
    bool reportCrash,
    bool encrypt,
    double interval,
    bool logEnable,
  }) async {
    Map<String, dynamic> args = {
      'key': key,
      'deviceType': deviceType,
      'channel': channel,
    };

    if (policy != null) args['policy'] = policy;
    if (reportCrash != null) args['reportCrash'] = reportCrash;
    if (encrypt != null) args['encrypt'] = encrypt;
    if (interval != null) args['interval'] = interval;
    if (logEnable != null) args['logEnable'] = logEnable;

    await _channel.invokeMethod('init', args);
    return true;
  }

  // page view
  static Future<void> logPageView(String name, int seconds) async {
    await _channel
        .invokeMethod("logPageView", {"name": name, "seconds": seconds});
  }

  static Future<void> beginPageView(String name) async {
    await _channel.invokeMethod("beginPageView", {"name": name});
  }

  static Future<void> endPageView(String name) async {
    await _channel.invokeMethod("endPageView", {"name": name});
  }

  static Future<void> onProfileSignIn(String uid, [String provider]) async {
    await _channel.invokeMethod('onProfileSignIn', {
      'uid': uid,
      'provider': provider,
    });
  }

  static Future<void> onProfileSignOff() async {
    await _channel.invokeMethod('onProfileSignOff');
  }

  // event
  static Future<Null> logEvent(
    String name, {
    String label,
    Map<String, String> map,
  }) {
    _channel.invokeMethod("logEvent", {
      "name": name,
      "label": label,
      "map": map,
    });
  }
}
