import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/message.dart';
import 'package:b2s_parent/src/app/service/encrypt-service.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFiresStoreService {
  //final Geoflutterfire _geo = Geoflutterfire();
  final CollectionChat chat = CollectionChat();
  final CollectionBusSession busSession = CollectionBusSession();
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

  Future sendMessage({String strId, String strPeerId, String content}) async {
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
    var _jsonMessKey = Map<String, dynamic>.from(message.toJson());
    _jsonMessKey["keyword"] =
        Common.createKeyWordForChat(groupChatId, split: split);
    await _firestore
        .collection(_collectionName)
        .document(groupChatId)
        .setData(_jsonMessKey);
    var documentReference = _firestore
        .collection(_collectionName)
        .document(groupChatId)
        .collection(String.fromCharCodes(groupChatId.runes.toList().reversed))
        .document();

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
}

class CollectionBusSession extends InterfaceFireStore {
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
}
