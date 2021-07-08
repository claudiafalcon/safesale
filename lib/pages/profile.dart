import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/auth_credentials.dart';
import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';

class ProfilePage extends StatefulWidget {
  final AuthFlowStatus authstatus;
  final SignedCredentials credentials;
  final VoidCallback shouldLogOut;
  final VoidCallback detachDevice;

  const ProfilePage(
      {Key key,
      this.authstatus,
      this.credentials,
      this.shouldLogOut,
      this.detachDevice})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();

  void logout() async {
    await widget.detachDevice();
    _userService.resetUser();
    widget.shouldLogOut();
  }

  @override
  Widget build(BuildContext context) {
    //  widget.shouldLogOut();
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
                    Text(
                        "Hola: " +
                            (widget.credentials != null
                                ? (widget.credentials.name != null
                                    ? widget.credentials.name
                                    : widget.credentials.username)
                                : ''),
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
                      height: 5 * padding,
                    ),
                    Text(
                        "Email: " +
                            (widget.credentials != null
                                ? widget.credentials.username
                                : ''),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.height *
                                factorFontInput,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: logout,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(58, 184, 234, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text("Cerrar Sesión",
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
