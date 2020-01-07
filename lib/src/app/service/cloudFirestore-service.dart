import 'dart:async';
import 'dart:convert';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/models/busSession.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/message.dart';
import 'package:b2s_parent/src/app/service/encrypt-service.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:async/async.dart';

class CloudFiresStoreService {
  //final Geoflutterfire _geo = Geoflutterfire();
  final CollectionChat chat = CollectionChat();
  final CollectionBusSession busSession = CollectionBusSession();
  final CollectionChildrenBusSession childrenBusSession =
      CollectionChildrenBusSession();
  static final CloudFiresStoreService _singleton =
      new CloudFiresStoreService._internal();

  factory CloudFiresStoreService() {
    return _singleton;
  }
  CloudFiresStoreService._internal();
}

class InterfaceFireStore {
  final Firestore _firestore = Firestore.instance;
  DocumentReference _docRef;
  final String fieldPathDocumentId = '__name__';
  final String split = "-";
}

class CollectionChat extends InterfaceFireStore {
  final _collectionName = "chat";

  Future sendMessage(
      {String strId,
      String strPeerId,
      String strPeerName,
      String content}) async {
    var id = EncrypteService.encryptHash(strId),
        peerId = EncrypteService.encryptHash(strPeerId),
        groupChatId = "";
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id$split$peerId';
    } else {
      groupChatId = '$peerId$split$id';
    }
    Messages message = Messages();
    message.senderId = strId;
    message.receiverId = strPeerId;
    message.content = content;
    message.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    message.type = 0;
    message.receiverName = strPeerName;
    var _jsonMessKey = Map<String, dynamic>.from(message.toJson());
    _jsonMessKey["keyword"] =
        Common.createKeyWordForChat(groupChatId, split: split);
    _firestore
        .collection(_collectionName)
        .document(groupChatId)
        .setData(_jsonMessKey);
    var documentReference = _firestore
        .collection(_collectionName)
        .document(groupChatId)
        .collection(String.fromCharCodes(groupChatId.runes.toList().reversed))
        .document();
    api.postNotificationSendMessage(message);
    return await _firestore.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    });
  }

  ///listen List Message by User Id
  Future<Stream<QuerySnapshot>> listenListMessageByUserId(String strId) async {
    final id = EncrypteService.encryptHash(strId);
    return _firestore
        .collection("chat")
        .where("keyword", arrayContains: id)
        .getDocuments()
        .asStream();
    // var id = EncrypteService.encrypt(strId).base64,
    //     peerId = EncrypteService.encrypt("User03").base64,
    //     groupChatId = "";
    // if (id.hashCode <= peerId.hashCode) {
    //   groupChatId = '$id-$peerId';
    // } else {
    //   groupChatId = '$peerId-$id';
    // }
    // return _firestore
    //     .collection('chat')
    //     .document(groupChatId)
    //     .collection(String.fromCharCodes(groupChatId.runes.toList().reversed))
    //     .snapshots();
  }

  ///listen List Message by id and peerID
  Future<Stream<QuerySnapshot>> listenListMessageByIdAndPeerId(
      String strId, String strPeerId) async {
    var id = EncrypteService.encryptHash(strId),
        peerId = EncrypteService.encryptHash(strPeerId),
        groupChatId = "";
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id$split$peerId';
    } else {
      groupChatId = '$peerId$split$id';
    }
    return _firestore
        .collection(_collectionName)
        .document(groupChatId)
        .collection(String.fromCharCodes(groupChatId.runes.toList().reversed))
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

class CollectionChildrenBusSession extends InterfaceFireStore {
  final _collectionName = "childrenBusSession";
  syncColectionChildrenBusSession() {
    if (_docRef == null)
      ChildrenBusSession.list.forEach((data) {
        _firestore
            .collection(_collectionName)
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
        .collection(_collectionName)
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
        .collection(_collectionName)
        .document(sessionID)
        .snapshots();
  }

  Stream<QuerySnapshot> listenAllChildrenBusSession() {
    return _firestore.collection(_collectionName).snapshots();
  }
}

class CollectionBusSession extends InterfaceFireStore {
  final _collectionName = "bus_session";

  Future<StreamSubscription> listenBusSessionForChildren(
      List<ChildrenBusSession> listChildrenBusSession,
      [Function callBack]) async {
    try {
      List<BusSession> listBusSession = listChildrenBusSession
          .map((item) => BusSession.fromChildrenBusSession(item))
          .toList();
      if (listBusSession.length > 0) {
        List<Stream<DocumentSnapshot>> listStream = List();
        //Tạo stream snapshot
        for (var i = 0; i < listBusSession.length; i++) {
          var item = listBusSession[i];
          listStream.add(_firestore
              .collection(_collectionName)
              .document(item.id)
              .snapshots());
        }
        var streamGroup = StreamGroup.merge(listStream).asBroadcastStream();
        return streamGroup.listen((onData) {
          listChildrenBusSession.forEach((item) {
            var genId = md5
                .convert(utf8.encode("${item.sessionID}${item.child.id}"))
                .toString();
            if (genId == onData.documentID) {
              item.status = StatusBus.list[onData.data["statusId"]];
              item.notification = onData.data["notification"];
              if (onData.data["note"] != null) item.note = onData.data["note"];
            }
          });
          if (callBack is Function) {
            callBack();
          }
        });
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> createListBusSessionFromChildrenBusSession(
      List<ChildrenBusSession> listChildrenBusSession) async {
    try {
      List<BusSession> listBusSession = listChildrenBusSession
          .map((item) => BusSession.fromChildrenBusSession(item))
          .toList();
      if (listBusSession.length > 0) {
        for (var item in listBusSession) {
          await _firestore
              .collection(_collectionName)
              .document(item.id)
              .setData(item.toJson())
              .then((onValue) {})
              .catchError((onError) {
            print("Error adding document: " + onError);
          });
        }
      }
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  updateBusSessionFromChildrenBusSession(ChildrenBusSession childrenStatus) {
    var busSession = BusSession.fromChildrenBusSession(childrenStatus);
    _firestore
        .collection(_collectionName)
        .document(busSession.id)
        .updateData(busSession.toJson())
        .then((onValue) {})
        .catchError((onError) {
      print("Error adding document: " + onError);
    });
  }
}
