
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/database.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/model/conver.dart';
import 'package:message_app/view/conversation/chat_list_builder.dart';
import 'package:provider/provider.dart';

class ChatHomePage extends StatelessWidget {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Convo>>.value(
        // catchError: (_, __) => null,
      initialData: [],
        value: Database.streamConversations(firebaseAuth.currentUser!.uid),
        child: ConversationDetailsProvider(user: firebaseAuth.currentUser!));
  }
}

class ConversationDetailsProvider extends StatelessWidget {
  const ConversationDetailsProvider({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new SafeArea(child: Column(
      children: [
        Expanded(child: StreamProvider<List<ChatUser>>.value(
            // catchError: (_, __) => null,
            initialData: [],
            value: Database.getUsersByList(
                getUserIds(Provider.of<List<Convo>>(context))),
            child: HomeBuilder())),
      ],
    ));
  }

  List<String> getUserIds(List<Convo> _convos) {
    final List<String> users = <String>[];
    for (Convo c in _convos) {
      c.userIds[0] != user.uid
          ? users.add(c.userIds[0])
          : users.add(c.userIds[1]);
    }
    return users;
  }
}