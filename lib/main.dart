import 'dart:async';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:flutter/material.dart';
import 'package:plain_notification_token/plain_notification_token.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/amplifyconfiguration.dart';
import 'package:safesale/home.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:safesale/services/connection_status_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();

  IosNotificationSettings _settings;
  StreamSubscription onTokenRefreshSubscription;

  StreamSubscription onIosSubscription;

  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();

    _configureAmplify();
  }

  @override
  void dispose() {
    onTokenRefreshSubscription.cancel();
    onIosSubscription.cancel();
    super.dispose();
  }

  void _configureAmplify() async {
    if (!mounted) return;
    // Add Pinpoint and Cognito Plugins, or any other plugins you want to use
    Amplify.addPlugin(AmplifyAuthCognito());
    Amplify.addPlugin(AmplifyAPI());
    Amplify.addPlugin(AmplifyStorageS3());

    // Once Plugins are added, configure Amplify
    try {
      await Amplify.configure(amplifyconfig);
      print('Main :: Amplify  configured');
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
        debugShowCheckedModeBanner: false,
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
                // backgroundColor: Colors.black.withOpacity(0)
                )),
        // 2

        home: HomePage(_amplifyConfigured));
  }
}
