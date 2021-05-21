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
import 'package:safesale/variables.dart';

class SearchPage extends StatefulWidget {
  final AuthFlowStatus status;
  final void Function(String) toggleplay;
  final void Function(bool) thereisanopenwindow;

  SearchPage(this.status, this.toggleplay, this.thereisanopenwindow);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  var _criterio = new SearchCriterio();
  final _searchService = SearchService();

  void changeNumberValue(String key, val) {
    switch (key) {
      case "terrenom2":
        _criterio.terrenom2 = int.parse(val);
        break;
      case "construccionm2":
        _criterio.construccionm2 = int.parse(val);
        break;
      case "preciofrom":
        _criterio.preciofrom = int.parse(val);
        break;
      case "precioto":
        _criterio.precioto = int.parse(val);
        break;
    }
  }

  Widget getNumberInput(
      String key, String unit, double boxsize, double fontsize) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9 / 12 * 2.5,
        height: boxsize / 2.5,
        child: TextFormField(
          onChanged: (val) => changeNumberValue(key, val),
          onSaved: (val) => changeNumberValue(key, val),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              hintText: unit,
              hintStyle: TextStyle(fontSize: fontsize),
              contentPadding: EdgeInsets.only(top: fontsize / 6),
              border: const OutlineInputBorder()),
        ));
  }

  Widget getAPairOfNumberInputs(double boxsize, String fromText, String fromkey,
      String toText, String toKey, String unit) {
    var _fontsize = MediaQuery.of(context).size.height * factorFontSmall;
    return Container(
      height: boxsize,
      child: Align(
        alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(fromText + ":  ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(0, 59, 139, 1),
                      fontSize: _fontsize,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              getNumberInput(fromkey, unit, boxsize, _fontsize),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9 / 50 * 1,
                height: boxsize / 2.5,
              ),
              Text(toText + ":  ",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(0, 59, 139, 1),
                      fontSize: _fontsize,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
              getNumberInput(toKey, unit, boxsize, _fontsize),
            ]),
      ),
    );
  }

  Widget getOptionint(String parametro, String position, double size) {
    var _fontsize = MediaQuery.of(context).size.height * factorFontSmall;
    Color color = Colors.white;
    switch (parametro) {
      case "recamaras":
        if ((_criterio.recamaras == null && position == "Todo") ||
            (position != "Todo" &&
                _criterio.recamaras == int.parse(position))) {
          color = Color.fromRGBO(0, 59, 139, 1);
        }
        break;
      case "baths":
        if ((position != "Todo" && _criterio.baths == int.parse(position)) ||
            (_criterio.baths == null && position == "Todo")) {
          color = Color.fromRGBO(0, 59, 139, 1);
        }
        break;
      case "estacionamientos":
        if ((position != "Todo" &&
                _criterio.estacionamientos == int.parse(position)) ||
            (_criterio.estacionamientos == null && position == "Todo")) {
          color = Color.fromRGBO(0, 59, 139, 1);
        }
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          switch (parametro) {
            case "recamaras":
              _criterio.recamaras =
                  position == "Todo" ? null : int.parse(position);
              break;
            case "baths":
              _criterio.baths = position == "Todo" ? null : int.parse(position);
              break;
            case "estacionamientos":
              _criterio.estacionamientos =
                  position == "Todo" ? null : int.parse(position);
              break;
          }
        });
      },
      child: ClipRect(
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(0, 59, 139, 1),
                      width: 1.0,
                      style: BorderStyle.solid),
                  color: color),
              width: MediaQuery.of(context).size.width * 0.9 / 7 * 1,
              height: size,
              child: Center(
                child: Text(position + (position == "Todo" ? "" : "+"),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: color == Color.fromRGBO(0, 59, 139, 1)
                            ? Colors.white
                            : Color.fromRGBO(0, 59, 139, 1),
                        fontSize: _fontsize,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
              ))),
    );
  }

  Widget getTipoNumerico(double boxsize, String value) {
    return Container(
      height: boxsize,
      child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getOptionint(value, "Todo", boxsize / 2),
              getOptionint(value, "1", boxsize / 2),
              getOptionint(value, "2", boxsize / 2),
              getOptionint(value, "3", boxsize / 2),
              getOptionint(value, "4", boxsize / 2),
            ],
          )),
    );
  }

  Widget getIconCheckbox(
      double size, String parameter, String option, String svg) {
    Color color = Color.fromRGBO(167, 167, 167, 1);
    switch (parameter) {
      case "tipo":
        if (_criterio.tipo == option) color = Color.fromRGBO(0, 59, 139, 1);
        break;
      case "amenidades":
        if (_amenidades.contains(option)) color = Color.fromRGBO(0, 59, 139, 1);
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          switch (parameter) {
            case "tipo":
              _criterio.tipo == option
                  ? _criterio.tipo = ''
                  : _criterio.tipo = option;
              break;
            case "amenidades":
              _amenidades.contains(option)
                  ? _amenidades.remove(option)
                  : _amenidades.add(option);
              break;
          }
        });
      },
      child: SvgPicture.asset(svg, width: size, height: size, color: color),
    );
  }

  Widget getAmenidadesOptions(double boxsize) {
    return Container(
        height: boxsize,
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(boxsize / 6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getIconCheckbox(boxsize / 2, "amenidades",
                        "Salón de Usos Múltiples", 'images/SALONMULTIPLE.svg'),
                    getIconCheckbox(boxsize / 2, "amenidades", "Gimnasio",
                        'images/GYM.svg'),
                    getIconCheckbox(boxsize / 2, "amenidades", "Jardín",
                        'images/JARDIN.svg'),
                    getIconCheckbox(boxsize / 2, "amenidades", "Roof Garden",
                        'images/ROOFGARDEN.svg'),
                    getIconCheckbox(boxsize / 2, "amenidades", "Ludoteca",
                        "images/LUDOTECA.svg"),
                    getIconCheckbox(boxsize / 2, "amenidades", "Alberca",
                        'images/ALBERCA.svg')
                  ]),
            )));
  }

  Widget getTipoOptions(double boxsize) {
    return Container(
        height: boxsize,
        child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(boxsize / 6),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getIconCheckbox(
                        boxsize / 2, "tipo", "casa", 'images/CASA.svg'),
                    getIconCheckbox(boxsize / 2, "tipo", "terreno",
                        'images/TERRENO AZUL.svg'),
                    getIconCheckbox(boxsize / 2, "tipo", "departamento",
                        'images/DEPARTAMENTOS.svg'),
                  ]),
            )));
  }

  List _amenidades = [];
  @override
  Widget build(BuildContext context) {
    var _padding = MediaQuery.of(context).size.height * factorPaddingSmallSpace;
    var _fontsize = MediaQuery.of(context).size.height * factorFontSmall;
    var _boxsize = MediaQuery.of(context).size.height / 10 * 1;
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
                child: Container(
                  width: double.infinity,
                  //color: Color.fromRGBO(67, 73, 75, 0.83),
                  height: MediaQuery.of(context).size.height / 10 * 7.5,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: _padding,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height:
                                MediaQuery.of(context).size.height / 10 * 7.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        10 *
                                        factorPaddingSpace,
                                  ),
                                  Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      child: Stack(children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .9,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        Container(
                                          child: TextFormField(
                                            textAlign: TextAlign.start,
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Busca por ubicación o palabra clave",
                                              prefixIcon: Icon(Icons.search),
                                              filled: false,
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
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
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: _boxsize,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Tipo de Inmueble",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getTipoOptions(_boxsize),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Récamaras",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getTipoNumerico(
                                                  _boxsize, "recamaras"),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Baños",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getTipoNumerico(
                                                  _boxsize, "baths"),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Estacionamientos",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getTipoNumerico(
                                                  _boxsize, "estacionamientos"),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Dimensiones",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getAPairOfNumberInputs(
                                                  _boxsize,
                                                  "Terreno > a",
                                                  "terrenom2",
                                                  "Construcción > a",
                                                  "construccionm2",
                                                  "m2"),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Precio",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getAPairOfNumberInputs(
                                                  _boxsize,
                                                  "     Desde",
                                                  "preciofrom",
                                                  "        Hasta",
                                                  "precioto",
                                                  "MXN"),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                  Center(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(_padding / 2),
                                        child: Container(
                                            color: Colors.white,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10 *
                                                1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            child: Stack(children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    _padding / 7),
                                                child: Text("Amenidades",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.raleway(
                                                      textStyle: TextStyle(
                                                        color: Color.fromRGBO(
                                                            0, 59, 139, 1),
                                                        fontSize: _fontsize,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                              ),
                                              getAmenidadesOptions(_boxsize),
                                            ]))),
                                  ),
                                  Container(
                                    height: _padding / 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(_padding / 2),
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
                                          minimumSize:
                                              MaterialStateProperty.all(Size(
                                                  _boxsize / 3, _boxsize / 2)),
                                        ),
                                        child: Text("Crear Alerta",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.raleway(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: _fontsize * 1.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                        onPressed: () {
                                          // Validate returns true if the form is valid, or false
                                          // otherwise.

                                          if (_formKey.currentState
                                              .validate()) {
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
                                    minimumSize: MaterialStateProperty.all(
                                        Size(_boxsize / 3, _boxsize / 2)),
                                  ),
                                  child: Text("Buscar",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: _fontsize * 1.5,
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
                                      _searchService.searchProperties(
                                          _criterio, null);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: _boxsize / 4,
                        ),

                        /*     ClipRRect(
                    child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 10 * 9 / 15 * 2,
                        color: Color.fromRGBO(191, 191, 191, 0.78),
                        child: Text("Hi modal sheet")),*/
                      ]),
                ),
              )),
        ),
      ),
    );
  }
}
