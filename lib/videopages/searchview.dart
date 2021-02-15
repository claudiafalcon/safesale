import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final String id;
  SearchPage(this.id);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String _tipoInmueble;
  var _recamaras;
  var _banos;
  var _estacionamientos;
  String _criterio;
  var _terreno;
  var _construccion;
  var _precio_inferior;
  var _precio_superior;

  List _amenidades = [];
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ClipRRect(
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
                height: MediaQuery.of(context).size.height / 10 * 9.5,
                child: Wrap(children: [
                  Container(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Stack(children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: false,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Por favor introduce un criterio de búsqueda';
                              }
                              return null;
                            },
                            onSaved: (val) => _criterio = val,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Tipo de Inmueble",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _tipoInmueble == 'Casa'
                                              ? _tipoInmueble = ''
                                              : _tipoInmueble = 'Casa';
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/CASA.svg',
                                        width: 40,
                                        height: 40,
                                        color: _tipoInmueble == 'Casa'
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _tipoInmueble == 'Terreno'
                                              ? _tipoInmueble = ''
                                              : _tipoInmueble = 'Terreno';
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/TERRENO AZUL.svg',
                                        width: 40,
                                        height: 40,
                                        color: _tipoInmueble == 'Terreno'
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _tipoInmueble == 'Departamento'
                                              ? _tipoInmueble = ''
                                              : _tipoInmueble = 'Departamento';
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/DEPARTAMENTOS.svg',
                                        width: 40,
                                        height: 40,
                                        color: _tipoInmueble == 'Departamento'
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Récamaras",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _recamaras = null;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  color: _recamaras == null
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Colors.white),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("Todo",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _recamaras ==
                                                                null
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _recamaras == 1
                                              ? _recamaras = null
                                              : _recamaras = 1;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _recamaras == 1
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+1",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _recamaras == 1
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _recamaras == 2
                                              ? _recamaras = null
                                              : _recamaras = 2;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _recamaras == 2
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+2",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _recamaras == 2
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _recamaras == 3
                                              ? _recamaras = null
                                              : _recamaras = 3;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _recamaras == 3
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+3",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _recamaras == 3
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _recamaras == 4
                                              ? _recamaras = null
                                              : _recamaras = 4;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _recamaras == 4
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+4",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _recamaras == 4
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Baños",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _banos = null;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  color: _banos == null
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Colors.white),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("Todo",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _banos == null
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _banos == 1
                                              ? _banos = null
                                              : _banos = 1;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  color: _banos == 1
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Colors.white),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+1",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _banos == 1
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _banos == 2
                                              ? _banos = null
                                              : _banos = 2;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _banos == 2
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+2",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _banos == 2
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _banos == 3
                                              ? _banos = null
                                              : _banos = 3;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _banos == 3
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+3",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _banos == 3
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _banos == 4
                                              ? _banos = null
                                              : _banos = 4;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _banos == 4
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+4",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: _banos == 4
                                                            ? Colors.white
                                                            : Color.fromRGBO(
                                                                0, 59, 139, 1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Estacionamientos",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _estacionamientos = null;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  color:
                                                      _estacionamientos == null
                                                          ? Color.fromRGBO(
                                                              0, 59, 139, 1)
                                                          : Colors.white),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("Todo",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color:
                                                            _estacionamientos ==
                                                                    null
                                                                ? Colors.white
                                                                : Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _estacionamientos == 1
                                              ? _estacionamientos = null
                                              : _estacionamientos = 1;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _estacionamientos == 1
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+1",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color:
                                                            _estacionamientos ==
                                                                    1
                                                                ? Colors.white
                                                                : Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _estacionamientos == 2
                                              ? _estacionamientos = null
                                              : _estacionamientos = 2;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _estacionamientos == 2
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+2",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color:
                                                            _estacionamientos ==
                                                                    2
                                                                ? Colors.white
                                                                : Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _estacionamientos == 3
                                              ? _estacionamientos = null
                                              : _estacionamientos = 3;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _estacionamientos == 3
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+3",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color:
                                                            _estacionamientos ==
                                                                    3
                                                                ? Colors.white
                                                                : Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _estacionamientos == 4
                                              ? _estacionamientos = null
                                              : _estacionamientos = 4;
                                        });
                                      },
                                      child: ClipRect(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(
                                                        0, 59, 139, 1),
                                                    width: 1.0,
                                                    style: BorderStyle.solid),
                                                color: _estacionamientos == 4
                                                    ? Color.fromRGBO(
                                                        0, 59, 139, 1)
                                                    : Colors.white,
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9 /
                                                  7 *
                                                  1,
                                              height: 40,
                                              child: Center(
                                                child: Text("+4",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color:
                                                            _estacionamientos ==
                                                                    4
                                                                ? Colors.white
                                                                : Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ))),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Dimensiones",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 8,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Terreno > a:  ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 59, 139, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9 /
                                                12 *
                                                2,
                                        height: 30,
                                        child: TextFormField(
                                          onSaved: (val) => _terreno = val,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          decoration: InputDecoration(
                                              hintText: 'm2',
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              border:
                                                  const OutlineInputBorder()),
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9 /
                                          12 *
                                          1,
                                      height: 30,
                                    ),
                                    Text("Construcción > a:  ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 59, 139, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9 /
                                                12 *
                                                2,
                                        height: 30,
                                        child: TextFormField(
                                          onSaved: (val) => _construccion = val,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          decoration: InputDecoration(
                                              hintText: 'm2',
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              border:
                                                  const OutlineInputBorder()),
                                        )),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Precio",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 8,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Desde:  ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 59, 139, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9 /
                                                12 *
                                                3,
                                        height: 30,
                                        child: TextFormField(
                                          onSaved: (val) =>
                                              _precio_inferior = val,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          decoration: InputDecoration(
                                              hintText: 'MXN',
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              border:
                                                  const OutlineInputBorder()),
                                        )),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9 /
                                          12 *
                                          1,
                                      height: 30,
                                    ),
                                    Text("Hasta:  ",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(0, 59, 139, 1),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9 /
                                                12 *
                                                3,
                                        height: 30,
                                        child: TextFormField(
                                          onSaved: (val) =>
                                              _precio_superior = val,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.bottom,
                                          decoration: InputDecoration(
                                              hintText: 'MXN',
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              border:
                                                  const OutlineInputBorder()),
                                        )),
                                  ]),
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 10 * 1,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Amenidades",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(0, 59, 139, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height:
                                MediaQuery.of(context).size.height / 100 * 9,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("Balcon")
                                              ? _amenidades.remove("Balcon")
                                              : _amenidades.add("Balcon");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/BALCON.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades.contains("Balcon")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("Alberca")
                                              ? _amenidades.remove("Alberca")
                                              : _amenidades.add("Alberca");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/ALBERCA.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades.contains("Alberca")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("Elevador")
                                              ? _amenidades.remove("Elevador")
                                              : _amenidades.add("Elevador");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/ELEVADOR.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades.contains("Elevador")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("Asador")
                                              ? _amenidades.remove("Asador")
                                              : _amenidades.add("Asador");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/ASADOR.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades.contains("Asador")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("AreasVerdes")
                                              ? _amenidades
                                                  .remove("AreasVerdes")
                                              : _amenidades.add("AreasVerdes");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/AREAS VERDES.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades
                                                .contains("AreasVerdes")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _amenidades.contains("AreasComunes")
                                              ? _amenidades
                                                  .remove("AreasComunes")
                                              : _amenidades.add("AreasComunes");
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        'images/AREAS COMUNES.svg',
                                        width: 40,
                                        height: 40,
                                        color: _amenidades
                                                .contains("AreasComunes")
                                            ? Color.fromRGBO(0, 59, 139, 1)
                                            : Color.fromRGBO(167, 167, 167, 1),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(0, 59, 139, 1)),
                          minimumSize: MaterialStateProperty.all(Size(100, 30)),
                        ),
                        child: Text("Buscar",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        onPressed: () {
                          // Validate returns true if the form is valid, or false
                          // otherwise.

                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                          }
                        },
                      ),
                    ),
                  )
                ]),

                /*     ClipRRect(
                child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 10 * 9 / 15 * 2,
                    color: Color.fromRGBO(191, 191, 191, 0.78),
                    child: Text("Hi modal sheet")),*/
              )),
        ),
      ),
    );
  }
}
