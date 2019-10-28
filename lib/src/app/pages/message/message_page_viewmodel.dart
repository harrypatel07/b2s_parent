import 'dart:async';

import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/service/encrypt-service.dart';

class MessagePageViewModel extends ViewModelBase {
  StreamSubscription streamCloud;
  List<Chatting> listChat = [];
  bool loading = true;
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
    final _snap = await cloudService.chat.listenListMessageByUserId("48");
    streamCloud = _snap.listen((onData) {
      if (onData.documents.length > 0) {
        listChat = onData.documents
            .map((item) => Chatting.fromDocumentSnapShot(item))
            .toList();
      }
      loading = false;
      this.updateState();
    });

    await cloudService.chat
        .sendMessage(strId: "48", strPeerId: "24", content: "abc");
  }
}
