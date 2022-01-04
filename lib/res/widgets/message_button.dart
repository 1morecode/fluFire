//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:vocal/modules/chat/database/database.dart';
// import 'package:vocal/modules/chat/details/user_details.dart';
// import 'package:vocal/modules/chat/model/chat_user.dart';
//
// class MessageButton extends StatefulWidget {
//   final String uid;
//   final Color btnColor;
//   final TextStyle textStyle;
//
//   MessageButton({this.uid, this.btnColor, this.textStyle});
//
//   @override
//   _MessageButtonState createState() => _MessageButtonState();
// }
//
// class _MessageButtonState extends State<MessageButton> {
//
//   @override
//   void initState() {
//     print("UU ${widget.uid}");
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ColorScheme colorScheme = Theme.of(context).colorScheme;
//     Size size = MediaQuery.of(context).size;
//     return StreamBuilder<ChatUser>(
//       stream: Database.getUsersById(widget.uid),
//       builder: (context, snapshot) {
//       if(snapshot.hasData){
//         return CupertinoButton(
//             minSize: 30,
//             color: colorScheme.onSurface,
//             padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//             child: new Text(
//               "Message",
//               style: widget.textStyle != null
//                   ? widget.textStyle
//                   : TextStyle(
//                   color: colorScheme.onSecondary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400),
//             ),
//             onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context) => ChatUserDetails(document: snapshot.data,),));
//             });
//       }else{
//         return CupertinoButton(
//             minSize: 30,
//             color: colorScheme.onSurface,
//             padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//             child: new Text(
//               "Message",
//               style: widget.textStyle != null
//                   ? widget.textStyle
//                   : TextStyle(
//                   color: colorScheme.onSecondary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400),
//             ),
//             onPressed: (){});
//       }
//     },);
//   }
// }
