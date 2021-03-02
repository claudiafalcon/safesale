import 'package:flutter/material.dart';
import 'package:safesale/login.dart';
import 'package:safesale/pages/alerts.dart';
import 'package:safesale/pages/favs.dart';
import 'package:safesale/pages/messages.dart';
import 'package:safesale/pages/profile.dart';
import 'package:safesale/pages/videos.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/signup.dart';
import 'package:safesale/verification.dart';
import 'package:safesale/widgets/loading.dart';

class NavigatorPage extends StatefulWidget {
  final String pagename;
  final bool guestallowed;
  final void Function(int) call;

  const NavigatorPage(
      {Key key, @required this.pagename, this.guestallowed: false, this.call})
      : super(key: key);
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  final _authService = AuthService();

  @override
  initState() {
    super.initState();
    _authService.checkAuthStatus();
  }

  Widget getPage(AuthFlowStatus status) {
    switch (widget.pagename) {
      case "VideoPage":
        return VideoPage(authstatus: status);
      case "AlertsPage":
        return AlertsPage(authstatus: status, call: widget.call);
      case "FavsPage":
        return FavsPage(authstatus: status);
      case "ProfilePage":
        return ProfilePage(authstatus: status);
      case "MessagesPage":
        return MessagesPage(authstatus: status);
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
                          error: snapshot.data.authFlowStatus ==
                                  AuthFlowStatus.login_error
                              ? _authService.error
                              : null)),
                if (snapshot.data.authFlowStatus == AuthFlowStatus.signUp &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: SignUp(
                    didProvideCredentials: _authService.signUpWithCredentials,
                  )),
                if (snapshot.data.authFlowStatus ==
                        AuthFlowStatus.verification &&
                    !widget.guestallowed)
                  MaterialPage(
                      child: VerificationPage(
                    didProvideVerificationCode: _authService.verifyCode,
                  )),
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
