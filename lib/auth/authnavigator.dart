import 'package:flutter/material.dart';
import 'package:safesale/login.dart';
import 'package:safesale/pages/alerts.dart';
import 'package:safesale/pages/favs.dart';
import 'package:safesale/pages/messages.dart';
import 'package:safesale/pages/profile.dart';
import 'package:safesale/pages/videos.dart';
import 'package:safesale/resetpassword.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/signup.dart';
import 'package:safesale/verification.dart';
import 'package:safesale/verificationpass.dart';
import 'package:safesale/widgets/loading.dart';

class NavigatorPage extends StatefulWidget {
  final String pagename;
  final bool guestallowed;
  final String conversationid;
  final void Function(int) call;
  final bool Function() isExternalSearch;
  final Function() resetNoti;

  const NavigatorPage(
      {Key key,
      @required this.pagename,
      this.guestallowed: false,
      this.call,
      this.isExternalSearch,
      this.conversationid,
      this.resetNoti})
      : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final _authService = AuthService();
  final _userService = UserService();

  @override
  initState() {
    super.initState();
    _authService.checkAuthStatus();
  }

  Widget getPage(AuthFlowStatus status) {
    // widget.getpage();
    switch (widget.pagename) {
      case "VideoPage":
        return VideoPage(
            authstatus: status,
            credentials: _authService.getCredentials(),
            isExternalSearch: widget.isExternalSearch);
      case "AlertsPage":
        return AlertsPage(authstatus: status, call: widget.call);
      case "FavsPage":
        return FavsPage(authstatus: status, call: widget.call);
      case "ProfilePage":
        return ProfilePage(
            authstatus: status,
            credentials: _authService.getCredentials(),
            shouldLogOut: _authService.logOut,
            detachDevice: _userService.detachDevice);
      case "MessagesPage":
        return MessagesPage(
          authstatus: status,
          conversationid: widget.conversationid,
          resetNoti: widget.resetNoti,
        );
      default:
        return VideoPage(authstatus: status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
        // 2
        stream: _authService.authStateController.stream,
        builder: (context, snapshot) {
          // 3
          if (snapshot.hasData) {
            return Navigator(
              pages: [
                // 4
                // Show Login Page
                if (snapshot.data.authFlowStatus == AuthFlowStatus.login ||
                    snapshot.data.authFlowStatus ==
                        AuthFlowStatus.login_error ||
                    (snapshot.data.authFlowStatus == AuthFlowStatus.guess &&
                        !widget.guestallowed))
                  MaterialPage(
                      child: LoginPage(
                          didProvideCredentials:
                              _authService.loginWithCredentials,
                          shouldShowsSingUp: _authService.showSignUp,
                          shouldUpdateDevice: _userService.updateDevice,
                          shouldShowResetPassword:
                              _authService.showResetPassword,
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.login_error
                              ? _authService.error
                              : null)),
                if ((snapshot.data.authFlowStatus == AuthFlowStatus.signUp ||
                        snapshot.data.authFlowStatus ==
                            AuthFlowStatus.signUp_error) &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: SignUp(
                          didProvideCredentials:
                              _authService.signUpWithCredentials,
                          shouldShowLogin: _authService.showLogin,
                          shouldShowVerification: _authService.showVerification,
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.signUp_error
                              ? _authService.error
                              : null)),
                if ((snapshot.data.authFlowStatus ==
                            AuthFlowStatus.resetPassword ||
                        snapshot.data.authFlowStatus ==
                            AuthFlowStatus.resetPassword_error) &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: ResetPasswordPage(
                          didProvideUserName: _authService.resetPassword,
                          shouldShowLogin: _authService.showLogin,
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.resetPassword_error
                              ? _authService.error
                              : null)),
                if ((snapshot.data.authFlowStatus ==
                            AuthFlowStatus.verification ||
                        snapshot.data.authFlowStatus ==
                            AuthFlowStatus.verification_error) &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: VerificationPage(
                          didProvideVerificationCode: _authService.verifyCode,
                          shouldShowLogin: _authService.showLogin,
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.verification_error
                              ? _authService.error
                              : null,
                          email: _authService.getCredentials().username)),
                if ((snapshot.data.authFlowStatus ==
                            AuthFlowStatus.verifificationPass ||
                        snapshot.data.authFlowStatus ==
                            AuthFlowStatus.verifificationPass_error) &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: VerificationPassPage(
                          didProvideNewPassword:
                              _authService.setNewPasswordCode,
                          shouldShowLogin: _authService.showLogin,
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.verifificationPass_error
                              ? _authService.error
                              : null,
                          email: _authService.getCredentials().username)),
                if ((widget.guestallowed) ||
                    snapshot.data.authFlowStatus == AuthFlowStatus.session)
                  MaterialPage(child: getPage(snapshot.data.authFlowStatus)),
              ],
              onPopPage: (route, result) => route.didPop(result),
            );
          } else {
            return LoadingPage();
          }
        });
  }
}
