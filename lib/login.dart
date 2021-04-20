import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/painters/softpaint.dart';

import 'variables.dart';

class LoginPage extends StatefulWidget {
  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowsSingUp;
  final VoidCallback shouldUpdateDevice;
  final String error;

  LoginPage(
      {Key key,
      this.didProvideCredentials,
      this.shouldShowsSingUp,
      this.error,
      this.shouldUpdateDevice})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  void _login() {
    final username = emailcontroller.text.trim().toLowerCase();
    final password = passwordcontroller.text.trim();

    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
    widget.shouldUpdateDevice();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(padding),
                      child: SvgPicture.asset(
                        'images/LoadingImage.svg',
                        width: MediaQuery.of(context).size.height *
                            factorAuthLogoWd,
                        height: MediaQuery.of(context).size.height *
                            factorAuthLogoWd,
                      ),
                    ),
                    Text("Bienvenido a Safe Sale",
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
                          controller: emailcontroller, text: "E-mail"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: InputDecorationPass(
                            controller: passwordcontroller,
                            text: "Password",
                            isPassword: true)),
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
                      onTap: () => _login(),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(58, 184, 234, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text("Login",
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
                        Text("¿No tienes cuenta?",
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height *
                                  factorFontInput,
                              fontWeight: FontWeight.normal,
                            ))),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: widget.shouldShowsSingUp,
                          child: Text("Registrate",
                              style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                color: Color.fromRGBO(58, 184, 234, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ))),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
