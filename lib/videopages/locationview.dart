import 'dart:core';

import 'package:adobe_xd/adobe_xd.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/widgets/listItem.dart';

class LocationPage extends StatefulWidget {
  final Property property;
  final void Function(String) toggleplay;

  LocationPage(this.property, this.toggleplay);
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _formKey = GlobalKey<FormState>();
  GoogleMapController mapController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.toggleplay('play');
  }

  LatLng _center;
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    setState(() {
      _markers.clear();
      final marker = Marker(
          markerId: MarkerId(widget.property.nombre),
          position: _center,
          infoWindow: InfoWindow(
            title: widget.property.nombre,
            snippet:
                widget.property.direccion + "," + widget.property.localidad,
          ),
          rotation: 45.0);
      _markers[widget.property.nombre] = marker;
    });
  }

  initState() {
    super.initState();
    //  _listenForPermissionStatus();
    _center =
        new LatLng(widget.property.location.lat, widget.property.location.lon);
  }

  @override
  Widget build(BuildContext context) {
    double _fontsize = MediaQuery.of(context).size.height < 800 ? 12 : 16;
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height / 10 * 9.5,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Container(
              width: double.infinity,
              color: Color.fromRGBO(67, 73, 75, 0.83),
              child: Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Container(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * .9,
                        child: Stack(
                          children: [
                            CustomPaint(
                              painter: PainterSoft(
                                  Color(0xff003b8b),
                                  Color.fromRGBO(58, 184, 234, 1),
                                  Colors.white,
                                  5,
                                  10),
                              child: Container(
                                width: MediaQuery.of(context).size.width * .9,
                                height: MediaQuery.of(context).size.height * .8,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10 *
                                              3.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  width: 80,
                                                  height: 90,
                                                  child: Center(
                                                    child: Builder(
                                                      builder: (context) {
                                                        return SvgPicture.asset(
                                                          'images/LOCATION_ICON.svg',
                                                          width: 50,
                                                          height: 50,
                                                          color: Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                        );
                                                      },
                                                    ),
                                                  )),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(children: [
                                                    Container(
                                                        child: ListItem(
                                                      parametro: "Pais:",
                                                      texto:
                                                          widget.property.pais,
                                                      bulletcolor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      textcolor: Colors.white,
                                                      fontsize: _fontsize,
                                                    )),
                                                    ListItem(
                                                      parametro: "Entidad:",
                                                      texto: widget
                                                          .property.entidad,
                                                      bulletcolor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      textcolor: Colors.white,
                                                      fontsize: _fontsize,
                                                    ),
                                                    ListItem(
                                                      parametro: "Localidad:",
                                                      texto: widget
                                                          .property.localidad,
                                                      bulletcolor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      textcolor: Colors.white,
                                                      fontsize: _fontsize,
                                                    ),
                                                    ListItem(
                                                      parametro: "Dirección:",
                                                      texto: widget
                                                          .property.direccion,
                                                      bulletcolor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      textcolor: Colors.white,
                                                      fontsize: _fontsize,
                                                    ),
                                                  ]),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                10 *
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                10 *
                                                7,
                                        child: GoogleMap(
                                          onMapCreated: _onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                            target: _center,
                                            zoom: 13.0,
                                          ),
                                          markers: _markers.values.toSet(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(58, 184, 234, 1)),
                          minimumSize: MaterialStateProperty.all(Size(150, 40)),
                        ),
                        child: Text("Cerrar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ],
              ),

              /*     ClipRRect(
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 10 * 9 / 15 * 2,
                      color: Color.fromRGBO(191, 191, 191, 0.78),
                      child: Text("Hi modal sheet")),*/
            ),
          ),
        ));
  }
}
