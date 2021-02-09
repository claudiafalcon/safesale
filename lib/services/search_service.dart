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

enum SearchFlowStatus { started, finalized, error }

class SearchState {
  final SearchFlowStatus searchFlowStatus;

  SearchState({this.searchFlowStatus});
}

class SearchService {
  List<Property> _properties;

  List<Property> getProperties() {
    return _properties;
  }

  final searchStateController = StreamController<SearchState>();

  List<Property> parseProperties(List jsonList) {
    return jsonList.map<Property>((json) => Property.fromJson(json)).toList();
  }

  void fetchProperties(double lat, double lon) async {
    try {
      final state = SearchState(searchFlowStatus: SearchFlowStatus.started);
      searchStateController.add(state);

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
              'query': q_nerbyProperties,
              'variables': {"lat": 19.55, "lon": -99}
            }));
        http.Response response;
        try {
          response = await http.post(signedRequest.url,
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final List parsedList =
            json.decode(response.body)["data"]["nearbyProperties"]["items"];
        _properties = parseProperties(parsedList);
        final state = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
        searchStateController.add(state);
        return;
      } else {
        var operation = Amplify.API.query(
            request: GraphQLRequest<String>(
                document: q_nerbyProperties,
                variables: {"lat": lat, "lon": lon}));
        var response = await operation.response;
        var data = response.data;
        final List parsedList = json.decode(data)["nearbyProperties"]["items"];
        return compute(parseProperties, parsedList);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}