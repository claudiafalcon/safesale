import 'dart:ffi';

class Location {
  final double lon;
  final double lat;

  Location({this.lon, this.lat});

  factory Location.fromJson(Map<String, dynamic> data) {
    return Location(
        lon: data["lon"] is int
            ? (data["lon"] as int).toDouble()
            : data["lon"] as double,
        lat:
            data["lat"] is int ? (data["lat"] as int).toDouble() : data["lat"]);
  }
}
