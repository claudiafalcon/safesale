import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth/authnavigator.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/widgets/loading.dart';
import 'package:safesale/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  final bool amplifyConfigured;

  const HomePage(this.amplifyConfigured, {Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class Page {
  final String page;
  final bool isGuestAllowed;
  Page({@required this.page, this.isGuestAllowed = false});
}

class _HomePageState extends State<HomePage> {
  bool isexternalsearch = false;
  String conversationId;
  void _initMessaging() async {
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    final _userService = UserService();
    messaging.getToken().then((value) {
      _userService.refreshToken(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      int state = 0;
      print("message recieved");

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 100),
        barrierLabel: MaterialLocalizations.of(context).dialogLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        pageBuilder: (context, _, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 10,
                color: Color.fromRGBO(52, 57, 59, 0.5),
                child: Card(
                  color: Color.fromRGBO(0, 59, 139, 0.5),
                  child: InkWell(
                    onTap: () {
                      state = 1;
                      Navigator.of(context, rootNavigator: true).pop();
                      if (event.collapseKey != null)
                        conversationId = event.collapseKey;

                      setState(() {
                        page = 4;
                      });
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height *
                                    factorPaddingSpace /
                                    10),
                            child: Text(
                              event.notification.title,
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontSmall,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.height *
                                    factorPaddingSpace /
                                    10),
                            child: Text(
                              event.notification.body,
                              style: GoogleFonts.raleway(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontSmall,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ).drive(Tween<Offset>(
              begin: Offset(0, -1.0),
              end: Offset.zero,
            )),
            child: child,
          );
        },
      );
      new Future.delayed(const Duration(seconds: 2), () {
        // When task is over, close the dialog
        if (state == 0) Navigator.of(context, rootNavigator: true).pop();
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
      if (message.collapseKey != null) conversationId = message.collapseKey;

      setState(() {
        page = 4;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _initMessaging();
  }

  List<Page> pageoptions = [
    Page(page: "VideoPage", isGuestAllowed: true),
    Page(page: "AlertsPage"),
    Page(page: "FavsPage"),
    Page(page: "ProfilePage"),
    Page(page: "MessagesPage"),
  ];

  bool isExternalSearch() {
    return isexternalsearch;
  }

  updatePage(int i) {
    setState(() {
      page = i;
    });
  }

  resetNoti() {
    conversationId = null;
  }

  int page = 0;
  @override
  Widget build(BuildContext context) {
    final double _footerIconSize =
        MediaQuery.of(context).size.height * factorFooterIconSize;
    return Scaffold(
      body: widget.amplifyConfigured
          ? NavigatorPage(
              pagename: pageoptions[page].page,
              guestallowed: pageoptions[page].isGuestAllowed,
              conversationid: conversationId,
              call: updatePage,
              isExternalSearch: isExternalSearch,
              resetNoti: resetNoti)
          : LoadingPage(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Color.fromRGBO(42, 180, 233, 300)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * factorBottonHeigh,
          child: BottomNavigationBar(
            iconSize: _footerIconSize,
            selectedFontSize: 0,
            onTap: (index) {
              print("ENTRA AL BOTTOM DEL HOME");
              if (page == 0 && index == 0) {
                isexternalsearch = false;
              } else if (page == 0) {
                isexternalsearch = true;
              }
              setState(() {
                page = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xff003b8b),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.white,
            currentIndex: page,
            items: [
              BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'images/HOME.svg',
                      width: _footerIconSize,
                      height: _footerIconSize,
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'images/CAMPANA.svg',
                      width: _footerIconSize,
                      height: _footerIconSize,
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'images/CORAZON PERFIL.svg',
                      width: _footerIconSize,
                      height: _footerIconSize,
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'images/PERFIL.svg',
                      width: _footerIconSize,
                      height: _footerIconSize,
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Builder(
                  builder: (context) {
                    return SvgPicture.asset(
                      'images/COMENTARIOS PERFIL.svg',
                      width: _footerIconSize,
                      height: _footerIconSize,
                      color: IconTheme.of(context).color,
                    );
                  },
                ),
                label: "",
              )
            ],
          ),
        ),
      ),
    );
  }
}
