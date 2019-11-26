import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:flutter/material.dart';

class HistoryDetailPageViewModel extends ViewModelBase{
  HistoryInfo historyInfo;
  HistoryDetailPageViewModel(){}
  onTapChatDriver(){
    Chatting chatting = Chatting(
        peerId: historyInfo.driver.id.toString(),
        name: historyInfo.driver.name,
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: historyInfo.driver.photo,
        datetime: DateTime.now().toIso8601String()
    );
    Navigator.pushNamed(context, MessageDetailPage.routeName, arguments: chatting,);
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
}