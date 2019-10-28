import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'message.dart';

class ChatModel {
  final int peerId;
  final String avatarUrl;
  final String name;
  final String datetime;
  final String message;
  final List<Message> listMessage;
  ChatModel(
      {this.peerId,
      this.avatarUrl,
      this.name,
      this.datetime,
      this.message,
      this.listMessage});

  static List<ChatModel> dummyData = [
    ChatModel(
        peerId: 1,
        avatarUrl:
            "https://cdn.lolwot.com/wp-content/uploads/2016/02/20-of-the-most-unbelievably-stunning-women-1.jpg",
        name: "Ms Phương",
        datetime: "20:18",
        message: "Hôm nay trường có sự kiện abc",
        listMessage: [
          Message("Hôm nay trường có sự kiện abc", false),
          Message("Sự kiện diễn ra khi nào vậy cô?", true),
        ]),
    ChatModel(
        peerId: 2,
        avatarUrl: "https://cdn.pornpics.com/pics/2011-07-02/17558_05big.jpg",
        name: "Ms Châu",
        datetime: "19:22",
        message: "hmmmm....",
        listMessage: [
          Message("hmmmm....", false),
        ]),
    ChatModel(
        peerId: 3,
        avatarUrl: "https://randomuser.me/api/portraits/men/81.jpg",
        name: "Mr Tho",
        datetime: "11:05",
        message: "hmmmm...",
        listMessage: [
          Message("hmmmm....", false),
        ]),
    ChatModel(
        peerId: 4,
        avatarUrl: "https://randomuser.me/api/portraits/men/83.jpg",
        name: "Mr Minh",
        datetime: "09:46",
        message: "hmmmm...",
        listMessage: [
          Message("hmmmm....", false),
        ])
  ];
}

class Chatting {
  dynamic peerId;
  dynamic avatarUrl;
  String name;
  String datetime;
  String message;

  Chatting({
    this.peerId,
    this.avatarUrl,
    this.name,
    this.datetime,
    this.message,
  });

  ///Get from collection Chat on FireStore
  Chatting.fromDocumentSnapShot(DocumentSnapshot document) {
    Parent parent = Parent();
    if (parent.id.toString() == document['receiverId'])
      peerId = document['receiverId'];
    else
      peerId = document['senderId'];
    var dateTime = DateFormat('dd MMM kk:mm').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(document['timestamp'])));

    datetime = dateTime;
    name = "a";
    message = document['content'];
  }
}
