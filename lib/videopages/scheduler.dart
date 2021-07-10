import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth/formvalidator.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/models/associated.dart';
import 'package:safesale/models/conversation.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/models/user.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/notification_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/utils.dart';
import 'package:safesale/variables.dart';

import 'package:intl/intl.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class SchedulerPage extends StatefulWidget {
  final Property property;
  final bool isGuest;
  final SignedCredentials credentials;
  final void Function(String) toggleplay;
  final void Function(bool) thereisanopenwindow;

  const SchedulerPage(this.property, this.isGuest, this.credentials,
      this.toggleplay, this.thereisanopenwindow,
      {Key key})
      : super(key: key);
  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  bool missingDate = false;

  bool _validate = false;
  String _hour = "ALL";
  String _date;

  //final emailController =  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _userService = UserService();
  final _notiService = NotificationService();

  void _showDialog({@required String text}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Alerta!",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _firstPress = true;
  void _sendquestion() async {
    if (_formKey.currentState.validate() && _date != null) {
      final username = emailcontroller.text.trim().toLowerCase();
      final name = namecontroller.text;
      final phone = phonecontroller.text.trim();
      // String contact = widget.property.asesor;
      User owner;
      User contact;
      bool contactNotRegister = false;
      Conversation conv;

      if (!widget.isGuest) {
        owner = _userService.getUser();
        if (owner.convs.length != 0) {
          conv = owner.convs.firstWhere(
              (element) => (element.property != null &&
                  element.property.id == widget.property.id &&
                  element.type == 'scheduler' &&
                  DateFormat('dd/MM/yyyy')
                      .parse(element.schedulerdate)
                      .isAfter(DateTime.now())), orElse: () {
            return null;
          });
        }
        if (conv != null) {
          Navigator.pop(context);
          _showDialog(text: "Tienes ya una visita próxima a esta casa.");
          // Navigator.of(context).pop();
          return;
        }
      } else {
        owner = await _userService.getUserByUsername(UserService.genericEmail);
        if (owner.convs.length != 0) {
          conv = owner.convs.firstWhere((element) {
            if (element.property != null &&
                element.property.id == widget.property.id &&
                element.type == 'scheduler' &&
                DateFormat('dd/MM/yyyy')
                    .parse(element.schedulerdate)
                    .isAfter(DateTime.now())) {
              Associated ass = element.associated.firstWhere(
                  (element) => (element.guestemail == username), orElse: () {
                return null;
              });
              if (ass != null) return true;
            }
            return false;
          });
        }
        if (conv != null) {
          Navigator.pop(context);
          _showDialog(text: "Tienes ya una visita próxima a esta casa.");
          //   Navigator.of(context).pop();
          return;
        }
      }

      contact = await _userService.getUserByUsername(widget.property.asesor);
      if (contact == null) {
        contact =
            await _userService.getUserByUsername(UserService.genericEmail);
        contactNotRegister = true;
      } else {
        if (contact.id == owner.id) {
          Navigator.pop(context);
          _showDialog(
              text:
                  "Tu eres el asesor de la casa, no puedes crear cita contigo mismo.");
          //    Navigator.of(context).pop();
          return;
        }
      }

      List<String> members = [];
      members.add(owner.id);
      members.add(contact.id);

      String textscheduler;
      switch (_hour) {
        case "ALL":
          textscheduler = " Cualquier hora";
          break;
        case "AM":
          textscheduler = " Por la mañana";
          break;
        case "AM":
          textscheduler = " Por la tarde";
          break;
      }

      String id = await _notiService.createConvo(
          "Cita:" +
              widget.property.nombre +
              " de:" +
              (!widget.isGuest
                  ? (widget.credentials.name != null
                          ? widget.credentials.name + " "
                          : "") +
                      widget.credentials.username
                  : username),
          "scheduler",
          members,
          widget.property.id,
          _date,
          _hour);
      if (id != null) {
        Navigator.of(context).pop();
        await _notiService.createConvoLink(
            id, owner.id, widget.isGuest ? username : "");
        await _notiService.createConvoLink(
            id, contact.id, contactNotRegister ? widget.property.asesor : "");

        await _notiService.createMessage(
            id,
            owner.id,
            "Cita:" +
                widget.property.nombre +
                " de: " +
                (!widget.isGuest
                    ? (widget.credentials.name != null
                        ? widget.credentials.name
                        : widget.credentials.username)
                    : name) +
                " con email: " +
                (!widget.isGuest ? widget.credentials.username : username) +
                " Tel: " +
                phone +
                " fecha: " +
                _date +
                textscheduler,
            widget.isGuest ? username : "");
      }

      if (!widget.isGuest) _userService.updateUser(owner.id);

      // final credentials =
      //   LoginCredentials(username: username, password: password);
      //widget.didProvideCredentials(credentials);
    } else {
      if (_date == null) missingDate = true;
      setState(() {
        _validate = true;
      });
    }
  }

  String _selectedDate = 'Elige una fecha';

  Future<void> _selectDate(BuildContext context) async {
    // initializeDateFormatting('es_MX', null);
    missingDate = false;
    DateTime pivote = DateTime.now().add(Duration(days: 2)).weekday == 7
        ? DateTime.now().add(Duration(days: 3))
        : DateTime.now().add(Duration(days: 2));
    final DateTime d = await showDatePicker(
      context: context,
      initialDate: pivote,
      firstDate:
          pivote.weekday == 1 ? pivote : pivote.subtract(Duration(days: 1)),
      lastDate: pivote.add(Duration(days: 90)),
      selectableDayPredicate: (DateTime val) => val.weekday == 7 ? false : true,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: UtilColor.createMaterialColor(Color(0xff003b8b)),
              primaryColorDark: Colors.teal,
              accentColor: Colors.teal,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
    );

    if (d != null) {
      setState(() {
        _selectedDate = new DateFormat.yMMMMd('es_MX').format(d);
        _date = new DateFormat('dd/MM/yyyy').format(d);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isGuest) {
      User owner = _userService.getUser();
      _userService.updateUser(owner.id);
    }
    // initializeDateFormatting('es_MX', null);
    var padding = MediaQuery.of(context).size.height * 0.04;
    double _fontsize = MediaQuery.of(context).size.height < 800 ? 10 : 14;

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
                                  Color.fromRGBO(58, 184, 234, 1),
                                  Color(0xff003b8b),
                                  Colors.white,
                                  0,
                                  20),
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 10 * 9,
                                height: MediaQuery.of(context).size.height /
                                    10 *
                                    8.2,
                                alignment: Alignment.center,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        'images/logofinal.svg',
                                        width:
                                            MediaQuery.of(context).size.height *
                                                factorAuthLogoWd,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                factorAuthLogoWd,
                                      ),
                                      widget.isGuest
                                          ? Text(
                                              "Esta es la casa de tus sueños, si deseas visitarla por favor déjanos tus datos y agenda una cita.",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          factorFontSmall *
                                                          1.2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ))
                                          : Text(
                                              "Hola ${widget.credentials.name != null ? widget.credentials.name : widget.credentials.username}",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          factorFontTitle1,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      widget.isGuest
                                          ? Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 20),
                                              child: TextFormField(
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          "[a-z A-Z á-ú Á-Ú]"))
                                                ],
                                                style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                  color: Color(0xff003b8b),
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          factorFontInput,
                                                  fontWeight: FontWeight.w600,
                                                )),
                                                controller: namecontroller,
                                                validator: (String value) {
                                                  return FormValidator()
                                                      .validateName(value);
                                                },
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 15,
                                                          top: 15,
                                                          bottom: 15,
                                                          right: 15),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.white,
                                                            width: 0.0),
                                                  ),
                                                  fillColor: Color.fromRGBO(
                                                      255, 255, 255, 0.9),
                                                  filled: true,
                                                  hintText: 'Dinos tu nombre',
                                                  hintStyle:
                                                      GoogleFonts.raleway(
                                                          textStyle: TextStyle(
                                                    color: Color(0xff003b8b),
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            factorFontInput,
                                                    fontWeight: FontWeight.w600,
                                                  )),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Text(
                                              "Esta es la casa de tus sueños, si deseas visitarla por favor agenda una cita.",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          factorFontSmall *
                                                          1.2,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          enableInteractiveSelection:
                                              widget.isGuest != true
                                                  ? false
                                                  : true,
                                          focusNode: widget.isGuest != true
                                              ? new AlwaysDisabledFocusNode()
                                              : null,
                                          style: GoogleFonts.raleway(
                                              textStyle: TextStyle(
                                            color: Color(0xff003b8b),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                factorFontInput,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          controller: widget.isGuest
                                              ? emailcontroller
                                              : null,
                                          validator: (String value) {
                                            return FormValidator()
                                                .validateEmail(value);
                                          },
                                          initialValue: widget.isGuest != true
                                              ? widget.credentials.username
                                              : null,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                top: 15,
                                                bottom: 15,
                                                right: 15),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 0.0),
                                            ),
                                            fillColor: Color.fromRGBO(
                                                255, 255, 255, 0.9),
                                            filled: true,
                                            hintText: 'E-mail',
                                            hintStyle: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                              color: Color(0xff003b8b),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  factorFontInput,
                                              fontWeight: FontWeight.w600,
                                            )),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(10)
                                          ],
                                          style: GoogleFonts.raleway(
                                              textStyle: TextStyle(
                                            color: Color(0xff003b8b),
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                factorFontInput,
                                            fontWeight: FontWeight.w600,
                                          )),
                                          controller: phonecontroller,
                                          validator: (String value) {
                                            return FormValidator()
                                                .validatePhone(value);
                                          },
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                top: 15,
                                                bottom: 15,
                                                right: 15),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 0.0),
                                            ),
                                            fillColor: Color.fromRGBO(
                                                255, 255, 255, 0.9),
                                            filled: true,
                                            hintText: 'Teléfono a 10 dígitos',
                                            hintStyle: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                              color: Color(0xff003b8b),
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  factorFontInput,
                                              fontWeight: FontWeight.w600,
                                            )),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          InkWell(
                                            child: Text(_selectedDate,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: missingDate == false
                                                        ? Colors.white
                                                        : Colors.red)),
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            color: Colors.white,
                                            tooltip: 'Elige una fecha',
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                          ),
                                        ],
                                      ),
                                      Table(children: [
                                        TableRow(children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text("Todo el día",
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            factorFontSmall,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 30,
                                              child: MergeSemantics(
                                                child: Row(
                                                  children: <Widget>[
                                                    Switch(
                                                      value: _hour == "ALL"
                                                          ? true
                                                          : false,
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          if (value)
                                                            _hour = "ALL";
                                                          else
                                                            _hour = "AM";
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text("Antes de las 12 pm",
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            factorFontSmall,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 30,
                                              child: MergeSemantics(
                                                child: Row(
                                                  children: <Widget>[
                                                    Switch(
                                                      value: _hour == "AM"
                                                          ? true
                                                          : false,
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          if (value)
                                                            _hour = "AM";
                                                          else
                                                            _hour = "ALL";
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Text("Antes de las 6pm",
                                                textAlign: TextAlign.right,
                                                style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            factorFontSmall,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )),
                                          ),
                                          TableCell(
                                            child: SizedBox(
                                              height: 30,
                                              child: MergeSemantics(
                                                child: Row(
                                                  children: <Widget>[
                                                    Switch(
                                                      value: _hour == "PM"
                                                          ? true
                                                          : false,
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              58, 184, 234, 1),
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          if (value)
                                                            _hour = "PM";
                                                          else
                                                            _hour = "ALL";
                                                        });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      ]),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => {_sendquestion()},
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(58, 184, 234, 1),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text("Agendar",
                                                style: GoogleFonts.raleway(
                                                    textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          factorFontTitle1,
                                                  fontWeight: FontWeight.w600,
                                                ))),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SizedBox(
                                          height: 10,
                                        ),
                                      ),
                                    ],
                                  ),
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
