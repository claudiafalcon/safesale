class Device {
  final String id;
  final String token;
  final String platform;
  final String vendorId;
  final String createdAt;
  final String updatedAt;
  Device(
      {this.token,
      this.platform,
      this.vendorId,
      this.id,
      this.createdAt,
      this.updatedAt});

  factory Device.fromJson(Map<String, dynamic> data) {
    return Device(
        id: data["id"] as String,
        token: data["token"] as String,
        platform: data["platform"] as String,
        vendorId: data["vendorid"] as String,
        updatedAt:
            data["updatedAt"] == null ? null : data["updatedAt"] as String,
        createdAt:
            data["createdAt"] == null ? null : data["createdAt"] as String);
  }
}
