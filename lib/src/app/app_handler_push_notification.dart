import 'dart:async';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/message.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:get/get.dart';

class HandlerPushNotification {
  StreamController streamController = StreamController.broadcast();
  Stream get stream => streamController.stream;

  void dispose() {
    streamController.close();
    streamController = StreamController();
  }

  init() {
    OneSignalService.notificationOpenedHandler((oSNotification) {
      var addData = oSNotification.notification.payload.additionalData;
      _handlerNotificationInApp(addData, 0,
          title: oSNotification.notification.payload.title,
          body: oSNotification.notification.payload.body);
    });
    OneSignalService.notificationReceivedHandler((oSNotification) {
      var addData = oSNotification.payload.additionalData;
      _handlerNotificationInApp(addData, 1,
          title: oSNotification.payload.title,
          body: oSNotification.payload.body);
    });
  }

  _handlerNotificationInApp(Map<String, dynamic> additionalData, int type,
      {String title, String body}) {
    if (additionalData != null)
      additionalData.forEach((key, value) {
        switch (key) {
          //Chat messages
          case "senderId":
            Messages messages =
                Messages.fromJsonPushNotification(additionalData);
            Chatting chat = Chatting.fromMessages(messages);
            api.getCustomerInfo(chat.peerId).then((onValue) {
              chat.avatarUrl = onValue.image.toString();
              chat.name = onValue.name.toString();
              if (type == 0) {
                Get.toNamed(MessageDetailPage.routeName, arguments: chat);
              } else
                streamController.add(chat);
            });
            break;
          default:
        }
      });
    else {
      //do something with additionalData is null
    }
  }
}
