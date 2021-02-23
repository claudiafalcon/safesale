import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/videopages/infopage.dart';
import 'package:safesale/videopages/locationview.dart';
import 'package:safesale/videopages/photopage.dart';
import 'package:safesale/videopages/searchview.dart';
import 'package:location/location.dart' show Location, LocationData;

class RightPropertyBar extends StatefulWidget {
  final int total;

  final String headText;

  final Property property;

  const RightPropertyBar(
      {Key key, @required this.total, this.property, @required this.headText})
      : super(key: key);
  @override
  _RightPropertyBarState createState() => _RightPropertyBarState();
}

class _RightPropertyBarState extends State<RightPropertyBar> {
  final _searchService = SearchService();
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
        currentLocation.latitude, currentLocation.longitude);

    // destino codificado para este ejemplo
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => showModalBottomSheet<void>(
                        isScrollControlled: true,
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10.0))),
                        builder: (context) => SearchPage("22"),
                      ),
                      child: buildprofile(
                          widget.total, _filterIconSize + _filterIconSize / 5),
                    ),
                    SizedBox(
                      height: _propertyIconSize,
                    )
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () => setInitialLocation(),
                      child: Icon(
                        Icons.explore,
                        color: Colors.white,
                        size: _filterIconSize,
                      ),
                    ),
                  ],
                ),
                widget.total != 0
                    ? Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          SvgPicture.asset(
                            'images/CORAZON LIKE.svg',
                            width: _propertyIconSize,
                            height: _propertyIconSize,
                            color: Colors.white,
                          ),
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
                            onTap: () => showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              builder: (context) =>
                                  PhotoPage(widget.property.id),
                            ),
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
                            onTap: () => showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0))),
                              builder: (context) =>
                                  LocationPage(widget.property),
                            ),
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
                            onTap: () => showModalBottomSheet<void>(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10.0))),
                              builder: (context) => InfoPage(widget.property),
                            ),
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
                          SvgPicture.asset(
                            'images/DUDAS.svg',
                            width: _propertyIconSize,
                            height: _propertyIconSize,
                            color: Colors.white,
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
                          SvgPicture.asset(
                            'images/CITAS.svg',
                            width: _propertyIconSize,
                            height: _propertyIconSize,
                            color: Colors.white,
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
