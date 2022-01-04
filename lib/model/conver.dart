import 'package:cloud_firestore/cloud_firestore.dart';

class Convo {
  Convo({required this.id, required this.userIds, required this.hiddenBy, required this.lastMessage});

  factory Convo.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()!;
    return Convo(
        id: doc.id,
        userIds: data['users'] ?? <dynamic>[],
        hiddenBy: data['hiddenBy'] ?? <dynamic>[],
        lastMessage: data['lastMessage'] ?? <dynamic>{},
    );
  }

  String id;
  List<dynamic> userIds;
  List<dynamic> hiddenBy;
  Map<dynamic, dynamic> lastMessage;
}

class Message {
  Message({required this.id, required this.content, required this.idFrom, required this.idTo, required this.read, required this.timestamp, required this.type});

  factory Message.fromFireStore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data()!;

    return Message(
        id: doc.id,
        content: data['content'],
        idFrom: data['idFrom'],
        idTo: data['idTo'],
        read: data['read'],
        timestamp: data['timestamp'],
        type: data['type']
    );
  }

  String id;
  String content;
  String idFrom;
  String idTo;
  bool read;
  DateTime timestamp;
  int type;
}
