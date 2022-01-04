import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:message_app/view/auth/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtil {
  static var firebaseAuth = FirebaseAuth.instance;
  static GoogleSignIn googleLogin = GoogleSignIn(
          scopes: ['email']);
  static Future<bool> googleSignIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      final GoogleSignInAccount? googleUser = await googleLogin.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      if(userCredential.user != null){
        sharedPreferences.setString("loginType", "google");
        return true;
      }else{
        return false;
      }
    }catch(e){
      print("Google Exception $e");
      return false;
    }
  }

  static logout(context) {
    firebaseAuth.signOut();
    googleLogin.signOut();
    // facebookLogin.logOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (route) => false);
  }

  static logoutWarningAlert(context, colorScheme) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: new Text(
          "Warning!",
          style: TextStyle(color: colorScheme.primary),
        ),
        message: new Text("You really want to logout from this device?"),
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
  }
}
