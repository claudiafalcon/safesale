import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
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
  final VoidCallback shouldShowResetPassword;
  final String error;

  LoginPage(
      {Key key,
      this.didProvideCredentials,
      this.shouldShowsSingUp,
      this.error,
      this.shouldUpdateDevice,
      this.shouldShowResetPassword})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _validate = false;
  bool _isObscure = true;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  GlobalKey<FormState> _key = new GlobalKey();

  void _login() async {
    if (_key.currentState.validate()) {
      final username = emailcontroller.text.trim().toLowerCase();
      final password = passwordcontroller.text.trim();

      final credentials =
          LoginCredentials(username: username, password: password);
      await widget.didProvideCredentials(credentials);

      CognitoAuthSession res = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));

      if (res.isSignedIn) {
        widget.shouldUpdateDevice();
      }
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
                            controller: emailcontroller,
                            text: "E-mail",
                            validator: "email"),
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
                              isPassword: true,
                              validator: "")),
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: widget.shouldShowResetPassword,
                            child: Text("¿Olvidaste tu contraseña?",
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
      ),
    );
  }
}
