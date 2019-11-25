import 'dart:async';
import 'package:b2s_parent/packages/loader_search_bar/loader_search_bar.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/profileMessageUser.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/pages/message/profileMessageUser/profile_message_user_page.dart';
import 'package:flutter/material.dart';

class MessagePageViewModel extends ViewModelBase {
  List<ProfileMessageUserModel> listProfileMessageUser = List();
  SearchBarController searchBarController;
  StreamSubscription streamCloud;
  List<Chatting> listChat = [];
  bool loadingDataMessage = true;
  bool loadingDataContacts = true;
  Parent parent = Parent();
  @override
  void dispose() {
    streamCloud.cancel();
    super.dispose();
  }

  MessagePageViewModel() {
    loadingDataMessage = true;
    loadingDataContacts = true;
    searchBarController = new SearchBarController();
  }
  Future listenData() async {
    int checkDone = 0;
    if (streamCloud != null) streamCloud.cancel();
    final _snap = await cloudService.chat.listenListMessageByUserId(parent.id.toString());
    streamCloud = _snap.listen((onData) {
      if (onData.documents.length > 0) {
        listChat = onData.documents
            .map((item) => Chatting.fromDocumentSnapShot(item))
            .toList();
        var itemParent = listChat.firstWhere((item)=>int.parse(item.peerId) == parent.id);
        if(itemParent != null) listChat.remove(itemParent);
        //get image listChat
        listChat.forEach((item) {
          api.getCustomerInfo(item.peerId).then((onValue) {
            item.name = onValue.displayName;
            item.avatarUrl = onValue.image;
            listProfileMessageUser.add(ProfileMessageUserModel.fromDocumentSnapShot(onValue));
            if(checkDone++==listChat.length-1){
              loadingDataMessage = false;
              this.updateState();
            }
          });
        });
      }
    });
  }

  onItemClick(Chatting chatting) {
    Navigator.pushNamed(
      context,
      MessageDetailPage.routeName,
      arguments: chatting,
    );
  }

  onTapProfileMessageUser(int peerId){
    listProfileMessageUser.forEach((userModel){
      if(userModel.peerId == peerId)
        Navigator.pushNamed(context, ProfileMessageUserPage.routeName,arguments:userModel);
    });
  }
}
