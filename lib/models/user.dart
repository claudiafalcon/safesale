import 'package:safesale/models/alert.dart';
import 'package:safesale/models/location.dart';
import 'package:safesale/models/userfav.dart';

class User {
  final String id;
  final List<Alert> alerts;
  final List<Fav> favs;
  final String createdAt;
  final String updatedAt;

  User({this.id, this.alerts, this.favs, this.createdAt, this.updatedAt});

  factory User.fromJson(Map<String, dynamic> data) {
    List<Alert> alerts = <Alert>[];
    List<Fav> favs = <Fav>[];

    if (data["alerts"]["items"] != null) {
      var list = data["alerts"]["items"] as List;
      alerts = list.map((i) => Alert.fromJson(i)).toList();
    }

    if (data["favs"]["items"] != null) {
      var list = data["favs"]["items"] as List;
      favs = list.map((i) => Fav.fromJson(i)).toList();
    }

    return User(
        id: data["id"] as String,
        alerts: alerts,
        favs: favs,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
