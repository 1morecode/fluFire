import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/theme/app_state.dart';
import 'package:message_app/view/auth/google/google_login_button.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<ThemeState>(builder: (context, themeState, child) => Scaffold(
      backgroundColor: themeState.isDarkModeOn ? Colors.black : Colors.white,
      body: new SafeArea(
          child: new Column(
            children: [
              new Expanded(child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Image.asset(!themeState.isDarkModeOn ? "assets/logo_trans.png" : "assets/logo_dark.png", height: 150,),
                ],
              )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                child: new Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [GoogleSignInButton(),],
                ),
              ),
              CupertinoButton(
                onPressed: (){},
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: EasyRichText(
                  "By Continue, to agree our\n"
                      "Terms & Conditions",
                  defaultStyle: TextStyle(color: colorScheme.onSecondary),
                  patternList: [
                    EasyRichTextPattern(
                      targetString: 'Terms',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                    EasyRichTextPattern(
                      targetString: 'Conditions',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    ),);
  }
}
