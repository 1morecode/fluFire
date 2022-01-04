import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/view/details/user_details.dart';

class UserSearchCard extends StatefulWidget {
  final ChatUser document;
  const UserSearchCard({Key? key, required this.document}) : super(key: key);

  @override
  _UserSearchCardState createState() => _UserSearchCardState();
}

class _UserSearchCardState extends State<UserSearchCard> {

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: CupertinoButton(
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: colorScheme.onSurface
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
                  ),
                  width: 50.0,
                  height: 50.0,
                  padding: EdgeInsets.all(15.0),
                ),
                imageUrl: widget.document.image,
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        '${widget.document.name}',
                        style: TextStyle(color: colorScheme.onSecondary, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                    ),
                    Container(
                      child: Text(
                        'Last Seen',
                        style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 5.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatUserDetails(
                    document: widget.document,
                  )));
        },
        color: colorScheme.onPrimary,
        padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.only(bottom: 1.0),
    );
  }
}
