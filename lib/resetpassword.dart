import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/painters/softpaint.dart';

import 'variables.dart';

class ResetPasswordPage extends StatefulWidget {
  final ValueChanged<String> didProvideUserName;
  final VoidCallback shouldShowLogin;
  final String error;

  ResetPasswordPage(
      {Key key, this.shouldShowLogin, this.error, this.didProvideUserName})
      : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool _validate = false;
  bool _isObscure = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();

  void _resetPassword() {
    if (_key.currentState.validate()) {
      final username = emailcontroller.text.trim().toLowerCase();
      widget.didProvideUserName(username);
    } else {
      setState(() {
        _validate = true;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.04;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(67, 73, 75, 0.8),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(67, 73, 75, 0.0),
            child: CustomPaint(
              painter: PainterSoft(Color.fromRGBO(58, 184, 234, 1),
                  Color(0xff003b8b), Colors.white, 0, 20),
              child: Container(
                width: MediaQuery.of(context).size.width / 10 * 9,
                height: MediaQuery.of(context).size.height / 10 * 7.5,
                alignment: Alignment.center,
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(padding),
                        child: SvgPicture.asset(
                          'images/logofinal.svg',
                          width: MediaQuery.of(context).size.height *
                              factorAuthLogoWd,
                          height: MediaQuery.of(context).size.height *
                              factorAuthLogoWd,
                        ),
                      ),
                      Text("Restablece tu password",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height *
                                  factorFontTitle1,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      SizedBox(
                        height: 2 * padding,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: InputDecorationPass(
                            controller: emailcontroller,
                            text: "E-mail",
                            validator: "email"),
                      ),
                      widget.error != null
                          ? Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(widget.error,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            )
                          : SizedBox(
                              height: 30,
                            ),
                      InkWell(
                        onTap: () => _resetPassword(),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(58, 184, 234, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text("Enviar Código",
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontTitle1,
                                  fontWeight: FontWeight.w600,
                                ))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: widget.shouldShowLogin,
                            child: Text("Inicia sesión",
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                  color: Color.fromRGBO(58, 184, 234, 1),
                                  fontSize: MediaQuery.of(context).size.height *
                                      factorFontSmall,
                                  fontWeight: FontWeight.normal,
                                ))),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
