import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:message_app/controller/database.dart';
import 'package:message_app/model/chat_user.dart';
import 'package:message_app/model/conver.dart';
import 'package:message_app/res/date_difference.dart';
import 'package:message_app/res/global_data.dart';
import 'package:message_app/view/details/user_details.dart';
import 'package:message_app/view/widget/unread_count_widget.dart';

class ConvoListItem extends StatefulWidget {
  ConvoListItem(
      {Key? key,
      required this.user,
      required this.convo,
      required this.peer,
      required this.lastMessage})
      : super(key: key);

  final User user;
  final ChatUser peer;
  final Convo convo;
  Map<dynamic, dynamic> lastMessage;

  @override
  _ConvoListItemState createState() => _ConvoListItemState();
}

class _ConvoListItemState extends State<ConvoListItem> {

  late bool read;

  CustomPopupMenuController _controller = CustomPopupMenuController();

  List<ItemModel> menuItems = [
    ItemModel('Delete', Icons.delete),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.lastMessage['idFrom'] == widget.user.uid) {
      read = true;
    } else {
      read = widget.lastMessage['read'] == null ? true : widget.lastMessage['read'];
    }
    // groupId = getGroupChatId();

    return buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 20,
          maxWidth:
          MediaQuery.of(context).size.width * 0.7),
      child: new Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 1.0),
            child: CupertinoButton(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              borderRadius: BorderRadius.circular(0),
              color: colorScheme.onPrimary,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ChatUserDetails(
                      document: widget.peer,
                    )));
              },
              child: buildConvoDetails(widget.peer, context, widget.convo),
            ),
          ),
          new Row(
            children: [
              new Container(width: 80,),
              Expanded(child: Divider(color: colorScheme.onSurface, thickness: 1, height: 1,))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLongPressDeleteMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
          width: 120,
          color: Theme.of(context).colorScheme.onSurface,
          child: new CupertinoButton(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.delete,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Text(
                      "Delete",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _controller.hideMenu();
                Database.removeConvUser(widget.convo);
              })),
    );
  }

  Widget buildConvoDetails(
      ChatUser chatUser, BuildContext context, Convo convo) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        new Stack(
          alignment: Alignment.bottomRight,
          children: [
            new Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: colorScheme.onSurface,
              ),
              padding: EdgeInsets.all(3),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: colorScheme.onSurface,
                backgroundImage: NetworkImage("${chatUser.image}"),
              ),
            ),
            isOnline(widget.peer.time) == 0
                ? new Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: colorScheme.onSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 1)
              ),
              padding: EdgeInsets.all(1),
              child: new CircleAvatar(
                radius: 3,
                backgroundColor: colorScheme.primary,
              ),
            ) : isOnline(widget.peer.time) == 1 ? new Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: colorScheme.onSecondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary, width: 1)
              ),
              padding: EdgeInsets.all(1),
            )
                : new Container(
              height: 0,
              width: 0,
            )
          ],
        ),
        Expanded(
          child: Container(
            child: Column(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          '${chatUser.name}',
                          style: TextStyle(
                              color: colorScheme.onSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ),
                    new SizedBox(
                      width: 5,
                    ),
                    new Text(
                      "${getTime(widget.lastMessage['timestamp'])}",
                      style: TextStyle(
                          color: colorScheme.secondaryVariant,
                          fontSize: 10,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          MyDateFormat.getTypingStatus(chatUser.typingStatus, chatUser.chattingWith) ? "Typing..." : widget.lastMessage['type'] == 1
                              ? widget.lastMessage['idTo'] != "${chatUser.id}"
                                  ? '📁 Media File'
                                  : 'You: 📁 Media File'
                              : widget.lastMessage['type'] == 2
                                  ? widget.lastMessage['idTo'] != "${chatUser.id}"
                                      ? '🔖 Sticker'
                                      : 'You: 🔖 Sticker'
                                  : widget.lastMessage['idTo'] != "${chatUser.id}"
                                      ? '${widget.lastMessage['content']}'
                                      : 'You: ${widget.lastMessage['content']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorScheme.secondaryVariant,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                      ),
                    ),
                    new SizedBox(
                      width: 5,
                    ),
                    UnreadCountWidget(
                      convo: convo,
                    )
                  ],
                ),
              ],
            ),
            margin: EdgeInsets.only(left: 5.0),
          ),
        ),
      ],
    );
  }

  String getTime(String timestamp) {
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    DateFormat format;
    if (dateTime.difference(DateTime.now()).inMilliseconds <= 86400000) {
      format = DateFormat('jm');
    } else {
      format = DateFormat.yMd('en_US');
    }
    return format
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)));
  }

  int isOnline(String timestamp) {
    final birthday = DateTime.now();
    final date2 = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    final difference = birthday.difference(date2).inMinutes;
    if (difference <= 1 && date2.second <= birthday.second) {
      return 0;
    } else if(difference < 5 && date2.second <= birthday.second) {
      return 1;
    } else {
      return 2;
    }
  }

  String getGroupChatId() {
    if (widget.user.uid.hashCode <= widget.peer.id.hashCode) {
      return widget.user.uid + '_' + widget.peer.id;
    } else {
      return widget.peer.id + '_' + widget.user.uid;
    }
  }
}
