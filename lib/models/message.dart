import 'package:safesale/models/user.dart';

class Message {
  final String id;
  final String authorId;
  final String content;
  final String createdAt;
  final String updatedAt;
  final bool unread;
  Message(
      {this.id,
      this.authorId,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.unread});

  factory Message.fromJson(Map<String, dynamic> data) {
    return Message(
        id: data["id"] as String,
        unread: data["unread"] as bool,
        authorId: data["authorId"] as String,
        content: data["content"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String);
  }
}
