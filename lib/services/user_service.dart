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
import 'package:safesale/models/user.dart';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

enum UserFlowStatus { started, finalized, error, empty }

class UserState {
  final UserFlowStatus userFlowStatus;

  UserState({this.userFlowStatus});
}

class UserService {
  static final UserService _userService = UserService._internal();

  User _user;

  UserService._internal();

  Future<void> updateUser(String id) async {
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(
              document: q_getUser, variables: {'id': id}));
      var response = await operation.response;
      var data = response.data;

      final jsonc = json.decode(data)["getUser"];
      if (jsonc != null) _user = User.fromJson(jsonc);
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

  Future<void> createUser(String id) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_createUser, variables: {'id': id}));

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

  Future<void> initUser() async {
    if (userStateController != null) {
      final state = UserState(userFlowStatus: UserFlowStatus.started);
      userStateController.add(state);
    }
    ;
    if (_user == null) {
      AuthUser res = await Amplify.Auth.getCurrentUser();
      var _user_id = res.userId;
      await updateUser(_user_id);
      if (_user == null) {
        await createUser(_user_id);
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
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_deleteFav, variables: {'id': id}));

      var response = await operation.response;
      var data = response.data;
      await updateUser(_user.id);

      print('Mutation result: ' + data);
    } on ApiException catch (e) {
      print('Mutation failed: $e');
    }
  }
}
