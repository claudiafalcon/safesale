import 'package:safesale/models/user.dart';

class Message {
  final String id;
  final User author;
  final String content;
  final String createdAt;
  final String updatedAt;
  Message({this.id, this.author, this.content, this.createdAt, this.updatedAt});

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
        id: data["id"] as String,
        author: data["author"] as User,
        content: data["content"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String);
  }
}
