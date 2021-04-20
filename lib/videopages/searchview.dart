import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/models/searchcriterio.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/services/user_service.dart';

class SearchPage extends StatefulWidget {
  final AuthFlowStatus status;

  final void Function() togglereloading;

  SearchPage(this.status, this.togglereloading);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  var _criterio = new SearchCriterio();
  final _searchService = SearchService();

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
              child: CustomPaint(
                painter: PainterSoft(
                    Color.fromRGBO(52, 57, 59, 0.5),
                    Color.fromRGBO(0, 59, 139, 0.5),
                    Color.fromRGBO(52, 57, 59, 0.5),
                    0,
                    20),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    //color: Color.fromRGBO(67, 73, 75, 0.83),
                    height: MediaQuery.of(context).size.height / 10 * 9.5,
                    child: Wrap(children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 5,
                            ),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * .9,
                                child: Stack(children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
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
                                        _criterio.criteria = value;
                                        return null;
                                      },
                                      onSaved: (val) =>
                                          _criterio.criteria = val,
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Tipo de Inmueble",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              9,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.tipo == 'casa'
                                                        ? _criterio.tipo = ''
                                                        : _criterio.tipo =
                                                            'casa';
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/CASA.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color:
                                                      _criterio.tipo == 'casa'
                                                          ? Color.fromRGBO(
                                                              0, 59, 139, 1)
                                                          : Color.fromRGBO(
                                                              167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.tipo == 'terreno'
                                                        ? _criterio.tipo = ''
                                                        : _criterio.tipo =
                                                            'terreno';
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/TERRENO AZUL.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _criterio.tipo ==
                                                          'terreno'
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.tipo ==
                                                            'departamento'
                                                        ? _criterio.tipo = ''
                                                        : _criterio.tipo =
                                                            'departamento';
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/DEPARTAMENTOS.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _criterio.tipo ==
                                                          'departamento'
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Récamaras",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              9,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.recamaras = null;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid),
                                                            color: _criterio
                                                                        .recamaras ==
                                                                    null
                                                                ? Color.fromRGBO(
                                                                    0,
                                                                    59,
                                                                    139,
                                                                    1)
                                                                : Colors.white),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.9 /
                                                                7 *
                                                                1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("Todo",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .recamaras ==
                                                                          null
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.recamaras == 1
                                                        ? _criterio.recamaras =
                                                            null
                                                        : _criterio.recamaras =
                                                            1;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .recamaras ==
                                                                  1
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+1",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .recamaras ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.recamaras == 2
                                                        ? _criterio.recamaras =
                                                            null
                                                        : _criterio.recamaras =
                                                            2;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .recamaras ==
                                                                  2
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+2",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .recamaras ==
                                                                          2
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.recamaras == 3
                                                        ? _criterio.recamaras =
                                                            null
                                                        : _criterio.recamaras =
                                                            3;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .recamaras ==
                                                                  3
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+3",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .recamaras ==
                                                                          3
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.recamaras == 4
                                                        ? _criterio.recamaras =
                                                            null
                                                        : _criterio.recamaras =
                                                            4;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .recamaras ==
                                                                  4
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+4",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .recamaras ==
                                                                          4
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Baños",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              9,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.baths = null;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid),
                                                            color: _criterio
                                                                        .baths ==
                                                                    null
                                                                ? Color.fromRGBO(
                                                                    0,
                                                                    59,
                                                                    139,
                                                                    1)
                                                                : Colors.white),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.9 /
                                                                7 *
                                                                1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("Todo",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .baths ==
                                                                          null
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.baths == 1
                                                        ? _criterio.baths = null
                                                        : _criterio.baths = 1;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Color.fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid),
                                                            color: _criterio
                                                                        .baths ==
                                                                    1
                                                                ? Color.fromRGBO(
                                                                    0,
                                                                    59,
                                                                    139,
                                                                    1)
                                                                : Colors.white),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+1",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .baths ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.baths == 2
                                                        ? _criterio.baths = null
                                                        : _criterio.baths = 2;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .baths ==
                                                                  2
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+2",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .baths ==
                                                                          2
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.baths == 3
                                                        ? _criterio.baths = null
                                                        : _criterio.baths = 3;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .baths ==
                                                                  3
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+3",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .baths ==
                                                                          3
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.baths == 4
                                                        ? _criterio.baths = null
                                                        : _criterio.baths = 4;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .baths ==
                                                                  4
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+4",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .baths ==
                                                                          4
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Estacionamientos",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              9,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.estacionamientos =
                                                        null;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        0,
                                                                        59,
                                                                        139,
                                                                        1),
                                                                width: 1.0,
                                                                style: BorderStyle
                                                                    .solid),
                                                            color: _criterio
                                                                        .estacionamientos ==
                                                                    null
                                                                ? Color.fromRGBO(
                                                                    0,
                                                                    59,
                                                                    139,
                                                                    1)
                                                                : Colors.white),
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.9 /
                                                                7 *
                                                                1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("Todo",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .estacionamientos ==
                                                                          null
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.estacionamientos ==
                                                            1
                                                        ? _criterio
                                                                .estacionamientos =
                                                            null
                                                        : _criterio
                                                            .estacionamientos = 1;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .estacionamientos ==
                                                                  1
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+1",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .estacionamientos ==
                                                                          1
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.estacionamientos ==
                                                            2
                                                        ? _criterio
                                                                .estacionamientos =
                                                            null
                                                        : _criterio
                                                            .estacionamientos = 2;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .estacionamientos ==
                                                                  2
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+2",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .estacionamientos ==
                                                                          2
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.estacionamientos ==
                                                            3
                                                        ? _criterio
                                                                .estacionamientos =
                                                            null
                                                        : _criterio
                                                            .estacionamientos = 3;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .estacionamientos ==
                                                                  3
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+3",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .estacionamientos ==
                                                                          3
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              )),
                                                        ))),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _criterio.estacionamientos ==
                                                            4
                                                        ? _criterio
                                                                .estacionamientos =
                                                            null
                                                        : _criterio
                                                            .estacionamientos = 4;
                                                  });
                                                },
                                                child: ClipRect(
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      59,
                                                                      139,
                                                                      1),
                                                              width: 1.0,
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: _criterio
                                                                      .estacionamientos ==
                                                                  4
                                                              ? Color.fromRGBO(
                                                                  0, 59, 139, 1)
                                                              : Colors.white,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.9 /
                                                            7 *
                                                            1,
                                                        height: 40,
                                                        child: Center(
                                                          child: Text("+4",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: _criterio
                                                                              .estacionamientos ==
                                                                          4
                                                                      ? Colors
                                                                          .white
                                                                      : Color.fromRGBO(
                                                                          0,
                                                                          59,
                                                                          139,
                                                                          1),
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Dimensiones",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              8,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Terreno > a:  ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9 /
                                                      12 *
                                                      2,
                                                  height: 30,
                                                  child: TextFormField(
                                                    onChanged: (val) =>
                                                        _criterio.terrenom2 =
                                                            int.parse(val),
                                                    onSaved: (val) =>
                                                        _criterio.terrenom2 =
                                                            int.parse(val),
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    decoration: InputDecoration(
                                                        hintText: 'm2',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14),
                                                        border:
                                                            const OutlineInputBorder()),
                                                  )),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9 /
                                                    50 *
                                                    1,
                                                height: 30,
                                              ),
                                              Text("Construcción > a:  ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9 /
                                                      12 *
                                                      2,
                                                  height: 30,
                                                  child: TextFormField(
                                                    onChanged: (val) => _criterio
                                                            .construccionm2 =
                                                        int.parse(val),
                                                    onSaved: (val) => _criterio
                                                            .construccionm2 =
                                                        int.parse(val),
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    decoration: InputDecoration(
                                                        hintText: 'm2',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14),
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Precio",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              8,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Desde:  ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9 /
                                                      12 *
                                                      3,
                                                  height: 30,
                                                  child: TextFormField(
                                                    onSaved: (val) =>
                                                        _criterio.preciofrom =
                                                            int.parse(val),
                                                    onChanged: (val) =>
                                                        _criterio.preciofrom =
                                                            int.parse(val),
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    decoration: InputDecoration(
                                                        hintText: 'MXN',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14),
                                                        border:
                                                            const OutlineInputBorder()),
                                                  )),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9 /
                                                    12 *
                                                    1,
                                                height: 30,
                                              ),
                                              Text("Hasta:  ",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 59, 139, 1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9 /
                                                      12 *
                                                      3,
                                                  height: 30,
                                                  child: TextFormField(
                                                    onChanged: (val) =>
                                                        _criterio.precioto =
                                                            int.parse(val),
                                                    onSaved: (val) =>
                                                        _criterio.precioto =
                                                            int.parse(val),
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textAlign: TextAlign.center,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
                                                    decoration: InputDecoration(
                                                        hintText: 'MXN',
                                                        hintStyle: TextStyle(
                                                            fontSize: 14),
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
                                  height: MediaQuery.of(context).size.height /
                                      10 *
                                      1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: Stack(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Amenidades",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 59, 139, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              100 *
                                              9,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades
                                                            .contains("Balcon")
                                                        ? _amenidades
                                                            .remove("Balcon")
                                                        : _amenidades
                                                            .add("Balcon");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/BALCON.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades
                                                          .contains("Balcon")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades
                                                            .contains("Alberca")
                                                        ? _amenidades
                                                            .remove("Alberca")
                                                        : _amenidades
                                                            .add("Alberca");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/ALBERCA.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades
                                                          .contains("Alberca")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades.contains(
                                                            "Elevador")
                                                        ? _amenidades
                                                            .remove("Elevador")
                                                        : _amenidades
                                                            .add("Elevador");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/ELEVADOR.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades
                                                          .contains("Elevador")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades
                                                            .contains("Asador")
                                                        ? _amenidades
                                                            .remove("Asador")
                                                        : _amenidades
                                                            .add("Asador");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/ASADOR.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades
                                                          .contains("Asador")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades.contains(
                                                            "Areas Verdes")
                                                        ? _amenidades.remove(
                                                            "Areas Verdes")
                                                        : _amenidades.add(
                                                            "Areas Verdes");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/AREAS VERDES.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades.contains(
                                                          "Areas Verdes")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _amenidades.contains(
                                                            "Areas Comunes")
                                                        ? _amenidades.remove(
                                                            "Areas Comunes")
                                                        : _amenidades.add(
                                                            "Areas Comunes");
                                                  });
                                                },
                                                child: SvgPicture.asset(
                                                  'images/AREAS COMUNES.svg',
                                                  width: 40,
                                                  height: 40,
                                                  color: _amenidades.contains(
                                                          "Areas Comunes")
                                                      ? Color.fromRGBO(
                                                          0, 59, 139, 1)
                                                      : Color.fromRGBO(
                                                          167, 167, 167, 1),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment:
                                widget.status == AuthFlowStatus.session
                                    ? MainAxisAlignment.spaceEvenly
                                    : MainAxisAlignment.center,
                            children: [
                              widget.status == AuthFlowStatus.session
                                  ? ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    58, 184, 234, 1)),
                                        minimumSize: MaterialStateProperty.all(
                                            Size(100, 40)),
                                      ),
                                      child: Text("Crear Alerta",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                      onPressed: () {
                                        // Validate returns true if the form is valid, or false
                                        // otherwise.

                                        if (_formKey.currentState.validate()) {
                                          if (_amenidades.length > 0)
                                            _criterio.amenidades =
                                                _amenidades.join(" OR ");

                                          // If the form is valid, display a Snackbar.
                                          UserService _userservice =
                                              new UserService();
                                          _userservice.addAlert(_criterio);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(58, 184, 234, 1)),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(100, 40)),
                                ),
                                child: Text("Buscar",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false
                                  // otherwise.

                                  if (_formKey.currentState.validate()) {
                                    if (_amenidades.length > 0)
                                      _criterio.amenidades =
                                          _amenidades.join(" OR ");

                                    // If the form is valid, display a Snackbar.
                                    _searchService.searchProperties(_criterio);
                                    Navigator.of(context).pop();
                                    widget.togglereloading();
                                  }
                                },
                              ),
                            ],
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
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
