import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/amplifyconfiguration.dart';
import 'package:safesale/home.dart';
import 'package:safesale/login.dart';
import 'package:amplify_api/amplify_api.dart';

import 'package:safesale/signup.dart';
import 'package:safesale/verification.dart';
import 'package:safesale/widgets/loading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();
    _configureAmplify();
    _authService.checkAuthStatus();
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
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white.withOpacity(0))),
      // 2

      home: StreamBuilder<AuthState>(
          // 2
          stream: _authService.authStateController.stream,
          builder: (context, snapshot) {
            // 3
            if (snapshot.hasData) {
              return Navigator(
                pages: [
                  // 4
                  // Show Login Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.login)
                    MaterialPage(
                        child: LoginPage(
                      didProvideCredentials: _authService.loginWithCredentials,
                      shouldShowsSingUp: _authService.showSignUp,
                    )),

                  // 5
                  // Show Sign Up Page
                  if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp)
                    MaterialPage(
                        child: SignUp(
                      didProvideCredentials: _authService.signUpWithCredentials,
                    )),

                  if (snapshot.data.authFlowStatus == AuthFlowStatus.guess ||
                      snapshot.data.authFlowStatus == AuthFlowStatus.session)
                    MaterialPage(child: HomePage()),
                  if (snapshot.data.authFlowStatus ==
                      AuthFlowStatus.verification)
                    MaterialPage(
                        child: VerificationPage(
                      didProvideVerificationCode: _authService.verifyCode,
                    )),
                ],
                onPopPage: (route, result) => route.didPop(result),
              );
            } else {
              return LoadingPage();
            }
          }),
    );
  }
}
