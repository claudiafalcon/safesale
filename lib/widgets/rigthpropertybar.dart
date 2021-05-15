import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/models/userfav.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/videopages/contactpage.dart';
import 'package:safesale/videopages/infopage.dart';
import 'package:safesale/videopages/locationview.dart';
import 'package:safesale/videopages/photopage.dart';
import 'package:safesale/videopages/scheduler.dart';
import 'package:safesale/videopages/searchview.dart';
import 'package:location/location.dart' show Location, LocationData;

class RightPropertyBar extends StatefulWidget {
  final int total;

  final String headText;

  final void Function(String) toggleplay;

  final AuthFlowStatus status;

  final Property property;

  final String email;

  const RightPropertyBar(
      {Key key,
      @required this.total,
      this.property,
      this.email,
      @required this.headText,
      @required this.status,
      this.toggleplay})
      : super(key: key);
  @override
  _RightPropertyBarState createState() => _RightPropertyBarState();
}

class _RightPropertyBarState extends State<RightPropertyBar> {
  final _searchService = SearchService();
  final _userService = UserService();

  bool isfav = false;

  LocationData currentLocation;

  buildprofile(int total, size) {
    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned(
            left: (size / 2) - ((size - 10) / 2),
            child: Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SvgPicture.asset(
                  'images/filter.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: (size / 2) + 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(total.toString(),
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> setInitialLocation() async {
    Location location = new Location();
    // establece la ubicación inicial tirando del usuario
    // ubicación actual de getLocation () de la ubicación
    currentLocation = await location.getLocation();
    _searchService.fetchProperties(
        currentLocation.latitude, currentLocation.longitude, null);

    // destino codificado para este ejemplo
  }

  @override
  initState() {
    super.initState();
    if (widget.property != null) isFav(widget.property.id);
  }

  Future<bool> isFav(String id) async {
    if (widget.status != AuthFlowStatus.session) return false;
    await _userService.initUser();
    Fav fav = _userService
        .getUser()
        .favs
        .firstWhere((element) => element.property.id == id, orElse: () {
      return null;
    });
    if (fav == null) return false;
    isfav = true;
    setState(() {
      isfav = true;
    });
    return true;
  }

  likevideo(String id) {
    if (isfav == false) {
      _userService.addFav(id);
    } else
      _userService.deleteFav(id);
  }

  @override
  Widget build(BuildContext context) {
    final double _propertyIconSize =
        MediaQuery.of(context).size.height * factorRighBarVideoIconSize;
    final double _filterIconSize =
        MediaQuery.of(context).size.height * factorRighBarFilterIconSize;

    return Column(children: [
      // top section
      Container(
        padding: const EdgeInsets.all(8.0),
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            //CircleAnimation(buildmusicalalbum()),

            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    factorPropertyTitle,
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    widget.headText,
                                    // MediaQuery.of(context).size.toString(),
                                    style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height <
                                                    800
                                                ? 17
                                                : 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                        ])))
            /* Text(
                              property.nombre,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )*/
          ],
        ),
      ),
      //Middle section
      Expanded(
          child: // Row(
              //mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.end,
              //children: [
              //rigth section

              Align(
        alignment: Alignment.centerRight,
        child: Container(
            width: MediaQuery.of(context).size.height *
                factorRighBarFilterIconSize *
                1.5,
            child: ListView(
              //  mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        widget.toggleplay('pause');
                        await showModalBottomSheet<void>(
                          isScrollControlled: true,
                          useRootNavigator: true,
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10.0))),
                          builder: (context) =>
                              SearchPage(widget.status, widget.toggleplay),
                        );
                      },
                      child: buildprofile(
                          widget.total, _filterIconSize + _filterIconSize / 5),
                    ),
                    SizedBox(
                      height: _propertyIconSize,
                    )
                  ],
                ),
                widget.total != 0
                    ? Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          InkWell(
                              onTap: () async {
                                if (widget.status != AuthFlowStatus.session) {
                                  await showDialog(
                                      context: context,
                                      builder: (_) => new AlertDialog(
                                            title: new Text(
                                              'Ups! ',
                                              style: TextStyle(
                                                  fontFamily: "Smash"),
                                            ),
                                            content: new Text(
                                              'La funcionalidad de Favoritos solo esta disponible para nuestros usuarios registrados. Corre Registrate! ...',
                                              style: TextStyle(
                                                  fontFamily: "Smash"),
                                            ),
                                          ));

                                  // Doesn't run
                                  Navigator.of(context).maybePop();
                                } else {
                                  await likevideo(widget.property.id);
                                  setState(() {
                                    isfav = !isfav;
                                  });
                                }
                              },
                              child: isfav == true
                                  ? SvgPicture.asset(
                                      'images/CORAZONAZUL.svg',
                                      width: _propertyIconSize,
                                      height: _propertyIconSize,
                                      color: Color.fromRGBO(0, 59, 139, 1),
                                    )
                                  : SvgPicture.asset(
                                      'images/CORAZON PERFIL.svg',
                                      width: _propertyIconSize,
                                      height: _propertyIconSize,
                                      color: Colors.white)),
                          SizedBox(
                            height: _propertyIconSize,
                          )
                        ],
                      )
                    : Container(),
                widget.total != 0
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.toggleplay('pause');
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                builder: (context) => PhotoPage(
                                    widget.property.id, widget.toggleplay),
                              );
                              widget.toggleplay('pause');
                            },
                            child: SvgPicture.asset(
                              'images/FOTOS.svg',
                              width: _propertyIconSize,
                              height: _propertyIconSize,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: _propertyIconSize,
                          ),
                        ],
                      )
                    : Container(),
                widget.total != 0
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.toggleplay('pause');
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0))),
                                builder: (context) => LocationPage(
                                    widget.property, widget.toggleplay),
                              );
                            },
                            child: SvgPicture.asset(
                              'images/UBICACION.svg',
                              width: _propertyIconSize,
                              height: _propertyIconSize,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: _propertyIconSize,
                          ),
                        ],
                      )
                    : Container(),
                widget.total != 0
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.toggleplay('pause');
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0))),
                                builder: (context) => InfoPage(
                                    widget.property, widget.toggleplay),
                              );
                            },
                            child: SvgPicture.asset(
                              'images/INFORMACION.svg',
                              width: _propertyIconSize,
                              height: _propertyIconSize,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: _propertyIconSize,
                          ),
                        ],
                      )
                    : Container(),
                widget.total != 0
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.toggleplay('pause');
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0))),
                                builder: (context) => ContactPage(
                                    widget.property,
                                    widget.status != AuthFlowStatus.session
                                        ? true
                                        : false,
                                    widget.status == AuthFlowStatus.session
                                        ? widget.email
                                        : null,
                                    widget.toggleplay),
                              );
                            },
                            child: SvgPicture.asset(
                              'images/DUDAS.svg',
                              width: _propertyIconSize,
                              height: _propertyIconSize,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: _propertyIconSize,
                          ),
                        ],
                      )
                    : Container(),
                widget.total != 0
                    ? Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              widget.toggleplay('pause');
                              showModalBottomSheet<void>(
                                useRootNavigator: true,
                                isScrollControlled: true,
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10.0))),
                                builder: (context) => SchedulerPage(
                                    widget.property,
                                    widget.status != AuthFlowStatus.session
                                        ? true
                                        : false,
                                    widget.status == AuthFlowStatus.session
                                        ? widget.email
                                        : null,
                                    widget.toggleplay),
                              );
                            },
                            child: SvgPicture.asset(
                              'images/CITAS.svg',
                              width: _propertyIconSize,
                              height: _propertyIconSize,
                              color: Colors.white,
                            ),
                          )
                        ],
                      )
                    : Container(),
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            )),
      )
          //]),
          ),
    ]);
  }
}
