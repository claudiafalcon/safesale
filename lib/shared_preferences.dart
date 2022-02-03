import 'package:safesale/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:safesale/screens/first_splash_screen.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

class SharedPref extends StatefulWidget {
  final bool amplifyConfigured;
  const SharedPref(this.amplifyConfigured, {Key key}) : super(key: key);

  @override
  _SharedPrefState createState() => _SharedPrefState();
}

class _SharedPrefState extends State<SharedPref> {
  bool isFirstLaunch = false;

  void setFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isFirstLaunch = prefs.getBool('first_time');
    if (isFirstLaunch != null && !isFirstLaunch) {
      prefs.setBool('first_time', false);
    } else {
      prefs.setBool('first_time', false);
      isFirstLaunch = true;
    }
  }

  @override
  initState() {
    super.initState();
    setFirstLaunch();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Safe Sale',
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
        //if true return intro screen for first time Else go to login Screen
        home: isFirstLaunch
            ? FirstSplashScreen(widget.amplifyConfigured)
            : HomePage(widget.amplifyConfigured));
  }
}

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance =
      MySharedPreferences._privateConstructor();

  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    print("Hello");
    return myPrefs.getBool(key) ?? false;
  }
}
