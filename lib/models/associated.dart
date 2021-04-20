import 'package:safesale/models/alert.dart';
import 'package:safesale/models/device.dart';
import 'package:safesale/models/user.dart';
import 'package:safesale/models/userfav.dart';

class Associated {
  final String id;
  final User user;
  final String guestemail;
  final String createdAt;
  final String updatedAt;

  Associated(
      {this.id, this.user, this.guestemail, this.createdAt, this.updatedAt});

  factory Associated.fromJson(Map<String, dynamic> data) {
    return Associated(
        id: data["id"] as String,
        user: data["user"],
        guestemail: data["guestmail"],
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String);
  }
}
