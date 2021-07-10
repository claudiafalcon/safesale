import 'dart:async' show StreamController;
import 'dart:io';

import 'package:safesale/variables.dart';
import 'package:connectivity/connectivity.dart';

// 1
enum InternetConnectionFlowStatus { offline, online, checking }

// 2
class InternetConnectionState {
  final InternetConnectionFlowStatus internetConnectionFlowStatus;
  InternetConnectionState({this.internetConnectionFlowStatus});
}

final Connectivity _connectivity = Connectivity();

// 3
class InternetConnectionService {
  // 4
  final connectionStateController = StreamController<InternetConnectionState>();

  void checkConnection() async {
    // _connectivity.onConnectivityChanged.listen(_connectionChange);

    var state = InternetConnectionState(
        internetConnectionFlowStatus: InternetConnectionFlowStatus.checking);
    connectionStateController.add(state);
    state = InternetConnectionState(
        internetConnectionFlowStatus: InternetConnectionFlowStatus.offline);
    try {
      final result = await InternetAddress.lookup("example.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        state = InternetConnectionState(
            internetConnectionFlowStatus: InternetConnectionFlowStatus.online);
      }
      connectionStateController.add(state);
    } on SocketException catch (_) {
      connectionStateController.add(state);
    }
  }
}
