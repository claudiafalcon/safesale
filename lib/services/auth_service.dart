import 'dart:async' show StreamController;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';

import 'package:safesale/auth_credentials.dart';

// 1
enum AuthFlowStatus {
  guess,
  login,
  signUp,
  verification,
  session,
  login_error,
  signUp_error,
  verification_error
}

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

  String error;

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

  void showVerification() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
    authStateController.add(state);
  }

  AuthCredentials getCredentials() {
    return _credentials;
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
        var res2 = await Amplify.Auth.fetchUserAttributes();
        AuthUserAttribute email = res2.firstWhere(
            (element) => element.userAttributeKey == "email", orElse: () {
          return null;
        });
        AuthUserAttribute name = res2.firstWhere(
            (element) => element.userAttributeKey == "name", orElse: () {
          return null;
        });
        String emailstr = (email != null ? email.value : null);
        String namestr = (name != null ? name.value : null);
        _credentials = new SignedCredentials(username: emailstr, name: namestr);
      } else {
        error = "El usuario no se pudo loguear. Intenta mas tarde.";
        final state = AuthState(authFlowStatus: AuthFlowStatus.login_error);
        authStateController.add(state);
        // 4
      }
    } catch (authError) {
      error = "Usuario o contraseña incorrectos.";

      print('Could not login - ${authError.message}');

      final state = AuthState(authFlowStatus: AuthFlowStatus.login_error);
      authStateController.add(state);
    }
  }

// 2
  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      final userAttributes = {
        'email': credentials.username,
        'name': credentials.name
      };
      // 3
      final result = await Amplify.Auth.signUp(
          username: credentials.username,
          password: credentials.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));

      // 4
      if (result.isSignUpComplete && !(result.nextStep is AuthNextSignUpStep)) {
        loginWithCredentials(credentials);
      } else {
        // 5
        this._credentials = credentials;

        // 6
        final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
        authStateController.add(state);
      }

      // 7
    } on UsernameExistsException {
      error = 'NotVerified';
      final state = AuthState(authFlowStatus: AuthFlowStatus.signUp_error);
      _credentials = new SignedCredentials(
          username: credentials.username, name: credentials.name);
      authStateController.add(state);
    } catch (e) {
      error = "Error, intenta más tarde";
      final state = AuthState(authFlowStatus: AuthFlowStatus.signUp_error);
      authStateController.add(state);
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
      error = "El código no es correcto.";
      final state =
          AuthState(authFlowStatus: AuthFlowStatus.verification_error);
      authStateController.add(state);
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
    //logOut();
    try {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      var state;
      if (res.isSignedIn) {
        state = AuthState(authFlowStatus: AuthFlowStatus.session);

        var res2 = await Amplify.Auth.fetchUserAttributes();
        AuthUserAttribute email = res2.firstWhere(
            (element) => element.userAttributeKey == "email", orElse: () {
          return null;
        });
        AuthUserAttribute name = res2.firstWhere(
            (element) => element.userAttributeKey == "name", orElse: () {
          return null;
        });
        String emailstr = (email != null ? email.value : null);
        String namestr = (name != null ? name.value : null);
        _credentials = new SignedCredentials(username: emailstr, name: namestr);
      } else
        state = AuthState(authFlowStatus: AuthFlowStatus.guess);
      authStateController.add(state);
      //final state = AuthState(authFlowStatus: AuthFlowStatus.login);

      authStateController.add(state);
    } catch (_) {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      final state = AuthState(authFlowStatus: AuthFlowStatus.guess);
      authStateController.add(state);
    }
  }
}
