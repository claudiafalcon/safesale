import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth/formvalidator.dart';
import 'package:safesale/models/conversation.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/models/user.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/notification_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/widgets/listItem.dart';
import 'package:url_launcher/url_launcher.dart';

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class ContactPage extends StatefulWidget {
  final Property property;
  final bool isGuest;
  final String email;

  const ContactPage(this.property, this.isGuest, this.email, {Key key})
      : super(key: key);
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController dudecontroller = TextEditingController();

  //final emailController =  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _userService = UserService();
  final _notiService = NotificationService();
  void _sendquestion() async {
    final username = emailcontroller.text.trim().toLowerCase();
    final dude = dudecontroller.text.trim();
    // String contact = widget.property.asesor;
    User owner;
    User contact;
    bool contactNotRegister = false;

    if (!widget.isGuest)
      owner = _userService.getUser();
    else
      owner = await _userService.getUserByUsername(UserService.genericEmail);
    contact = await _userService.getUserByUsername(widget.property.asesor);
    if (contact == null) {
      contact = await _userService.getUserByUsername(UserService.genericEmail);
      contactNotRegister = true;
    }

    List<String> members = [];
    members.add(owner.id);
    members.add(contact.id);

    String id = await _notiService.createConvo(
        "Duda:" +
            widget.property.nombre +
            " de :" +
            (!widget.isGuest ? widget.email : username),
        "dude",
        members,
        widget.property.id);
    if (id != null) {
      await _notiService.createConvoLink(
          id, owner.id, widget.isGuest ? username : "");
      await _notiService.createConvoLink(
          id, contact.id, contactNotRegister ? widget.property.asesor : "");

      await _notiService.createMessage(
          id, owner.id, dude, widget.isGuest ? username : "");
    }

    Navigator.of(context).pop();
    // final credentials =
    //   LoginCredentials(username: username, password: password);
    //widget.didProvideCredentials(credentials);
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                      Padding(
                                        padding: EdgeInsets.all(padding),
                                      ),
                                      Text("Tienes dudas?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  factorFontTitle1 *
                                                  1.2,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )),
                                      SizedBox(
                                        height: padding,
                                      ),
                                      Text(
                                          "Revisa nuestra sección de preguntas frecuentes.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                factorFontSmall,
                                            fontWeight: FontWeight.normal,
                                          ))),
                                      SizedBox(
                                        height: padding,
                                      ),
                                      InkWell(
                                        onTap: () => _launchInBrowser(
                                            "http://appsafesale.com"),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Color(0xff003b8b),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Text("Aqui",
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
                                      SizedBox(
                                        height: padding,
                                      ),
                                      Text(
                                          "Si aún tienes dudas mándanos un mensaje.",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.raleway(
                                              textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                factorFontSmall,
                                            fontWeight: FontWeight.normal,
                                          ))),
                                      SizedBox(
                                        height: padding,
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
                                              ? widget.email
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 200,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: TextFormField(
                                              maxLines: 8,
                                              style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                color: Color(0xff003b8b),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    factorFontInput,
                                                fontWeight: FontWeight.w600,
                                              )),
                                              controller: dudecontroller,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 15,
                                                    bottom: 15,
                                                    right: 15),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 0.0),
                                                ),
                                                fillColor: Color.fromRGBO(
                                                    255, 255, 255, 0.9),
                                                filled: true,
                                                hintText:
                                                    "Escribenos tu duda ...",
                                                hintStyle: GoogleFonts.raleway(
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
                                                      BorderRadius.circular(20),
                                                ),
                                              ))),
                                      InkWell(
                                        onTap: () => _sendquestion(),
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
                                            child: Text("Enviar",
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
                                      SizedBox(
                                        height: 10,
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
