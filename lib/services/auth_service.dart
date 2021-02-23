import 'dart:async' show StreamController;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

import 'package:safesale/auth_credentials.dart';

// 1
enum AuthFlowStatus { guess, login, signUp, verification, session }

// 2
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({this.authFlowStatus});
}

// 3
class AuthService {
  // 4
  final authStateController = StreamController<AuthState>();

  AuthCredentials _credentials;

  // 5
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // 6
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  void showGuess() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.guess);
    authStateController.add(state);
  }

  void loginWithCredentials(AuthCredentials credentials) async {
    try {
      // 2
      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);

      // 3
      if (result.isSignedIn) {
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        // 4
        print('User could not be signed in');
      }
    } catch (authError) {
      print('Could not login - ${authError.cause}');
      var message = '';
      authError.exceptionList
          .where((authException) =>
              authException.exception != 'PLATFORM_EXCEPTIONS')
          .forEach((authException) {
        message += authException.detail;
      });
      print(message);
    }
  }

// 2
  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {'email': credentials.username};
      // 3
      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      // 4
      if (result.isSignUpComplete) {
        loginWithCredentials(credentials);
      } else {
        // 5
        this._credentials = credentials;

        // 6
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }

      // 7
    } catch (authError) {
      print('Failed to sign up - ${authError.cause}');
    }
  }

  void verifyCode(String verificationCode) async {
    try {
      // 2
      final result = await Amplify.Auth.confirmSignUp(
          username: _credentials.username, confirmationCode: verificationCode);

      // 3
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials);
      } else {
        // 4
        // Follow more steps
      }
    } catch (authError) {
      print('Could not verify code - ${authError.cause}');
    }
  }

  void logOut() async {
    try {
      // 1
      await Amplify.Auth.signOut();

      // 2
      showLogin();
    } catch (authError) {
      print('Could not log out - ${authError.cause}');
    }
  }

  void checkAuthStatus() async {
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      var state;
      if (res.isSignedIn)
        state = AuthState(authFlowStatus: AuthFlowStatus.session);
      else
        state = AuthState(authFlowStatus: AuthFlowStatus.guess);
      authStateController.add(state);
      //final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      print('State 1');
      authStateController.add(state);
    } catch (_) {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      final state = AuthState(authFlowStatus: AuthFlowStatus.guess);
      authStateController.add(state);
      print('State 2');
    }
  }
}
