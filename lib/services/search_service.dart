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
import 'package:safesale/variables.dart';

enum SearchFlowStatus { started, finalized, error, empty }

class SearchState {
  final SearchFlowStatus searchFlowStatus;

  SearchState({this.searchFlowStatus});
}

class SearchService {
  static final SearchService _searchService = SearchService._internal();

  SearchService._internal();

  bool _fromASearch = false;

  String _searchType;

  void setSearchType(String type) {
    if (type != null) _searchType = type;
  }

  String getSearchType() {
    return _searchType;
  }

  int _currentindex = 0;

  List<String> _tokens = <String>[];

  int _total = 0;

  int getTotal() {
    return _total;
  }

  SearchCriterio criterio;

  String getnextToken(int index) {
    return _tokens[index];
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

  double _lat;

  double _lon;

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
    _total = 1;
    _properties = null;
    _properties = <Property>[];
    _properties.add(property);
  }

  void fetchProperties(double lat, double lon, String nextToken) async {
    print("[info] Esta iniciando la busqueda");
    try {
      _properties = null;
      if (nextToken == null) {
        _lat = lat;
        _lon = lon;
        criterio = null;
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
              'variables': {
                "lat": _lat,
                "lon": _lon,
                "limit": resultBlockSize,
                "nextToken": nextToken
              }
            }));
        http.Response response;
        try {
          response = await http.post(Uri.parse(signedRequest.url),
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
      } else {
        var operation = Amplify.API.query(
            request: GraphQLRequest<String>(
                document: q_nerbyProperties,
                variables: {
              "lat": _lat,
              "lon": _lon,
              "limit": resultBlockSize,
              "nextToken": nextToken
            }));
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
      }
      var states = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
      if (_total > 0) {
        searchStateController.add(states);
        return;
      }
      _searchType = "new";
      getNewProperties(null);
    } catch (e) {
      print(e);
    }
    return null;
  }

  void getNewProperties(String nextToken) async {
    print("[info] Esta iniciando la busqueda news");
    try {
      _properties = null;
      if (nextToken == null) {
        criterio = null;
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
              'query': q_getNewProperties,
              'variables': {"limit": resultBlockSize, "nextToken": nextToken}
            }));
        http.Response response;
        try {
          response = await http.post(Uri.parse(signedRequest.url),
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }
        final List parsedList =
            json.decode(response.body)["data"]["searchPropertys"]["items"];
        if (nextToken == null)
          _total = json.decode(response.body)["data"]["searchPropertys"]
                      ["total"] ==
                  null
              ? 0
              : json.decode(response.body)["data"]["searchPropertys"]["total"];
        _tokens.add(json.decode(response.body)["data"]["searchPropertys"]
                    ["nextToken"] ==
                null
            ? "-1"
            : json.decode(response.body)["data"]["searchPropertys"]
                ["nextToken"]);

        _properties = parseProperties(parsedList);
      } else {
        var operation = Amplify.API.query(
            request: GraphQLRequest<String>(
                document: q_getNewProperties,
                variables: {"limit": resultBlockSize, "nextToken": nextToken}));
        var response = await operation.response;
        var data = response.data;
        final List parsedList = json.decode(data)["searchPropertys"]["items"];
        if (nextToken == null)
          _total = json.decode(data)["searchPropertys"]["total"] == null
              ? 0
              : json.decode(data)["searchPropertys"]["total"];
        _tokens.add(json.decode(data)["searchPropertys"]["nextToken"] == null
            ? "-1"
            : json.decode(data)["searchPropertys"]["nextToken"]);

        _properties = parseProperties(parsedList);
        _props.addAll(_properties);
      }
      var states = SearchState(searchFlowStatus: SearchFlowStatus.finalized);
      if (_total == 0)
        states = SearchState(searchFlowStatus: SearchFlowStatus.empty);
      searchStateController.add(states);
      return;
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
        _tokens = null;
        _tokens = <String>[];
        this.criterio = criterio;
      }

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
              'query': q_preffix_search(this.criterio),
              'variables': {"limit": resultBlockSize, "nextToken": nextToken}
            }));
        http.Response response;
        try {
          response = await http.post(Uri.parse(signedRequest.url),
              headers: signedRequest.headers, body: signedRequest.body);
        } catch (e) {
          print(e);
        }

        if (nextToken == null) {
          _total = json.decode(response.body)["data"]["searchProperties"]
                      ["total"] ==
                  null
              ? 0
              : json.decode(response.body)["data"]["searchProperties"]["total"];
          _tokens = <String>[];
        }
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
            request: GraphQLRequest<String>(
                document: q_preffix_search(this.criterio),
                variables: {"limit": resultBlockSize, "nextToken": nextToken}));
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
