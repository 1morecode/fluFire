import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserToken {
  static Future<void> saveUserToDatabase() async {
    // Assume user is logged in for this example
    String? token = await FirebaseMessaging.instance.getToken();
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser!.getIdTokenResult(true);
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot lds = await FirebaseFirestore.instance.collection('allUsers').doc(user!.uid).get();
    if(!lds.exists){
      print("User Has Profile");
      await FirebaseFirestore.instance.collection('allUsers').doc(user.uid).set({
        'chattingWith': null,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'id': user.uid,
        'nickname': user.displayName,
        'about': "This person is very lazy, still not mention about their profile!",
        'photoUrl': user.photoURL!.replaceAll("s96-c", "s300-c").replaceAll("picture", "picture?height=300"),
        // 'tokens': FieldValue.arrayUnion([token]),
        // 'x-token': FieldValue.arrayUnion([ss.token]),
        // 'onesignal-token': '$osUserID',
        // 'playlist_alert': true,
        // 'follow_alert': true,
        // 'message_alert': true,
        // 'voice_room_alert': true
        'typing_status': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }else{
      await FirebaseFirestore.instance.collection('allUsers').doc(user.uid).update({
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'tokens': FieldValue.arrayUnion([token]),
        'x-token': FieldValue.arrayUnion([ss.token]),
        // 'onesignal-token': '$osUserID',
      });
    }
  }

  static updateTimeInDatabase() {

    User? user = FirebaseAuth.instance.currentUser;
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('allUsers').doc(user!.uid);
    Timer.periodic(Duration(seconds: 10), (timer) {
      documentReference.update(<String, dynamic>{
        'createdAt': "${DateTime.now().millisecondsSinceEpoch.toString()}"
      });
    });
  }

  static updateTypingTime() {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentReference documentReference =
    FirebaseFirestore.instance.collection('allUsers').doc(user!.uid);
    documentReference.update(<String, dynamic>{
      'typing_status': "${DateTime.now().millisecondsSinceEpoch.toString()}"
    });
  }

  static Future<String?> getToken() async {
    var firebaseAuth = FirebaseAuth.instance;
    IdTokenResult ss = await firebaseAuth.currentUser!.getIdTokenResult(true);
    print("TT $ss");
    return ss.token;
  }

}
