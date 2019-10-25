import 'dart:convert';

import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/service/encrypt-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'common-service.dart';

class CloudFiresStoreService {
  final Geoflutterfire _geo = Geoflutterfire();
  final Firestore _firestore = Firestore.instance;
  DocumentReference _docRef;
  static final CloudFiresStoreService _singleton =
      new CloudFiresStoreService._internal();

  factory CloudFiresStoreService() {
    return _singleton;
  }

  CloudFiresStoreService._internal();

  syncColectionChildrenBusSession() {
    if (_docRef == null)
      ChildrenBusSession.list.forEach((data) {
        _firestore
            .collection("childrenBusSession")
            .document(data.sessionID)
            .setData(data.toJson())
            .then((onValue) {
          _docRef = _firestore.document(data.sessionID);
        }).catchError((onError) {
          print("Error adding document: " + onError);
        });
      });
  }

  updateChildrenBusSession(ChildrenBusSession data) {
    _firestore
        .collection("childrenBusSession")
        .document(data.sessionID)
        .setData(data.toJson())
        .then((onValue) {
      _docRef = _firestore.document(data.sessionID);
    }).catchError((onError) {
      print("Error adding document: " + onError);
    });
  }

  Stream<DocumentSnapshot> listenChildrenBusSession(sessionID) {
    return _firestore
        .collection("childrenBusSession")
        .document(sessionID)
        .snapshots();
  }

  Stream<QuerySnapshot> listenAllChildrenBusSession() {
    return _firestore.collection("childrenBusSession").snapshots();
  }

  sendMessage() {
    var id = EncrypteService.encrypt("User01").base64,
        peerId = EncrypteService.encrypt("User02").base64,
        groupChatId = "";
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    var documentReference = _firestore
        .collection('chat')
        .document(groupChatId)
        .collection(String.fromCharCodes(groupChatId.runes.toList().reversed))
        .document();

    _firestore.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'senderId': "User01",
          'receiverId': "User02",
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': "234",
          'type': 0
        },
      );
    });
  }
}
