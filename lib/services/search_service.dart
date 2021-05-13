import 'dart:async' show StreamController;
import 'dart:collection';
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

enum SearchFlowStatus { started, finalized, error, empty }

class SearchState {
  final SearchFlowStatus searchFlowStatus;

  SearchState({this.searchFlowStatus});
}

class SearchService {
  static final SearchService _searchService = SearchService._internal();

  SearchService._internal();

  bool _fromASearch = false;

  int _currentindex = 0;

  List<String> _tokens = <String>[];

  int _total = 0;

  int getTotal() {
    return _total;
  }

  SearchCriterio criterio;

  String getnextToken() {
    return _tokens[_currentindex];
  }

  String getpreviousToken() {
    if (_currentindex == 0) return null;
    return _tokens[_currentindex - 1];
  }

  void turnOffExternalSearch() {
    _fromASearch = false;
  }

  bool isAExternalSearch() {
    return _fromASearch;
  }

  List<Property> _properties;

  Queue<Property> _props = new Queue();

  List<Property> getProperties() {
    return _properties;
  }

  factory SearchService() {
    return _searchService;
  }

  StreamController<SearchState> searchStateController =
      StreamController<SearchState>.broadcast();

  List<Property> parseProperties(List jsonList) {
    return jsonList.map<Property>((json) => Property.fromJson(json)).toList();
  }

  void checkState() async {
    if (_properties != null && isAExternalSearch()) {
      final state2 = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
      searchStateController.add(state2);
    }
  }

  void setProperty(Property property) {
    _fromASearch = true;
    _properties = null;
    _properties = <Property>[];
    _properties.add(property);
  }

  void fetchProperties(double lat, double lon, String nextToken) async {
    try {
      _properties = null;
      if (nextToken == null) {
        _total = 0;
        _tokens = <String>[];
      }

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
              'variables': {"lat": lat, "lon": lon}
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
        if (nextToken == null)
          _total = json.decode(response.body)["data"]["nearbyProperties"]
                      ["total"] ==
                  null
              ? 0
              : json.decode(response.body)["data"]["nearbyProperties"]["total"];
        _tokens.add(json.decode(response.body)["data"]["nearbyProperties"]
                    ["nextToken"] ==
                null
            ? "-1"
            : json.decode(response.body)["data"]["nearbyProperties"]
                ["nextToken"]);

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
        if (nextToken == null)
          _total = json.decode(data)["nearbyProperties"]["total"] == null
              ? 0
              : json.decode(data)["nearbyProperties"]["total"];
        _tokens.add(json.decode(data)["nearbyProperties"]["nextToken"] == null
            ? "-1"
            : json.decode(data)["nearbyProperties"]["nextToken"]);

        _properties = parseProperties(parsedList);
        _props.addAll(_properties);
        final state = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
        searchStateController.add(state);
        return;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  void searchProperties(SearchCriterio criterio, String nextToken) async {
    try {
      _properties = null;
      if (nextToken == null) {
        _total = 0;
        _tokens = <String>[];
      }
      criterio = criterio;
      _fromASearch = true;
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
              'query': q_preffix_search(criterio),
            }));
        http.Response response;
        try {
          response = await http.post(signedRequest.url,
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }

        if (nextToken == null)
          _total = json.decode(response.body)["data"]["searchProperties"]
                      ["total"] ==
                  null
              ? 0
              : json.decode(response.body)["data"]["searchProperties"]["total"];
        _tokens.add(json.decode(response.body)["data"]["searchProperties"]
                    ["nextToken"] ==
                null
            ? "-1"
            : json.decode(response.body)["data"]["searchProperties"]
                ["nextToken"]);

        final List parsedList =
            json.decode(response.body)["data"]["searchProperties"]["items"];
        if (parsedList.isEmpty) {
          final state = SearchState(searchFlowStatus: SearchFlowStatus.empty);
          searchStateController.add(state);
          return;
        }

        _properties = parseProperties(parsedList);
        final state = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
        searchStateController.add(state);
        return;
      } else {
        var operation = Amplify.API.query(
            request:
                GraphQLRequest<String>(document: q_preffix_search(criterio)));
        var response = await operation.response;
        var data = response.data;
        if (nextToken == null)
          _total = json.decode(data)["searchProperties"]["total"] == null
              ? 0
              : json.decode(data)["searchProperties"]["total"];
        _tokens.add(json.decode(data)["searchProperties"]["nextToken"] == null
            ? "-1"
            : json.decode(data)["searchProperties"]["nextToken"]);
        final List parsedList = json.decode(data)["searchProperties"]["items"];
        if (parsedList.isEmpty) {
          final state = SearchState(searchFlowStatus: SearchFlowStatus.empty);
          searchStateController.add(state);
          return;
        }
        _properties = parseProperties(parsedList);
        final state = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
        searchStateController.add(state);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
