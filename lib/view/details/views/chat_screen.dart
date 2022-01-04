import 'dart:async';
import 'dart:io';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:message_app/controller/auth_util.dart';
import 'package:message_app/controller/database.dart';
import 'package:message_app/res/global_data.dart';
import 'package:message_app/res/user_token.dart';
import 'package:message_app/view/details/views/image_editor_page.dart';
import 'package:message_app/view/widget/full_photo.dart';

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerName;
  final String peerAvatar;

  ChatScreen(
      {Key? key,
      required this.peerId,
      required this.peerAvatar,
      required this.peerName})
      : super(key: key);

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  late String groupChatId;

  late File imageFile;
  late bool isLoading;
  late bool isShowSticker;
  late String imageUrl;
  late String id;
  bool imageSending = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  CustomPopupMenuController _controller = CustomPopupMenuController();
  late List<ItemModel> menuItems;

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    menuItems = [
      ItemModel('Delete', Icons.delete),
      ItemModel('Report', Icons.report),
    ];
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    id = AuthUtil.firebaseAuth.currentUser!.uid;
    if (id.hashCode <= widget.peerId.hashCode) {
      groupChatId = '$id-${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId}-$id';
    }

    FirebaseFirestore.instance
        .collection('allUsers')
        .doc(id)
        .update({'chattingWith': widget.peerId});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = (await imagePicker.getImage(source: ImageSource.gallery))!;
    imageFile = File(pickedFile.path);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditorPage(
            file: imageFile,
            function: uploadFile,
          ),
        ));
  }

  Future uploadFile(File file) async {
    setState(() {
      isLoading = true;
      imageSending = true;
    });
    String fileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    await uploadTask.then((res) async {
      res.ref.getDownloadURL();
      imageUrl = await res.ref.getDownloadURL();
      setState(() {
        onSendMessage(imageUrl, 1);
      });
    });
  }

  // Send Messages
  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      final DocumentReference messageDoc = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          messageDoc,
          {
            'idFrom': id,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false,
            'type': type,
            'deleted': false
          },
        );
      }).then((dynamic success) {
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        final DocumentReference documentReference =
            FirebaseFirestore.instance.collection('messages').doc(groupChatId);

        documentReference.set(<String, dynamic>{
          'hiddenBy': [],
          'lastMessage': <String, dynamic>{
            'idFrom': id,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'read': false,
            'type': type,
            'deleted': false
          },
          'users': <String>[id, widget.peerId]
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Nothing to send!");
    }
    listScrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    setState(() {
      isLoading = false;
    });
    // sendNotification(content, id);
    // sendMsgNotification(content, type);
  }

  // One Signal
  // sendMsgNotification(content, int type) async {
  //   DocumentSnapshot documentReference = await FirebaseFirestore.instance
  //       .collection('allUsers')
  //       .doc(AuthUtil.firebaseAuth.currentUser!.uid).get();
  //   if(documentReference.data()['message_alert']){
  //     String playerId = await FCMNotification.getToken(widget.peerId, "message");
  //     print("Player Id ${widget.peerId}  $playerId");
  //     if (playerId.isNotEmpty) {
  //       try {
  //         var notification = OSCreateNotification(
  //             playerIds: [playerId],
  //             content: type != 1 ? content : "Picture",
  //             heading: '${AuthUtil.firebaseAuth.currentUser!.displayName}',
  //             bigPicture: type == 1 ? content : "",
  //             additionalData: {
  //               'type': "chatUser",
  //               'via': '$id',
  //               'count': '1',
  //               'id': '$id',
  //               'name': '${AuthUtil.firebaseAuth.currentUser!.displayName}',
  //               'image': '${AuthUtil.firebaseAuth.currentUser!.photoURL}'
  //             });
  //         var response = await OneSignal.shared.postNotification(notification);
  //         print("Notification Response $response");
  //       } catch (e) {
  //         print("Send Mesg Not Exc $e");
  //       }
  //     }
  //   }
  // }

  // sendNotification(content, id) async {
  //   var postUrl = "https://fcm.googleapis.com/fcm/send";
  //   print("PEER ID $peerId");
  //   try {
  //     var token = await getToken(peerId);
  //     print('token 2 : $token');
  //     var data = {
  //       'to': token,
  //       'data': {
  //         'type': "chatUser",
  //         'via': '$id',
  //         'count': '1',
  //         'id': '${AuthUtil.firebaseAuth.currentUser.displayName}',
  //         'name': '${AuthUtil.firebaseAuth.currentUser.displayName}',
  //         'image': '${AuthUtil.firebaseAuth.currentUser.photoURL}'
  //       },
  //       'notification': {
  //         'title': '${AuthUtil.firebaseAuth.currentUser.displayName}',
  //         'body': '$content',
  //       }
  //     };
  //     print("Payload $data");
  //     String serverKey =
  //         "	AAAAE_8ior0:APA91bG2N57gOpbkuy08TgGLJ7lwk-m8n4OuvqsWe6iKkz7qhJH7Ie7dYmTlGi-3Hp3zaRxDiZWw6prnQS4ewifhtXeocE8zpgIJ0sPjmjiMjM9wq2pMMXvugKeV4gEYSQsuotqOvGBf";
  //     final headers = {
  //       'content-type': 'application/json',
  //       'Authorization': 'key=$serverKey'
  //     };
  //
  //     var response = await http.post(
  //       Uri.parse('$postUrl'),
  //       headers: headers,
  //       body: jsonEncode(data),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('notification send success ${response.body}');
  //     } else {
  //       print('notification sending failed ${response.body}');
  //       // on failure do sth
  //     }
  //   } catch (e) {
  //     print('exception ${e.toString()}');
  //   }
  // }

  // Upload Image
  _buildUploadingImage() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            child: Container(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(colorScheme.onSurface),
              ),
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(70.0),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(0)),
              ),
            ),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(0)),
            clipBehavior: Clip.hardEdge,
          ),
          new Container(
            height: 25,
          )
        ],
      ),
    );
  }

  // Message item
  Widget buildItem(int index, DocumentSnapshot document) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (document.data()!['idFrom'] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document.data()!['deleted'] == false
              ? document.data()!['type'] == 0
                  // Text
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomPopupMenu(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 20,
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            child: Container(
                              child: Text(
                                document.data()!['content'],
                                style: TextStyle(
                                    color: colorScheme.onSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: colorScheme.onSurface,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(0))),
                            ),
                          ),
                          menuBuilder: () =>
                              _buildLongPressDeleteMenu(document),
                          barrierColor: Colors.transparent,
                          pressType: PressType.longPress,
                          arrowColor: colorScheme.onSurface,
                          arrowSize: 21,
                          controller: _controller,
                        ),
                        new Container(
                          child: new Row(
                            children: [
                              getTime(document.data()!['timestamp']),
                              new SizedBox(
                                width: 5,
                              ),
                              document.data()!['read']
                                  ? new Icon(
                                      Icons.check_circle,
                                      color: colorScheme.primary,
                                      size: 10,
                                    )
                                  : new Icon(
                                      Icons.check_circle_outline,
                                      color: colorScheme.secondaryVariant,
                                      size: 10,
                                    )
                            ],
                          ),
                          margin: EdgeInsets.only(
                              bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                              right: 0.0,
                              top: 5.0),
                        ),
                      ],
                    )
                  : document.data()!['type'] == 1
                      // Image
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomPopupMenu(
                              child: Container(
                                child: FlatButton(
                                  child: Material(
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  colorScheme.onSurface),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        padding: EdgeInsets.all(70.0),
                                        decoration: BoxDecoration(
                                          color: colorScheme.onSurface,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(0)),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Material(
                                        child: Image.asset(
                                          'assets/images/img_not_available.jpeg',
                                          width: 200.0,
                                          height: 200.0,
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(0)),
                                        clipBehavior: Clip.hardEdge,
                                      ),
                                      imageUrl: document.data()!['content'],
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(0)),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FullPhoto(
                                                url: document
                                                    .data()!['content'])));
                                  },
                                  padding: EdgeInsets.all(0),
                                ),
                              ),
                              menuBuilder: () =>
                                  _buildLongPressDeleteMenu(document),
                              barrierColor: Colors.transparent,
                              pressType: PressType.longPress,
                              arrowColor: colorScheme.onSurface,
                              arrowSize: 21,
                              controller: _controller,
                            ),
                            new Container(
                              child: new Row(
                                children: [
                                  getTime(document.data()!['timestamp']),
                                  new SizedBox(
                                    width: 5,
                                  ),
                                  document.data()!['read']
                                      ? new Icon(
                                          Icons.check_circle,
                                          color: colorScheme.primary,
                                          size: 10,
                                        )
                                      : new Icon(
                                          Icons.check_circle_outline,
                                          color: colorScheme.secondaryVariant,
                                          size: 10,
                                        )
                                ],
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      isLastMessageRight(index) ? 10.0 : 5.0,
                                  right: 0.0,
                                  top: 5.0),
                            ),
                          ],
                        )
                      // Sticker
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomPopupMenu(
                              child: Container(
                                child: Image.asset(
                                  'assets/images/${document.data()!['content']}.gif',
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              menuBuilder: () =>
                                  _buildLongPressDeleteMenu(document),
                              barrierColor: Colors.transparent,
                              pressType: PressType.longPress,
                              arrowColor: colorScheme.onSurface,
                              arrowSize: 21,
                              controller: _controller,
                            ),
                            new Container(
                              child: new Row(
                                children: [
                                  getTime(document.data()!['timestamp']),
                                  new SizedBox(
                                    width: 5,
                                  ),
                                  document.data()!['read']
                                      ? new Icon(
                                          Icons.check_circle,
                                          color: colorScheme.primary,
                                          size: 10,
                                        )
                                      : new Icon(
                                          Icons.check_circle_outline,
                                          color: colorScheme.secondaryVariant,
                                          size: 10,
                                        )
                                ],
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      isLastMessageRight(index) ? 10.0 : 5.0,
                                  right: 0.0,
                                  top: 5.0),
                            ),
                          ],
                        )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Text(
                        "Deleted Message",
                        style: TextStyle(
                            color: colorScheme.secondaryVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: colorScheme.error.withOpacity(0.3),
                          border: Border.all(
                              color: colorScheme.error.withOpacity(0.6),
                              width: 1),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(0))),
                    ),
                    new Container(
                      child: new Row(
                        children: [
                          getTime(document.data()!['timestamp']),
                          new SizedBox(
                            width: 5,
                          ),
                          document.data()!['read']
                              ? new Icon(
                                  Icons.check_circle,
                                  color: colorScheme.primary,
                                  size: 10,
                                )
                              : new Icon(
                                  Icons.check_circle_outline,
                                  color: colorScheme.secondaryVariant,
                                  size: 10,
                                )
                        ],
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                          right: 0.0,
                          top: 5.0),
                    ),
                  ],
                )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      Database.updateMessageRead(document, groupChatId);
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                document.data()!['deleted'] == false
                    ? document.data()!['type'] == 0
                        // Text
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomPopupMenu(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      minWidth: 20,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7),
                                  child: Container(
                                    child: Text(
                                      document.data()!['content'],
                                      style: TextStyle(
                                          color: colorScheme.onSecondary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: colorScheme.secondaryVariant
                                            .withOpacity(0.3),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(0),
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                  ),
                                ),
                                menuBuilder: () =>
                                    _buildLongPressReportMenu(document),
                                barrierColor: Colors.transparent,
                                pressType: PressType.longPress,
                                arrowColor: colorScheme.onSurface,
                                arrowSize: 21,
                                controller: _controller,
                              ),
                              new Container(
                                child: getTime(document.data()!['timestamp']),
                                margin: EdgeInsets.only(
                                    bottom:
                                        isLastMessageRight(index) ? 10.0 : 5.0,
                                    right: 0.0,
                                    top: 5.0),
                              ),
                            ],
                          )
                        : document.data()!['type'] == 1
                            // Image
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomPopupMenu(
                                    child: Container(
                                      child: FlatButton(
                                        child: Material(
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        colorScheme.onSurface),
                                              ),
                                              width: 200.0,
                                              height: 200.0,
                                              padding: EdgeInsets.all(70.0),
                                              decoration: BoxDecoration(
                                                  color: colorScheme.secondaryVariant
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Material(
                                              child: Image.asset(
                                                'assets/images/img_not_available.jpeg',
                                                width: 200.0,
                                                height: 200.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(0),
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              clipBehavior: Clip.hardEdge,
                                            ),
                                            imageUrl:
                                                document.data()!['content'],
                                            width: 200.0,
                                            height: 200.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(0),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullPhoto(
                                                          url: document.data()![
                                                              'content'])));
                                        },
                                        padding: EdgeInsets.all(0),
                                      ),
                                    ),
                                    menuBuilder: () =>
                                        _buildLongPressReportMenu(document),
                                    barrierColor: Colors.transparent,
                                    pressType: PressType.longPress,
                                    arrowColor: colorScheme.onSurface,
                                    arrowSize: 21,
                                    controller: _controller,
                                  ),
                                  new Container(
                                    child:
                                        getTime(document.data()!['timestamp']),
                                    margin: EdgeInsets.only(
                                        bottom: isLastMessageRight(index)
                                            ? 10.0
                                            : 5.0,
                                        right: 0.0,
                                        top: 5.0),
                                  ),
                                ],
                              )
                            // Sticker
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomPopupMenu(
                                    child: Container(
                                      child: Image.asset(
                                        'assets/images/${document.data()!['content']}.gif',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    menuBuilder: () =>
                                        _buildLongPressReportMenu(document),
                                    barrierColor: Colors.transparent,
                                    pressType: PressType.longPress,
                                    arrowColor: colorScheme.onSurface,
                                    arrowSize: 21,
                                    controller: _controller,
                                  ),
                                  new Container(
                                    child:
                                        getTime(document.data()!['timestamp']),
                                    margin: EdgeInsets.only(
                                        bottom: isLastMessageRight(index)
                                            ? 10.0
                                            : 5.0,
                                        right: 0.0,
                                        top: 5.0),
                                  ),
                                ],
                              )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "Deleted Message",
                              style: TextStyle(
                                  color: colorScheme.error,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                                color: colorScheme.secondaryVariant
                                .withOpacity(0.6),
                                border: Border.all(
                                    color: colorScheme.error.withOpacity(0.6),
                                    width: 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(0),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                          ),
                          new Container(
                            child: getTime(document.data()!['timestamp']),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 10.0 : 5.0,
                                right: 0.0,
                                top: 5.0),
                          ),
                        ],
                      ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget _buildLongPressDeleteMenu(DocumentSnapshot document) {
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
                Database.deleteMessage(document, groupChatId);
                GlobalData.showBottomSnackBar(
                    context,
                    "Message Deleted Successfully!",
                    Icons.check_circle,
                    Colors.green);
              })),
    );
  }

  Widget _buildLongPressReportMenu(DocumentSnapshot document) {
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
                    Icons.report,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  new SizedBox(
                    width: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Text(
                      "Report",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                _controller.hideMenu();
                GlobalData.showBottomSnackBar(
                    context,
                    "Message Reported Successfully!",
                    Icons.check_circle,
                    Colors.green);
              })),
    );
  }

  getTime(time) {
    return Text(
      DateFormat('dd MMM h:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(time)),
      ),
      style: TextStyle(
          fontSize: 8, color: Theme.of(context).colorScheme.secondaryVariant),
    );
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('allUsers')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Column(
        children: <Widget>[
          // List of messages
          buildListMessage(),
          // Sticker
          // (isShowSticker ? buildSticker() : Container()),
          new Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: isLoading || imageSending
                ? _buildUploadingImage()
                : Container(),
          ),
          // Input content
          buildInput()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildInput() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      // constraints: BoxConstraints(minHeight: 50),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.attach_file_rounded,
              color: colorScheme.secondaryVariant,
            ),
            onPressed: getImage,
          ),
          Container(
            height: 40,
            width: 1,
            color: colorScheme.onPrimary,
          ),
          Expanded(
            child: Scrollbar(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 40,
                ),
                child: CupertinoTextField(
                  autocorrect: true,
                  maxLines: 6,
                  minLines: 1,
                  placeholder: "Enter message...",
                  showCursor: true,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  cursorColor: colorScheme.onSecondary,
                  controller: textEditingController,
                  focusNode: focusNode,
                  onChanged: (val){
                    UserToken.updateTypingTime();
                  },
                  style:
                      TextStyle(fontSize: 16, color: colorScheme.onSecondary),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
          new SizedBox(
            width: 5,
          ),
          // Button send message
          CupertinoButton(
            child: Icon(
              Icons.send,
              color: colorScheme.onSecondary,
            ),
            onPressed: () => onSendMessage(textEditingController.text, 0),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          ),
        ],
      ),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: colorScheme.onSurface,
                  width: 0.5),
              ),
          color: colorScheme.onPrimary),
    );
  }

  // Messages List
  Widget buildListMessage() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Flexible(
      child: groupChatId == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(colorScheme.onSurface)))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onSurface)));
                } else {
                  listMessage.addAll(snapshot.data!.docs);
                  imageSending = false;
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: false,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data!.docs[index]),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
}
