import 'package:safesale/models/alert.dart';
import 'package:safesale/models/conversation.dart';
import 'package:safesale/models/device.dart';
import 'package:safesale/models/userfav.dart';

class User {
  final String id;
  final List<Alert> alerts;
  final List<Fav> favs;
  final List<Device> devices;
  final List<Conversation> convs;
  final String createdAt;
  final String updatedAt;

  User(
      {this.id,
      this.alerts,
      this.favs,
      this.devices,
      this.convs,
      this.createdAt,
      this.updatedAt});

  factory User.fromJson(Map<String, dynamic> data) {
    List<Alert> alerts = <Alert>[];
    List<Fav> favs = <Fav>[];
    List<Device> devices = <Device>[];
    List<Conversation> convs = <Conversation>[];

    if (data["alerts"] != null && data["alerts"]["items"] != null) {
      var list = data["alerts"]["items"] as List;
      alerts = list.map((i) => Alert.fromJson(i)).toList();
    }

    if (data["devices"] != null && data["devices"]["items"] != null) {
      var list = data["devices"]["items"] as List;
      devices = list.map((i) => Device.fromJson(i)).toList();
    }

    if (data["favs"] != null && data["favs"]["items"] != null) {
      var list = data["favs"]["items"] as List;
      favs = list.map((i) => Fav.fromJson(i)).toList();
    }

    if (data["conversations"] != null &&
        data["conversations"]["items"] != null) {
      var list = data["conversations"]["items"] as List;
      convs =
          list.map((i) => Conversation.fromJson(i["conversation"])).toList();
    }

    return User(
        id: data["id"] as String,
        alerts: alerts,
        favs: favs,
        devices: devices,
        convs: convs,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
