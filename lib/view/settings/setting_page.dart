import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/theme/app_state.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onSurface,
      appBar: new CupertinoNavigationBar(
          backgroundColor: colorScheme.onPrimary,
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
          ), middle: Text("Settings"),),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              child: Column(
                children: [
                  Consumer<ThemeState>(builder: (context, appState, child) {
                    return Container(
                      child: Row(
                        children: [
                          Icon(appState.isDarkModeOn
                              ? CupertinoIcons.moon_circle
                              : CupertinoIcons.sun_min),
                          Text("   Dark Mode", style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 14, fontWeight: FontWeight.w400),),
                          Spacer(),
                          Transform.scale(
                            scale: 0.7,
                            child: CupertinoSwitch(
                                value: appState.isDarkModeOn,
                                trackColor: colorScheme.secondaryVariant,
                                activeColor: colorScheme.primary,
                                dragStartBehavior: DragStartBehavior.start,
                                onChanged: (bool value) async {
                                  appState.toggleChangeTheme();
                                  if (value) {
                                    SystemChrome.setSystemUIOverlayStyle(
                                        SystemUiOverlayStyle(
                                            systemNavigationBarColor: Colors.black,
                                            // navigation bar color/ status bar color
                                            statusBarBrightness: Brightness.dark,
                                            statusBarColor: Colors.transparent,
                                            systemNavigationBarIconBrightness:
                                            Brightness.light));
                                  } else {
                                    SystemChrome.setSystemUIOverlayStyle(
                                        SystemUiOverlayStyle(
                                            systemNavigationBarColor: Colors.white,
                                            // navigation bar color/ status bar color
                                            statusBarBrightness: Brightness.light,
                                            statusBarColor: Colors.transparent,
                                            systemNavigationBarIconBrightness:
                                            Brightness.dark));
                                  }
                                }),
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                    );
                  }),
                  Divider(color: colorScheme.onSurface, thickness: 1, height: 1,),
                  CupertinoButton(
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.power),
                        Text("   Logout", style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 14, fontWeight: FontWeight.w400),),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          title: new Text(
                            "Warning!",
                            style: TextStyle(color: colorScheme.primary),
                          ),
                          message: new Text(
                              "You really want to logout from this device?"),
                          actions: [
                            CupertinoActionSheetAction(
                              child: new Text("Yes"),
                              onPressed: () {
                                AuthUtil.logout(context);
                              },
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: new Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
