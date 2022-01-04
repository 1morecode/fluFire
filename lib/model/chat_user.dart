class ChatUser {
  ChatUser({
    required this.id,
    required this.name,
    required this.about,
    required this.image,
    required this.time,
    required this.typingStatus,
    required this.chattingWith
  });

  factory ChatUser.fromMap(Map<String, dynamic> data) {
    return ChatUser(
        id: data['id'], name: data['nickname'], about: data['about'], image: data['photoUrl'], time: data['createdAt'], typingStatus: data['typing_status'], chattingWith: data['chattingWith'] ?? "");
  }

  final String id;
  final String name;
  final String about;
  final String image;
  final String time;
  final String typingStatus;
  final String chattingWith;

}
