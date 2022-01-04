import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:message_app/controller/database.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/res/date_difference.dart';
import 'package:message_app/view/details/views/chat_screen.dart';

class ChatUserDetails extends StatelessWidget {
  final ChatUser document;

  ChatUserDetails({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    print("Docs ${document.name}");
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        elevation: 2,
        shadowColor: colorScheme.onPrimary,
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
        titleSpacing: 5,
        title: CupertinoButton(
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
                    width: 35.0,
                    height: 35.0,
                  ),
                  imageUrl: document.image,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '${document.name}',
                          style: TextStyle(color: colorScheme.onSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      StreamBuilder<ChatUser>(
                        stream: Database.getUsersById(document.id),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Container(
                              child: Text(
                                MyDateFormat.getTypingStatus(snapshot.data!.typingStatus, snapshot.data!.chattingWith) ? "Typing..." : MyDateFormat.getOnlineTimeStatus(snapshot.data!.time) == "Online" ? "🟢 Online" : 'Last Seen: ${MyDateFormat.getOnlineTimeStatus(snapshot.data!.time)}',
                                style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 10, fontWeight: FontWeight.w400),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            );
                          }else{
                            return Container(
                              child: Text(
                                MyDateFormat.getOnlineTimeStatus(document.time) == "Online" ? "🟢 Online" : 'Last Seen: ${MyDateFormat.getOnlineTimeStatus(document.time)}',
                                style: TextStyle(color: colorScheme.secondaryVariant, fontSize: 10, fontWeight: FontWeight.w400),
                              ),
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                            );
                          }
                        },)
                    ],
                  ),
                ),
              ),
            ],
          ),
          onPressed: (){
          },
          padding: EdgeInsets.all(0),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ChatScreen(
          peerId: document.id,
          peerAvatar: document.image,
          peerName: document.name,
        ),
      ),
    );
  }
}
