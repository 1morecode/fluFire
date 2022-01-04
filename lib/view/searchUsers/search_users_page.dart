
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/view/searchUsers/widget/user_search_card.dart';
import 'package:message_app/view/widget/loading.dart';

class SearchUsersPage extends StatefulWidget {
  const SearchUsersPage({Key? key}) : super(key: key);

  @override
  _SearchUsersPageState createState() => _SearchUsersPageState();
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  final ScrollController listScrollController = ScrollController();
  TextEditingController textEditingController = new TextEditingController();
  List<dynamic> users = [];
  FocusNode focusNode = new FocusNode();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(scrollListener);
    Timer(Duration(seconds: 1), () => focusNode.requestFocus());
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  getUsers(val) async {
    print("Start");
    try {
      QuerySnapshot streamQuery = await FirebaseFirestore.instance
          .collection('allUsers')
          .limit(_limit)
          .get();
      print("All USERS  ${streamQuery.docs.toList()}");
      users.clear();
      users = streamQuery.docs.toList();
      print("SUERS $users $val");
      setState(() {
        users = users
            .where(
                (s) => s['nickname'].toLowerCase().contains(val.toLowerCase()))
            .toList();
      });
    } catch (err) {
      print("ERR $err");
    }
    print("New SUERS $users");
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: new AppBar(
        backgroundColor: colorScheme.onPrimary,
        elevation: 1,
        leading: CupertinoButton(
          minSize: 15,
          padding: EdgeInsets.all(0),
          child: CircleAvatar(
            backgroundColor: colorScheme.onSurface,
            child: Icon(
              CupertinoIcons.chevron_back,
              size: 24,
              color: colorScheme.onSecondary,
            ),
            radius: 15,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: new Container(
          height: 40,
            decoration: BoxDecoration(color: colorScheme.onSurface, borderRadius: BorderRadius.circular(10)),
          child: CupertinoSearchTextField(
            controller: textEditingController,
            prefixInsets: EdgeInsets.symmetric(horizontal: 5),
            backgroundColor: Colors.transparent,
            placeholder: "Search users...",
            focusNode: focusNode,
            itemColor: colorScheme.secondaryVariant,
            itemSize: 0.0,
            placeholderStyle: new TextStyle(
                color: Theme.of(context).colorScheme.secondaryVariant,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                fontSize: 16),
            style: new TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                fontSize: 16),
            onSubmitted: (val) {
              if (val.isNotEmpty) {
                getUsers("$val");
              }else{
                users.clear();
              }
            },
            onChanged: (val){
              if (val.length > 0) {
                getUsers("$val");
              }else{
                users.clear();
              }
            },
          )
        ),
        titleSpacing: 0,
        actions: [new SizedBox(width: 10,)],
      ),
      body: Stack(
        children: <Widget>[
          // List
          ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) => buildItem(context, users[index]),
            itemCount: users.length,
            controller: listScrollController,
          ),
          // Loading
          Positioned(
            child: isLoading ? const Loading()
                : Container(),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document.data()!['id'] == AuthUtil.firebaseAuth.currentUser!.uid) {
      return Container();
    } else {
      ChatUser chatUser = new ChatUser(image: document.data()!['photoUrl'], id: document.id, name: document.data()!['nickname'], time: document.data()!['createdAt'], about: document.data()!['about'], typingStatus: document.data()!['typing_status'], chattingWith: document.data()!['chattingWith']);
      return UserSearchCard(
        document: chatUser,
      );
    }
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
