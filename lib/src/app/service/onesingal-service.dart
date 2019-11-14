import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static setup(String appId) {
    OneSignal.shared.init(appId, iOSSettings: {
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
}
