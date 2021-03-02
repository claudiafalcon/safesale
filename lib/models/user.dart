import 'package:safesale/models/alert.dart';
import 'package:safesale/models/location.dart';

class User {
  final String id;
  final List<Alert> alerts;
  final String createdAt;
  final String updatedAt;

  User({this.id, this.alerts, this.createdAt, this.updatedAt});

  factory User.fromJson(Map<String, dynamic> data) {
    List<Alert> alerts = <Alert>[];

    if (data["alerts"]["items"] != null) {
      var list = data["alerts"]["items"] as List;
      alerts = list.map((i) => Alert.fromJson(i)).toList();
    }

    return User(
        id: data["id"] as String,
        alerts: alerts,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
