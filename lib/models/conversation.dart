import 'package:safesale/models/associated.dart';
import 'package:safesale/models/message.dart';
import 'package:safesale/models/property.dart';

class Conversation {
  final String id;
  final List<Message> messages;
  final List<Associated> associated;
  final Property property;
  final String name;
  final String type;
  final String createdAt;
  final String updatedAt;

  Conversation(
      {this.id,
      this.messages,
      this.associated,
      this.property,
      this.name,
      this.type,
      this.createdAt,
      this.updatedAt});

  factory Conversation.fromJson(Map<String, dynamic> data) {
    List<Message> messages = <Message>[];
    List<Associated> associated = <Associated>[];

    if (data["messages"] != null && data["messages"]["items"] != null) {
      var list = data["messages"]["items"] as List;
      messages = list.map((i) => Message.fromJson(i)).toList();
    }

    if (data["associated"] != null && data["associated"]["items"] != null) {
      var list = data["associated"]["items"] as List;
      associated = list.map((i) => Associated.fromJson(i)).toList();
    }

    return Conversation(
        id: data["id"] as String,
        messages: messages,
        associated: associated,
        property: data["property"],
        name: data["name"] == null ? null : data["name"] as String,
        type: data["type"] == null ? null : data["type"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
