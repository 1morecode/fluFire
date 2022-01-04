import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalData {
  static DateFormat dateFormat = DateFormat("h:mm a");

  static final GlobalObjectKey<ScaffoldState> scaffoldKey =
      GlobalObjectKey(ScaffoldState);

  static final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  static String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  // static String googleApiKey = "AIzaSyBQ-AWcWaBtDbDMVoPjEBfLSNr6kHL3oG4";
  static String googleApiKey = "AIzaSyC5m-C32piW2yiT3kevVbvLfHXsLsPTWik";
  static String emailPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static void showSnackBar(String message, BuildContext context, Color color) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: new Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          new SizedBox(
            width: 5,
          ),
          new Text(
            "$message",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: 1),
    ));
    // showSimpleNotification(
    //   Card(
    //     shape: RoundedRectangleBorder(
    //         side: BorderSide(color: colorScheme.onSurface, width: 1,),
    //         borderRadius: BorderRadius.circular(5)
    //     ),
    //     margin: EdgeInsets.all(0),
    //     color: color,
    //     child: Padding(
    //       padding: const EdgeInsets.all(10.0),
    //       child: new Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           new Icon(Icons.info_outline, color: Colors.white, size: 24,),
    //           new SizedBox(width: 15,),
    //           new Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               new Text("$message", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    //   position: NotificationPosition.bottom,
    //   slideDismissDirection: DismissDirection.horizontal,
    //   duration: Duration(milliseconds: 1000),
    //   background: Colors.transparent,
    // );
  }

  static int currentEpisodeTapped = 0;

  static String getTimeFromDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigits(duration.inHours) == "00") {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  static showBottomSnackBar(context, text, icon, color) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: new Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          new SizedBox(
            width: 5,
          ),
          new Text(
            "$text",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.fixed,
    ));
  }

  static showAlertDialog(context, title, desc){
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(desc),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  static getSortName(String name) {
    List<String> namesList = name.split(" ");
    String sortName = name;
    if (namesList.length > 0) {
      if (namesList.length > 1) {
        sortName = "${namesList[0]} ${namesList[1][0]}.";
      }
    }
    return sortName;
  }

  static Future<String> uploadFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String url = '';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    await uploadTask.then((res) async {
      res.ref.getDownloadURL();
      url = await res.ref.getDownloadURL();
    });
    return url;
  }
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}
