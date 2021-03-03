import 'package:safesale/models/property.dart';

class Fav {
  final String id;
  final Property property;
  final String createdAt;
  final String updatedAt;
  Fav({this.id, this.property, this.createdAt, this.updatedAt});

  factory Fav.fromJson(Map<String, dynamic> data) {
    return Fav(
        id: data["id"] as String,
        property: Property.fromJson(data["property"]),
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String);
  }
}
