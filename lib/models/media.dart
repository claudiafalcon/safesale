import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_flutter/amplify.dart';

class Media {
  final String region;
  final String key;
  final String bucket;
  String url;

  Media({this.region, this.key, this.bucket, this.url});

  static Future<String> getURL(String key) async {
    try {
      GetUrlResult result = await Amplify.Storage.getUrl(key: key);
      return result.url;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  factory Media.fromJson(Map<String, dynamic> data) {
    return Media(
      region: data["region"] as String,
      key: data["key"] as String,
      bucket: data["bucket"],
    );
  }
}
