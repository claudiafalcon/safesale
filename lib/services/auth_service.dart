import 'dart:async' show StreamController;

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/services.dart';

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
  verification_error,
  resetPassword,
  verifificationPass,
  resetPassword_error,
  verifificationPass_error,
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

  static Future<bool> isUserSignedIn() async {
    bool _isSignedIn = false;

    return _isSignedIn;
  }

  // 5
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  void showResetPassword() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.resetPassword);
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

  void resetPassword(String username) async {
    try {
      ResetPasswordResult res = await Amplify.Auth.resetPassword(
        username: username,
      );

      final state =
          AuthState(authFlowStatus: AuthFlowStatus.verifificationPass);
      authStateController.add(state);

      _credentials = new ResetCredentials(username: username);
    } catch (authError) {
      error = "El username no existe.";
      final state =
          AuthState(authFlowStatus: AuthFlowStatus.resetPassword_error);
      authStateController.add(state);
      print('Could not verify code - ${authError.cause}');
    }
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
      var result;
      try {
        result = await Amplify.Auth.signIn(
            username: credentials.username, password: credentials.password);
      } catch (e) {
        final result = await Amplify.Auth.signIn(
            username: credentials.username, password: credentials.password);
      }
      // 3
      if (result.isSignedIn) {
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
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        error = "El usuario no se pudo loguear. Intenta mas tarde.";
        final state = AuthState(authFlowStatus: AuthFlowStatus.login_error);
        authStateController.add(state);
        // 4
      }
    } catch (authError) {
      // logOut();
      error = "Usuario o contraseña incorrectos.";

      print('Could not login - ${authError.message}');

      final state = AuthState(authFlowStatus: AuthFlowStatus.login_error);
      authStateController.add(state);
    }
  }

  void setNewPasswordCode(AuthCredentials credentials) async {
    try {
      // 2
      final result = await Amplify.Auth.confirmPassword(
          username: credentials.username,
          newPassword: credentials.password,
          confirmationCode: credentials.verificationCode);
      _credentials = new LoginCredentials(
          username: credentials.username, password: credentials.password);

      loginWithCredentials(_credentials);
    } catch (authError) {
      error = "El código no es correcto.";
      final state =
          AuthState(authFlowStatus: AuthFlowStatus.verification_error);
      authStateController.add(state);
      print('Could not verify code - ${authError.cause}');
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
      try {
        var res = await Amplify.Auth.resendSignUpCode(
          username: credentials.username,
        );
        var destination = res.codeDeliveryDetails.destination;
        print('Confirmation code set to $destination');
      } on AmplifyException catch (e) {
        print(e.message);
      }

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
      SignOutResult result = await Amplify.Auth.signOut();

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
    } on SessionExpiredException catch (e) {
      logOut();
    } catch (e) {
      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));
      final state = AuthState(authFlowStatus: AuthFlowStatus.guess);
      authStateController.add(state);
    }
  }
}
