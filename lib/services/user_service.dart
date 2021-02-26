import 'dart:async' show StreamController;
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/foundation.dart';

import 'package:safesale/amplifyconfiguration.dart';
import 'package:http/http.dart' as http;

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

import 'package:safesale/graphql/authqueries.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/models/searchcriterio.dart';

enum UserFlowStatus { started, finalized, error, empty }

class UserState {
  final UserFlowStatus userFlowStatus;

  UserState({this.userFlowStatus});
}

class UserService {
  static final UserService _userService = UserService._internal();

  UserService._internal();

  List<Property> _properties;

  List<Property> getProperties() {
    return _properties;
  }

  factory UserService() {
    return _userService;
  }

  StreamController<UserState> userStateController;

  StreamController<UserState> getUserStreamController() {
    if (userStateController != null) userStateController.close();
    if (userStateController == null || userStateController.isClosed)
      userStateController = StreamController<UserState>();
    return userStateController;
  }
}
