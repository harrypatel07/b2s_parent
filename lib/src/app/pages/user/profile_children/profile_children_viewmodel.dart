import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:flutter/material.dart';

class ProfileChildrenViewModel extends ViewModelBase {
  ChildrenBusSession childrenBusSession;
  Children children;
  List<RouteBus> listRouteBus = List();
  String startDepart;
  String endDepart;
  String startArrive;
  String endArrive;
  ProfileChildrenViewModel();
  ///Tạo thời gian đón, đến trường, về ,đến nhà
  onCreateTime() {
    if (listRouteBus.length <= 0) return;
    List<RouteBus> listDepart =
        listRouteBus.where((routeBus) => routeBus.type == 0).toList();
    if (listDepart.length > 0) {
      startDepart =
          listDepart[0].time.substring(0, listDepart[0].time.length - 3);
      endDepart = listDepart[listDepart.length - 1]
          .time
          .substring(0, listDepart[listDepart.length - 1].time.length - 3);
    }
    List<RouteBus> listArrive =
        listRouteBus.where((routeBus) => routeBus.type == 1).toList();
    if (listArrive.length > 0) {
      startArrive =
          listArrive[0].time.substring(0, listArrive[0].time.length - 3);
      endArrive = listArrive[listArrive.length - 1]
          .time
          .substring(0, listArrive[listArrive.length - 1].time.length - 3);
    }
  }
  onTapChatDriver(){
    Chatting chatting = Chatting(
        peerId: childrenBusSession.driver.id.toString(),
        name: childrenBusSession.driver.name,
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: childrenBusSession.driver.photo,
        datetime: DateTime.now().toIso8601String()
    );
    Navigator.pushNamed(context, MessageDetailPage.routeName, arguments: chatting,);
  }
  onTapChatAttendant(){
    Chatting chatting = Chatting(
        peerId: childrenBusSession.attendant.id.toString(),
        name: childrenBusSession.attendant.name,
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: childrenBusSession.attendant.photo,
        datetime: DateTime.now().toIso8601String()
    );
    Navigator.pushNamed(context, MessageDetailPage.routeName, arguments: chatting,);
  }
}
