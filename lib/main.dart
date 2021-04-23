import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:safesale/models/pushnotification.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/amplifyconfiguration.dart';
import 'package:safesale/home.dart';

import 'package:amplify_api/amplify_api.dart';
import 'package:safesale/services/notification_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

Future initialiseFirebase() async {
  await Firebase.initializeApp();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();

  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();
    _configureAmplify();
    _authService.checkAuthStatus();
    initialiseFirebase();
  }

  void _configureAmplify() async {
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use

    AmplifyAuthCognito authPlugin = AmplifyAuthCognito();

    Amplify.addPlugins([authPlugin]);
    Amplify.addPlugin(AmplifyAPI());
    Amplify.addPlugin(AmplifyStorageS3());

    // Once Plugins are added, configure Amplify
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }
    try {
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Safe Sale',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es', 'MX') // English, no country code
          // Spanish, no country code
        ],
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primaryColor: Color(0xff003b8b),
            canvasColor: Color.fromRGBO(58, 184, 234, 1),
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.white.withOpacity(0))),
        // 2

        home: HomePage());
  }
}
