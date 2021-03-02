import 'package:safesale/models/searchcriterio.dart';

class Alert {
  final String id;
  final SearchCriterio criterio;
  final String createdAt;
  final String updatedAt;
  Alert({this.id, this.criterio, this.createdAt, this.updatedAt});

  factory Alert.fromJson(Map<String, dynamic> data) {
    return Alert(
        id: data["id"] as String,
        criterio: SearchCriterio.fromJson(data),
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String);
  }
}
