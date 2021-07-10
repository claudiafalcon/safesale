import 'dart:async' show StreamController;
import 'dart:convert';

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/services.dart';

import 'package:safesale/graphql/authqueries.dart';
import 'package:safesale/models/device.dart';
import 'package:safesale/models/searchcriterio.dart';
import 'package:safesale/models/user.dart';

import 'package:safesale/models/userfav.dart';
import 'package:device_info/device_info.dart';

import 'package:safesale/amplifyconfiguration.dart';

enum UserFlowStatus { started, finalized, error, empty }

class UserState {
  final UserFlowStatus userFlowStatus;

  UserState({this.userFlowStatus});
}

class UserService {
  static final UserService _userService = UserService._internal();

  static final String genericEmail = "no-reply@safesaleonline.com";

  User _user;

  UserService._internal();

  Future<String> _getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    String token;

    print('User granted permission: ${settings.authorizationStatus}');

    token = await messaging.getToken();

    return token;
  }

  Future<void> _addDevice(
      String deviceId, String token, String platform) async {
    try {
      // final state = UserState(userFlowStatus: UserFlowStatus.started);
      //userStateController.add(state);

      if (_user == null) {
        await initUser();
      }

      try {
        var operation = Amplify.API.mutate(
            request:
                GraphQLRequest<String>(document: m_createDevice, variables: {
          'deviceOwnerId': _user.id,
          'platform': platform,
          'token': token,
          'vendorid': deviceId
        }));

        var response = await operation.response;
        var data = response.data;

        print('Mutation result: ' + data);
        await updateUser(_user.id);
      } on ApiException catch (e) {
        print('Mutation failed: $e');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _deleteDevice(String id) async {
    try {
      if (_user == null) await initUser();
      Device device = _user.devices
          .firstWhere((element) => element.vendorId == id, orElse: () {
        return null;
      });

      if (device != null) {
        var operation = Amplify.API.mutate(
            request: GraphQLRequest<String>(
                document: m_deleteDevice, variables: {'id': device.id}));

        var response = await operation.response;
        var data = response.data;
        await updateUser(_user.id);

        print('Mutation result: ' + data);
      }
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<void> refreshUser() async {
    initUser();
    return null;
  }

  Future<void> refreshToken(String token) async {
    await initUser();
    if (_user != null) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      Map<String, dynamic> deviceData = <String, dynamic>{};
      String deviceId;

      String platform = 'unknown';
      try {
        if (Platform.isAndroid) {
          deviceData =
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
          deviceId = deviceData["androidId"];
          platform = 'android';
        } else if (Platform.isIOS) {
          deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
          deviceId = deviceData["identifierForVendor"];
          platform = 'ios';
        }
        await _updateTokenDevice(deviceId, token, platform);
      } on PlatformException {
        deviceData = <String, dynamic>{
          'Error:': 'Failed to get platform version.'
        };
      }
    }
    return null;
  }

  Future<void> _updateTokenDevice(
      String deviceId, String token, String platform) async {
    try {
      Device device = _user.devices
          .firstWhere((element) => element.vendorId == deviceId, orElse: () {
        _addDevice(deviceId, token, platform);
        updateUser(_user.id);
        return null;
      });
      if (device != null) {
        var operation = Amplify.API.mutate(
            request: GraphQLRequest<String>(
                document: m_updateDevice,
                variables: {'token': token, 'id': device.id}));

        var response = await operation.response;
        var data = response.data;
        await updateUser(_user.id);

        print('Mutation result: ' + data);
      }
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
    return null;
  }

  Future<void> initPlatformState() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    String deviceId;
    String token;
    String platform = 'unknown';
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceId = deviceData["androidId"];
        platform = 'android';
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        deviceId = deviceData["identifierForVendor"];
        platform = 'ios';
      }
      token = await _getToken();
      await _updateTokenDevice(deviceId, token, platform);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  List<User> parseUsers(List jsonList) {
    return jsonList.map<User>((json) => User.fromJson(json)).toList();
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Future<User> getUserByUsername(String username) async {
    User user;
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      if (!res.isSignedIn) {
        var amplifyconfigJson = jsonDecode(amplifyconfig);
        final endpoint = amplifyconfigJson["api"]["plugins"]["awsAPIPlugin"]
            ["safesalesearch"]["endpoint"];
        final region = amplifyconfigJson["api"]["plugins"]["awsAPIPlugin"]
            ["safesalesearch"]["region"];
        final awsSigV4Client = new AwsSigV4Client(res.credentials.awsAccessKey,
            res.credentials.awsSecretKey, endpoint,
            serviceName: 'appsync',
            sessionToken: res.credentials.sessionToken,
            region: region);
        final signedRequest = new SigV4Request(awsSigV4Client,
            method: 'POST',
            path: '',
            headers: new Map<String, String>.from(
                {'Content-Type': 'application/graphql; charset=utf-8'}),
            body: new Map<String, Object>.from({
              'query': q_getuserbyusername,
              'variables': {"username": username}
            }));
        http.Response response;
        try {
          response = await http.post(Uri.parse(signedRequest.url),
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final List parsedList =
            json.decode(response.body)["data"]["listUsers"]["items"];
        if (parsedList.length == 0) return null;
        return parseUsers(parsedList)[0];
      } else {
        return getUserByUsernameSigned(username);
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<User> getUserByUsernameSigned(String username) async {
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(
              document: q_getuserbyusername,
              variables: {'username': username}));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;
        final List parsedList = json.decode(data)["listUsers"]["items"];
        if (parsedList.length == 0) return null;
        return parseUsers(parsedList)[0];
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }
    return null;
  }

  Future<void> updateUser(String id) async {
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(
              document: q_getUser, variables: {'id': id}));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;

        final jsonc = json.decode(data)["getUser"];
        if (jsonc != null) _user = User.fromJson(jsonc);
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }
  }

  Future<void> deleteAlert(String id) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_deleteAlert, variables: {'id': id}));

      var response = await operation.response;
      var data = response.data;
      await updateUser(_user.id);

      print('Mutation result: ' + data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  Future<void> createUser(String id, String username) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_createUser,
              variables: {'id': id, 'username': username}));

      var response = await operation.response;
      var data = response.data;

      print('Mutation result: ' + data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  User getUser() {
    return _user;
  }

  void resetUser() {
    _user = null;
  }

  void updateDevice() async {
    await initUser();
    await initPlatformState();
  }

  void detachDevice() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = <String, dynamic>{};
    String deviceId;
    String token;
    String platform = 'unknown';
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        deviceId = deviceData["androidId"];
        platform = 'android';
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        deviceId = deviceData["identifierForVendor"];
        platform = 'ios';
      }
      await _deleteDevice(deviceId);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
  }

  Future<void> initUser() async {
    if (userStateController != null) {
      final state = UserState(userFlowStatus: UserFlowStatus.started);
      userStateController.add(state);
    }

    if (_user == null) {
      AuthUser res;
      try {
        res = await Amplify.Auth.getCurrentUser();
      } catch (e) {
        print("User SignedOut");
        return;
      }
      var _user_id = res.userId;
      var res2 = await Amplify.Auth.fetchUserAttributes();
      AuthUserAttribute email = res2.firstWhere(
          (element) => element.userAttributeKey == "email", orElse: () {
        return null;
      });
      var username = (email != null ? email.value : null);
      await updateUser(_user_id);
      if (_user == null) {
        await createUser(_user_id, username);
        await updateUser(_user_id);
      }
      // CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
      //   options: CognitoSessionOptions(getAWSCredentials: true));
    }
    if (userStateController != null) {
      final state2 = UserState(userFlowStatus: UserFlowStatus.finalized);
      userStateController.add(state2);
    }
    return;
  }

  factory UserService() {
    return _userService;
  }

  StreamController<UserState> userStateController;

  StreamController<UserState> getUserStreamController() {
    if (userStateController != null) userStateController.close();
    if (userStateController == null || userStateController.isClosed)
      userStateController = StreamController<UserState>();
    initUser();
    return userStateController;
  }

  Future<void> createAlert(SearchCriterio criterio) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_create_alert(criterio),
              variables: {'alertUserId': _user.id}));

      var response = await operation.response;
      var data = response.data;

      print('Mutation result: ' + data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }

  void addAlert(SearchCriterio criterio) async {
    try {
      // final state = UserState(userFlowStatus: UserFlowStatus.started);
      //userStateController.add(state);

      if (_user == null) {
        await initUser();
      }
      await createAlert(criterio);
      await updateUser(_user.id);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> addFav(String propertyId) async {
    try {
      // final state = UserState(userFlowStatus: UserFlowStatus.started);
      //userStateController.add(state);

      if (_user == null) {
        await initUser();
      }

      try {
        var operation = Amplify.API.mutate(
            request: GraphQLRequest<String>(document: m_createFav, variables: {
          'userFavsUserId': _user.id,
          'userFavsPropertyId': propertyId
        }));

        var response = await operation.response;
        var data = response.data;

        print('Mutation result: ' + data);
        await updateUser(_user.id);
      } on ApiException catch (e) {
        print('Mutation failed: $e');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> deleteFav(String id) async {
    try {
      Fav fav = _user.favs.firstWhere((element) => element.property.id == id,
          orElse: () {
        return null;
      });
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_deleteFav, variables: {'id': fav.id}));

      var response = await operation.response;
      var data = response.data;
      await updateUser(_user.id);

      print('Mutation result: ' + data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }
}
