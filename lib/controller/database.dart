import 'dart:async';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/model/conver.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<List<ChatUser>> streamUsers() {
    return _db
        .collection('allUsers')
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()!))
            .toList())
        .handleError((dynamic e) {
      print(e);
    });
  }

  static Stream<List<ChatUser>> getUsersByList(List<String> userIds) {
    final List<Stream<ChatUser>> streams = [];
    for (String id in userIds) {
      streams.add(_db
          .collection('allUsers')
          .doc(id)
          .snapshots()
          .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()!)));
    }
    return StreamZip<ChatUser>(streams).asBroadcastStream();
  }

  static Stream<ChatUser> getUsersById(String userId) {
    Stream<ChatUser> ss = _db
        .collection('allUsers')
        .doc(userId)
        .snapshots()
        .map((DocumentSnapshot snap) => ChatUser.fromMap(snap.data()!));
    return ss;
  }

  static Stream<List<Convo>> streamConversations(String uid) {
    print("UIS $uid");
    return _db
        .collection('messages')
        // .orderBy('lastMessage.timestamp', descending: true)
        .where('users', arrayContains: uid)
        .snapshots()
        .map((QuerySnapshot list) => list.docs
            .map((DocumentSnapshot doc) => Convo.fromFireStore(doc))
            .toList());
  }

  static Future<Map<dynamic, dynamic>> getLastMessage(String convoID) async {
    print("GET LAST Start $convoID");
    DocumentSnapshot documentReference =
        await _db.collection('messages').doc(convoID).get();
    return documentReference.data()!['lastMessage'];
  }

  static void updateMessageRead(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);

    documentReference.update(<String, dynamic>{'read': true});
  }

  static void removeConvUser(Convo conv) {
    conv.hiddenBy.add(AuthUtil.firebaseAuth.currentUser!.uid);
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(conv.id);
    documentReference.update(<String, dynamic>{'hiddenBy': conv.hiddenBy});
  }


  static void deleteMessage(DocumentSnapshot doc, String convoID) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('messages')
        .doc(convoID)
        .collection(convoID)
        .doc(doc.id);
    documentReference.update(<String, dynamic>{'deleted': true});

    final DocumentReference dr =
        FirebaseFirestore.instance.collection('messages').doc(convoID);
    dr.update(<String, dynamic>{'lastMessage.deleted': true});
  }

  static void updateLastMessage(
      DocumentSnapshot doc, String uid, String pid, String convoID) {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('messages').doc(convoID);

    documentReference
        .set(<String, dynamic>{
          'lastMessage': <String, dynamic>{
            'idFrom': doc['idFrom'],
            'idTo': doc['idTo'],
            'timestamp': doc['timestamp'],
            'content': doc['content'],
            'read': doc['read'],
            'type': doc['type']
          },
          'users': <String>[uid, pid]
        })
        .then((dynamic success) {})
        .catchError((dynamic error) {
          print(error);
        });
  }
}
