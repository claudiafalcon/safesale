import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safesale/models/property.dart';

import 'package:safesale/models/userfav.dart';

import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';

class FavsPage extends StatefulWidget {
  final AuthFlowStatus authstatus;
  final void Function(int) call;

  const FavsPage({Key key, this.authstatus, this.call}) : super(key: key);
  @override
  _FavsPageState createState() => _FavsPageState();
}

class _FavsPageState extends State<FavsPage> {
  final _searchService = SearchService();
  final _userService = UserService();
  List<Fav> result;
  @override
  initState() {
    super.initState();
    //  _listenForPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(67, 73, 75, 0.8),
      child: CustomPaint(
          painter: PainterSoft(
              Color.fromRGBO(52, 57, 59, 0.5),
              Color.fromRGBO(0, 59, 139, 0.5),
              Color.fromRGBO(52, 57, 59, 0.5),
              0,
              20),
          child: Column(children: [
            Container(
                padding: EdgeInsets.all(factorPaddingSpace * 100),
                height:
                    MediaQuery.of(context).size.height * factorPropertyTitle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    factorPropertyTitle,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      "Mis Favoritos",
                                      style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height <
                                                    800
                                                ? 24
                                                : 32,
                                        fontWeight: FontWeight.bold,
                                      )),
                                    ))))),
                  ],
                )),
            StreamBuilder<UserState>(
                stream: _userService.getUserStreamController().stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data.userFlowStatus == UserFlowStatus.started) {
                    return Container(); // LoadingPage();
                  } else if (snapshot.data.userFlowStatus ==
                      UserFlowStatus.empty) {
                    return Stack(
                      children: [
                        Container(),
                      ],
                    );
                  } else {
                    result = _userService.getUser().favs;
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (1 -
                                (factorBottonHeigh +
                                    factorPropertyTitle +
                                    factorVerticalSpace)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _createFavList(result),
                          ),
                        ),
                      ),
                    );
                  }
                })
          ])),
    );
  }

  void dosearch(Property property) async {
    _searchService.setProperty(property);
    widget.call(0);
  }

  List<Widget> _createFavList(List<Fav> list) {
    return new List<Widget>.generate(list.length, (index) {
      Fav item = list[index];
      return Dismissible(
        key: Key(item.id),
        background: Container(
            alignment: Alignment.centerRight,
            width: 200,
            color: Color.fromRGBO(255, 255, 255, 0),
            child: Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
              size: 50,
            )),
        onDismissed: (direction) {
          _userService.deleteFav(item.id);
          setState() {
            list.removeAt(index);
          }
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 10 * 1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          //color: Colors.green,
                          width: MediaQuery.of(context).size.width * 0.9 * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    list[index].property.nombre,
                                    style: GoogleFonts.raleway(
                                        color: Color.fromRGBO(0, 59, 139, 1),
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                factorFontSmall,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    list[index].property.descripcion,
                                    style: GoogleFonts.raleway(
                                        color: Color.fromRGBO(0, 59, 139, 1),
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                factorFontSmall,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ]),
                          )),
                      InkWell(
                        onTap: () => dosearch(item.property),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9 * 0.25,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(58, 184, 234, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Ver",
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontInput,
                                  fontWeight: FontWeight.w600,
                                ))),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
      );
    });
  }
}
