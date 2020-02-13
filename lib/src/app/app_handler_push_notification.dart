import 'dart:async';
import 'dart:ui';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/message.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/popup_notification_widget.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tip_dialog/tip_dialog.dart';

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
      if (type == 1) {
        TipDialogHelper.show(
            tipDialog: Wrap(children: <Widget>[
              NotificationWidget(
                title: title,
                body: body,
              )
            ]),
            isAutoDismiss: false);
      }
    }
  }
}
