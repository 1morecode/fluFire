import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/res/user_token.dart';
import 'package:message_app/view/conversation/all_conversations.dart';
import 'package:message_app/view/searchUsers/search_users_page.dart';
import 'package:message_app/view/settings/setting_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  void initState() {
    UserToken.saveUserToDatabase();
    UserToken.updateTimeInDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: CustomScrollView(
        shrinkWrap: false,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          //2
          SliverAppBar(
            expandedHeight: 120.0,
          pinned: true,snap: false,floating: true,
            centerTitle: true,
            elevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("FluFire", style: TextStyle(color: colorScheme.onSecondary, fontWeight: FontWeight.bold),),
              // titlePadding: EdgeInsets.all(10),
              collapseMode: CollapseMode.parallax,
              centerTitle: true,
            ),
            actions: [
              CupertinoButton(
                // padding: EdgeInsets.all(5),
                  // minSize: 30,
                  onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchUsersPage(),));
              }, child: Icon(CupertinoIcons.search, color: colorScheme.onSecondary,)),
              CupertinoButton(
                // padding: EdgeInsets.all(5),
                  // minSize: 30,
                  onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage(),));
              }, child: Icon(CupertinoIcons.settings_solid, color: colorScheme.onSecondary,))
            ],
          ),
          //3
          SliverFillRemaining(
            child: ChatHomePage(),
          ),
        ],
      ),
    );
  }
}
