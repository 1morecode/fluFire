import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/view/main_app.dart';
import 'package:message_app/res/global_data.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return MaterialButton(
      height: 50,
        minWidth: size.width*0.4,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Image.asset("assets/google.png", width: 24, height: 24,),
            new Text("Login with Google", style: TextStyle(fontSize: 20, color: colorScheme.onPrimary, fontWeight: FontWeight.w600),),
            new SizedBox(width: 15,),
          ],
        ),
        color: colorScheme.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () async {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: new Text("Processing"),
              content: Center(child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new CircularProgressIndicator(),
              ),),
            ),
          );
          bool ii = await AuthUtil.googleSignIn();
          Navigator.of(context).pop();
          if (ii) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainApp()
              ,), (route) => false);
          } else {
            GlobalData.showSnackBar(
                "Authentication Failed!", context, Colors.red);
          }
        });
  }
}
