import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/model/conver.dart';

class UnreadCountWidget extends StatefulWidget {
  final Convo convo;

  const UnreadCountWidget({Key? key, required this.convo}) : super(key: key);

  @override
  _UnreadCountWidgetState createState() => _UnreadCountWidgetState();
}

class _UnreadCountWidgetState extends State<UnreadCountWidget> {
  static final FirebaseFirestore _firebaseFirestore =
      FirebaseFirestore.instance;

  @override
  void initState() {
    print("Conv ID ${widget.convo.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return StreamBuilder<QuerySnapshot>(
      stream: getCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          DocumentSnapshot ds = documents.last;
          print("Last Data ${ds.data()}");
          if(ds.data()!["idTo"] == AuthUtil.firebaseAuth.currentUser!.uid){
            List<DocumentSnapshot> li = documents.where((element) => element.data()!["idTo"] == AuthUtil.firebaseAuth.currentUser!.uid && element.data()!["read"] == false).toList();
            print("SDDADAS ${documents.length}");
            return li.length > 0 ? new Container(
              child: new Text(
                "${li.length}",
                style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colorScheme.secondary),
              alignment: Alignment.center,
              height: 20,
              width: 20,
            ) : new Container();
          }else{
            return  Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Icon(CupertinoIcons.checkmark_alt, size: 18, color: ds.data()!["read"] ? colorScheme.primary : colorScheme.secondaryVariant.withOpacity(0.5),),
                ),
                Icon(CupertinoIcons.checkmark_alt, size: 18, color: ds.data()!["read"] ? colorScheme.primary : colorScheme.secondaryVariant.withOpacity(0.5),),
              ],
            );
          }
        } else {
          return new Container();
        }
      },
    );
    // return new Container(
    //   child: new Text("13", style: TextStyle(color: colorScheme.onPrimary, fontSize: 10, fontWeight: FontWeight.w400),),
    //   decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: colorScheme.secondary
    //   ),
    //   alignment: Alignment.center,
    //   height: 20,
    //   width: 20,
    // );
  }

  Stream<QuerySnapshot> getCount() {
     final Stream<QuerySnapshot> result =
         _firebaseFirestore
         .collection("messages")
         .doc("${widget.convo.id}")
             .collection('${widget.convo.id}').snapshots();
    return result;
  }

}
