import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/home.dart';
import 'package:safesale/models/alert.dart';
import 'package:safesale/models/searchcriterio.dart';
import 'package:safesale/models/user.dart';
import 'package:safesale/pages/videos.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/widgets/empyList.dart';
import 'package:safesale/widgets/loading.dart';

class AlertsPage extends StatefulWidget {
  final AuthFlowStatus authstatus;
  final void Function(int) call;

  const AlertsPage({Key key, this.authstatus, this.call}) : super(key: key);
  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final _searchService = SearchService();
  final _userService = UserService();
  List<Alert> result;
  @override
  initState() {
    super.initState();
    //  _listenForPermissionStatus();

    setInitialUser();
  }

  Future<void> setInitialUser() async {
    //await _userService.initUser();
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
                                      "Mis alertas",
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
                    result = _userService.getUser().alerts;
                    return SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height *
                            (1 -
                                (factorBottonHeigh +
                                    factorPropertyTitle +
                                    factorVerticalSpace)),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _createAlertList(result),
                          ),
                        ),
                      ),
                    );
                  }
                })
          ])),
    );
  }

  void dosearch(SearchCriterio criterio) async {
    _searchService.setSearchType("alert");
    _searchService.searchProperties(criterio, null);
    widget.call(0);
  }

  List<Widget> _createAlertList(List<Alert> list) {
    return new List<Widget>.generate(list.length, (index) {
      Alert item = list[index];
      StringBuffer text = StringBuffer();
      if (![null, ""].contains(item.criterio.tipo))
        text.write(item.criterio.tipo);
      if (item.criterio.recamaras != null)
        text.write("Recámaras +" + item.criterio.recamaras.toString() + " ");
      if (item.criterio.baths != null)
        text.write("Baños +" + item.criterio.baths.toString() + " ");
      if (item.criterio.estacionamientos != null)
        text.write("Estacionamientos +" +
            item.criterio.estacionamientos.toString() +
            " ");
      if (item.criterio.terrenom2 != null)
        text.write("Terreno m2 +" + item.criterio.terrenom2.toString() + " ");
      if (item.criterio.construccionm2 != null)
        text.write("Construcción m2 +" +
            item.criterio.construccionm2.toString() +
            " ");
      if (item.criterio.preciofrom != null || item.criterio.precioto != null)
        text.write("Precio ::" +
            (item.criterio.preciofrom == null
                ? "0"
                : item.criterio.preciofrom.toString()) +
            (item.criterio.precioto == null
                ? ""
                : "-" + item.criterio.precioto.toString()) +
            " ");
      if (item.criterio.amenidades != null)
        text.write(item.criterio.amenidades.replaceAll("OR", "ó"));

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
          _userService.deleteAlert(item.id);
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
                                    list[index].criterio.criteria,
                                    style: GoogleFonts.raleway(
                                        color: Color.fromRGBO(0, 59, 139, 1),
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                factorFontSmall,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    text.toString(),
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
                        onTap: () => dosearch(item.criterio),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9 * 0.25,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(58, 184, 234, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Mostrar",
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
