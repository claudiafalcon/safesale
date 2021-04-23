import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

import 'package:safesale/graphql/authqueries.dart';
import 'package:safesale/models/message.dart';

import 'package:safesale/models/user.dart';

import 'package:safesale/amplifyconfiguration.dart';

class NotificationService {
  static final NotificationService _notiService =
      NotificationService._internal();

  NotificationService._internal();

  factory NotificationService() {
    return _notiService;
  }

  List<Message> parseMessages(List jsonList) {
    return jsonList.map<Message>((json) => Message.fromJson(json)).toList();
  }

  Future<void> updateUnreadMessage(String messageId) async {
    try {
      var operation = Amplify.API.mutate(
          request: GraphQLRequest<String>(
              document: m_updateMessage, variables: {'id': messageId}));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;
        final String id = json.decode(data)["updateMessage"]["id"];
        return null;
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }
  }

  Future<List<Message>> getMessageByConvoId(String convoId) async {
    List<Message> messages;
    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: q_getMessages, variables: {"id": convoId}));
    var response = await operation.response;
    var data = response.data;
    final List parsedList = json.decode(data)["getConvo"]["messages"]["items"];
    messages = parseMessages(parsedList);
    return messages;
  }

  Future<void> subscribeConvos(String userId) {
    try {
      var operation = Amplify.API.subscribe(
          request: GraphQLRequest<String>(document: s_onCreateConvoLink),
          onData: (event) {
            print('Subscription event data received: ${event.data}');
          },
          onEstablished: () {
            print('Subscription established');
          },
          onError: (e) {
            print('Subscription failed with error: $e');
          },
          onDone: () {
            print('Subscription has been closed successfully');
          });
    } on ApiException catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createConvo(String name, String type, List<String> members,
      String propertyId, String schedulerdate, String scheduler) async {
    String jsonMember = "[" + members.join(",") + "]";

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
              'query': m_createConvo,
              'variables': {
                'members': members,
                'name': name,
                'type': type,
                'conversationPropertyId': propertyId,
                'scheduler': scheduler,
                'schedulerdate': schedulerdate
              }
            }));
        http.Response response;
        try {
          response = await http.post(signedRequest.url,
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final String id =
            json.decode(response.body)["data"]["createConvo"]["id"];
        return id;
      } else {
        return createConvoSigned(
            name, type, members, propertyId, schedulerdate, scheduler);
      }
    } catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createConvoSigned(
      String name,
      String type,
      List<String> members,
      String propertyId,
      String schedulerdate,
      String scheduler) async {
    String jsonMember = "[" + members.join(",") + "]";
    try {
      var operation = Amplify.API.query(
          request: GraphQLRequest<String>(document: m_createConvo, variables: {
        'members': members,
        'name': name,
        'type': type,
        'conversationPropertyId': propertyId,
        'scheduler': scheduler,
        'schedulerdate': schedulerdate
      }));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;
        final String id = json.decode(data)["createConvo"]["id"];
        return id;
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createConvoLink(
      String conversationId, String userId, String guestemail) async {
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
              'query': m_createConvoLink,
              'variables': {
                'convoLinkConversationId': conversationId,
                'convoLinkUserId': userId,
                'guestmail': guestemail,
              }
            }));
        http.Response response;
        try {
          response = await http.post(signedRequest.url,
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final String id =
            json.decode(response.body)["data"]["createConvoLink"]["id"];
        return id;
      } else {
        return createConvoLinkSigned(conversationId, userId, guestemail);
      }
    } catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createConvoLinkSigned(
      String conversationId, String userId, String guestemail) async {
    try {
      var operation = Amplify.API.query(
          request:
              GraphQLRequest<String>(document: m_createConvoLink, variables: {
        'convoLinkConversationId': conversationId,
        'convoLinkUserId': userId,
        'guestmail': guestemail,
      }));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;
        final String id = json.decode(data)["createConvoLink"]["id"];
        return id;
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createMessage(String conversationId, String ownerId,
      String content, String guestmail) async {
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
              'query': m_createMessage,
              'variables': {
                'authorId': ownerId,
                'content': content,
                'messageConversationId': conversationId,
                'guestmail': guestmail
              }
            }));
        http.Response response;
        try {
          response = await http.post(signedRequest.url,
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final String id =
            json.decode(response.body)["data"]["createMessage"]["id"];
        return id;
      } else {
        return createMessageSigned(conversationId, ownerId, content, guestmail);
      }
    } catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  Future<String> createMessageSigned(
      String conversationId, String ownerId, String content, guestmail) async {
    try {
      var operation = Amplify.API.query(
          request:
              GraphQLRequest<String>(document: m_createMessage, variables: {
        'authorId': ownerId,
        'content': content,
        'messageConversationId': conversationId,
        'guestmail': guestmail
      }));
      var response = await operation.response;
      if (response.errors.length == 0 && response.data != null) {
        var data = response.data;
        final String id = json.decode(data)["createMessage"]["id"];
        return id;
      }
    } on ApiException catch (e) {
      print('Query filed: $e');
    }

    return null;
  }

  // If you want to test the push notification locally,
  // you need to get the token and input to the Firebase console
}
