import 'dart:async';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:flutter/material.dart';

class MessagePageViewModel extends ViewModelBase {
  StreamSubscription streamCloud;
  List<Chatting> listChat = [];
  bool loading = true;
  Parent parent = Parent();
  @override
  void dispose() {
    streamCloud.cancel();
    super.dispose();
  }

  MessagePageViewModel() {
    loading = true;
  }
  Future listenData() async {
    if (streamCloud != null) streamCloud.cancel();
    final _snap =
        await cloudService.chat.listenListMessageByUserId(parent.id.toString());
    streamCloud = _snap.listen((onData) {
      if (onData.documents.length > 0) {
        listChat = onData.documents
            .map((item) => Chatting.fromDocumentSnapShot(item))
            .toList();
        //get image listChat
        listChat.forEach((item) {
          api.getCustomerInfo(item.peerId).then((onValue) {
            item.name = onValue.displayName;
            item.avatarUrl = onValue.image;
            this.updateState();
          });
        });
      }
      loading = false;
      this.updateState();
    });
  }

  onItemClick(Chatting chatting) {
    // return api.getListChildrenBusSession().then((data) {
    //   print(data);
    // });
    Navigator.pushNamed(
      context,
      MessageDetailPage.routeName,
      arguments: chatting,
    );
  }
}
