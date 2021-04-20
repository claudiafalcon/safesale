import 'package:flutter/material.dart';
import 'package:safesale/auth/authnavigator.dart';

import 'package:safesale/pages/alerts.dart';
import 'package:safesale/pages/favs.dart';
import 'package:safesale/pages/messages.dart';
import 'package:safesale/pages/profile.dart';
import 'package:safesale/pages/videos.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/variables.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Page {
  final String page;
  final bool isGuestAllowed;
  Page({@required this.page, this.isGuestAllowed = false});
}

class _HomePageState extends State<HomePage> {
  bool isreloading = true;
  List<Page> pageoptions = [
    Page(page: "VideoPage", isGuestAllowed: true),
    Page(page: "AlertsPage"),
    Page(page: "FavsPage"),
    Page(page: "ProfilePage"),
    Page(page: "MessagesPage"),
  ];

  bool needsreload() {
    return isreloading;
  }

  turnoffreloading() {
    isreloading = false;
  }

  updatePage(int i) {
    setState(() {
      page = i;
    });
  }

  int page = 0;
  @override
  Widget build(BuildContext context) {
    final double _footerIconSize =
        MediaQuery.of(context).size.height * factorFooterIconSize;
    return Scaffold(
      body: NavigatorPage(
          pagename: pageoptions[page].page,
          guestallowed: pageoptions[page].isGuestAllowed,
          call: updatePage,
          needsreload: needsreload,
          turnoffreloading: turnoffreloading),
      bottomNavigationBar: new Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Color.fromRGBO(42, 180, 233, 300)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * factorBottonHeigh,
          child: BottomNavigationBar(
            onTap: (index) {
              print("Entra al tap");
              if (page == 0 && index == 0) {
                isreloading = true;
                print("Entra al change");
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
