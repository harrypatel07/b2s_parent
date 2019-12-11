import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/service/common-service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetailPageViewModel extends ViewModelBase {
  HistoryInfo historyInfo;
  HistoryDetailPageViewModel() {}
  onTapChatDriver() {
    Chatting chatting = Chatting(
        peerId: historyInfo.driver.id.toString(),
        name: historyInfo.driver.name,
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: historyInfo.driver.photo,
        datetime: DateTime.now().toIso8601String());
    Navigator.pushNamed(
      context,
      MessageDetailPage.routeName,
      arguments: chatting,
    );
  }

//  onTapChatAttendant(){
//    Chatting chatting = Chatting(
//        peerId: childrenBusSession.attendant.id.toString(),
//        name: childrenBusSession.attendant.name,
//        message: 'Hi',
//        listMessage: new List(),
//        avatarUrl: childrenBusSession.attendant.photo,
//        datetime: DateTime.now().toIso8601String()
//    );
//    Navigator.pushNamed(context, MessageDetailPage.routeName, arguments: chatting,);
//  }
  String getDifferenceTime(String timeEstimate, String timeReal) {
    String result = '';
    if (timeReal == '') return '';
    DateFormat dateFormat = new DateFormat.Hm();
    DateTime now = DateTime.now();
    DateTime estimate =
        dateFormat.parse(Common.removeMiliSecond(timeEstimate.toString()));
    estimate = new DateTime(
        now.year, now.month, now.day, estimate.hour, estimate.minute);
    DateTime real =
        dateFormat.parse(Common.removeMiliSecond(timeReal.toString()));
    real = new DateTime(now.year, now.month, now.day, real.hour, real.minute);

    String hour = '';
    String minute = '';
    int h = estimate.difference(real).inHours.abs();
    if (h > 0) hour = '${h}h';
    int m = estimate.difference(real).inMinutes.abs() -
        estimate.difference(real).inHours.abs() * 60;
    if (m > 0) minute = '${m}m';
    if (h == 0 && m == 0) return '0m';
    if (real.isBefore(estimate))
      result = '${translation.text("HISTORY_TRIP_PAGE.EARLY")} $hour $minute';
    else
      result = '${translation.text("HISTORY_TRIP_PAGE.LATE")} $hour $minute';
    return result;
  }
}
