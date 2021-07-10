import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/painters/softpaint.dart';
import 'variables.dart';

class VerificationPassPage extends StatefulWidget {
  final ValueChanged<ResetCredentials> didProvideNewPassword;
  final VoidCallback shouldShowLogin;
  final String error;
  final String email;

  VerificationPassPage(
      {Key key,
      this.didProvideNewPassword,
      this.error,
      this.email,
      this.shouldShowLogin})
      : super(key: key);

  @override
  _VerificationPassPageState createState() => _VerificationPassPageState();
}

class _VerificationPassPageState extends State<VerificationPassPage> {
  TextEditingController _verificationcodecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  bool _validate = false;
  bool _isObscure = true;

  GlobalKey<FormState> _key = new GlobalKey();

  void _resetPassword() {
    if (_key.currentState.validate()) {
      final username = widget.email;
      final password = _passwordcontroller.text.trim();
      final verificationCode = _verificationcodecontroller.text.trim();
      final credentials = ResetCredentials(
          username: username,
          password: password,
          verificationCode: verificationCode);
      widget.didProvideNewPassword(credentials);
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  String mask(String email) {
    List str = email.split('@');
    String maskString = str[1];
    maskString = str[0].substring(0, 1).padRight(str[0].length, '*');
    str = str[1].split('.');
    maskString = maskString +
        '@' +
        str[0].substring(0, 1).padRight(str[0].length, '*') +
        "." +
        str[1];

    return maskString;
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
                      Text("Introduce tu nueva contraseña",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.height *
                                  factorFontTitle1,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: padding, right: padding, bottom: padding),
                        child: Text(
                            "Se ha enviado un código de verifación a tu correo: " +
                                mask(widget.email),
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height *
                                    factorFontSmall,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: InputDecorationPass(
                            controller: _verificationcodecontroller,
                            text: "Código de Verificación",
                            validator: "code"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          child: InputDecorationPass(
                              controller: _passwordcontroller,
                              text: "New Password",
                              isPassword: true,
                              validator: "password")),
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
                            child: Text("Restablecer",
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
                          Text("Ya has restablecido",
                              style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).size.height *
                                    factorFontInput,
                                fontWeight: FontWeight.normal,
                              ))),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: widget.shouldShowLogin,
                            child: Text("Firmate",
                                style: GoogleFonts.raleway(
                                    textStyle: TextStyle(
                                  color: Color.fromRGBO(58, 184, 234, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ))),
                          )
                        ],
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
