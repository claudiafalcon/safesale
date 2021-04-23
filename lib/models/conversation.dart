import 'package:intl/intl.dart';
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
  final String scheduler;
  final String schedulerdate;
  final bool unreadMessage;
  final String dateUnreadMessage;

  Conversation(
      {this.id,
      this.messages,
      this.associated,
      this.property,
      this.name,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.scheduler,
      this.schedulerdate,
      this.unreadMessage,
      this.dateUnreadMessage});

  factory Conversation.fromJson(Map<String, dynamic> data) {
    List<Message> messages = <Message>[];
    List<Associated> associated = <Associated>[];
    bool unread = false;
    String stringDate = "En espera";

    if (data["messages"] != null &&
        data["messages"]["items"] != null &&
        data["messages"]["items"].length > 0) {
      unread = true;
      DateTime date = DateTime.parse(data["messages"]["items"][0]["createdAt"]);
      stringDate = DateFormat.MMMd('es_MX').add_Hm().format(date);
    }

    if (data["associated"] != null && data["associated"]["items"] != null) {
      var list = data["associated"]["items"] as List;
      associated = list.map((i) => Associated.fromJson(i)).toList();
    }

    return Conversation(
        id: data["id"] as String,
        scheduler: data["scheduler"] as String,
        schedulerdate: data["schedulerdate"] as String,
        messages: messages,
        associated: associated,
        property: Property.fromJson(data["property"]),
        name: data["name"] == null ? null : data["name"] as String,
        type: data["type"] == null ? null : data["type"] as String,
        unreadMessage: unread,
        dateUnreadMessage: stringDate,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
