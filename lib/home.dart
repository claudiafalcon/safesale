import 'package:flutter/material.dart';

import 'package:safesale/pages/alerts.dart';
import 'package:safesale/pages/favs.dart';
import 'package:safesale/pages/messages.dart';
import 'package:safesale/pages/profile.dart';
import 'package:safesale/pages/videos.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pageoptions = [
    VideoPage(),
    AlertsPage(),
    FavsPage(),
    ProfilePage(),
    //AddVideoPage(),
    MessagesPage()
  ];

  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: new Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Color.fromRGBO(42, 180, 233, 300)),
        child: BottomNavigationBar(
          onTap: (index) {
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
                    width: 50,
                    height: 50,
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
                    width: 50,
                    height: 50,
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
                    width: 50,
                    height: 50,
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
                    width: 50,
                    height: 50,
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
                    width: 50,
                    height: 50,
                    color: IconTheme.of(context).color,
                  );
                },
              ),
              label: "",
            )
          ],
        ),
      ),
    );
  }
}
