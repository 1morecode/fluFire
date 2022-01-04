
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/model/conver.dart';
import 'package:message_app/view/widget/conver_list_widget.dart';
import 'package:provider/provider.dart';

class HomeBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    List<Convo> _convos = Provider.of<List<Convo>>(context);
    _convos.sort((a, b) => int.parse(b.lastMessage["timestamp"]).compareTo(int.parse(a.lastMessage["timestamp"])));
    final List<ChatUser> _users = Provider.of<List<ChatUser>>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            physics: BouncingScrollPhysics(),
            children: getWidgets(context, firebaseAuth.currentUser!, _convos, _users)),
    );
  }

  // void createNewConvo(BuildContext context) {
  //   Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
  //       builder: (BuildContext context) => NewMessageProvider()));
  // }

  Map<String, ChatUser> getUserMap(List<ChatUser> users) {
    final Map<String, ChatUser> userMap = Map();
    for (ChatUser u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(
      BuildContext context, User user, List<Convo> _convos, List<ChatUser> _users) {
    print("USERS R $user, $_convos, $_users");
    final List<Widget> list = <Widget>[];
    _convos.removeWhere((element) => element.hiddenBy.contains(AuthUtil.firebaseAuth.currentUser!.uid));
    if(_convos.length > 0 && _users.length > 0){
      final Map<String, ChatUser> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              convo: c,
              peer: userMap[c.userIds[1]]!,
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              convo: c,
              peer: userMap[c.userIds[0]]!,
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }
}
