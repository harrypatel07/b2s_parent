import 'dart:async';

import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:flutter/material.dart';

class MessageDetailViewModel extends ViewModelBase {
  TextEditingController _textMessageController = new TextEditingController();
  get textMessageController => _textMessageController;

  MessageDetailViewModel() {
    _textMessageController.addListener(() {
      this.updateState();
    });
  }
  StreamSubscription streamCloud;
  @override
  void dispose() {
    _textMessageController.dispose();
    streamCloud.cancel();
    super.dispose();
  }

  onSendMessage() async {
    await cloudService.chat.sendMessage(
        strId: "fas2wdasdf48", strPeerId: "fasfasfas24", content: "abc");
    var _snap = await cloudService.chat.listenListMessageByUserId("48");
    streamCloud = _snap.listen((onData) {
      print(onData);
    });
  }
}
