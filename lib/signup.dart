import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/policy.dart';
import 'package:safesale/variables.dart';

class SignUp extends StatefulWidget {
  final ValueChanged<SignUpCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;
  SignUp({Key key, this.didProvideCredentials, this.shouldShowLogin})
      : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();

  registeruser() {
    final name = namecontroller.text.trim().toUpperCase();
    final username = emailcontroller.text.trim().toLowerCase();
    final password = passwordcontroller.text.trim();
    print('Successfully configured Amplify  222🎉');
    final credentials =
        SignUpCredentials(name: name, username: username, password: password);

    print('Successfully configured Amplify  333🎉');

    widget.didProvideCredentials(credentials);
    print('AAA ${credentials.username}');
    return;
  }

  bool _lights = false;
  bool isVisible = true;
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
                    Padding(
                      padding: EdgeInsets.only(
                          left: padding, right: padding, bottom: padding),
                      child: Text(
                          "Recibe notificaciones y disfruta de la experiencia completa de la aplicación.",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: InputDecorationPass(
                          controller: namecontroller, text: "Nombre"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
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
                        isPassword: true,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsofPolicy())),
                          child: Text("Acepto el aviso de privacidad",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: MergeSemantics(
                            child: Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: isVisible,
                              child: ListTile(
                                title: Text(""),
                                leading: Switch(
                                  value: _lights,
                                  activeColor: Color.fromRGBO(58, 184, 234, 1),
                                  onChanged: (bool value) {
                                    setState(() {
                                      _lights = !_lights;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () => registeruser(),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(58, 184, 234, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text("Crear mi cuenta",
                              style: GoogleFonts.raleway(
                                  textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
