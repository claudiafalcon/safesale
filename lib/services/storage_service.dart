import 'dart:async';
import 'package:amplify_flutter/amplify.dart';

class StorageService {
  // 1
  final videoUrlsController = StreamController<List<String>>();

  // 2
  void getVideos() async {
    try {
      // 3

      // 8
    } catch (e) {
      print('Storage List error - $e');
    }
  }
}
