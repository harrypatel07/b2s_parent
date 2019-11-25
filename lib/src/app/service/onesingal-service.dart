import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static Future setup(String appId) async {
    return OneSignal.shared.init(appId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });
  }

  static notificationReceivedHandler(Function(OSNotification) callBack) {
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      callBack(notification);
    });
  }

  static notificationOpenedHandler(
      Function(OSNotificationOpenedResult) callBack) {
    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult notification) {
      callBack(notification);
    });
  }

  static sendTags(Map<String, dynamic> tags) {
    OneSignal.shared.sendTags(tags);
  }
}
