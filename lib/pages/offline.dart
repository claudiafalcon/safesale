import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safesale/models/alert.dart';
import 'package:safesale/models/searchcriterio.dart';

import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/search_service.dart';
import 'package:safesale/services/user_service.dart';
import 'package:safesale/variables.dart';

class OfflinePage extends StatefulWidget {
  final void Function(int) call;

  const OfflinePage({Key key, this.call}) : super(key: key);
  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(67, 73, 75, 0.8),
      child: CustomPaint(
          painter: PainterSoft(
              Color.fromRGBO(52, 57, 59, 0.5),
              Color.fromRGBO(0, 59, 139, 0.5),
              Color.fromRGBO(52, 57, 59, 0.5),
              0,
              20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: SvgPicture.asset('images/LoadingImage.svg')),
              Container(
                child: Text("Error de red",
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Color(0xffA6DDEB),
                        fontSize: MediaQuery.of(context).size.height *
                            factorFontTitle1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center),
              ),
              Container(
                child: Text("Conectate a Internet e inténtalo de nuevo",
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Color(0xffA6DDEB),
                        fontSize: MediaQuery.of(context).size.height *
                            factorFontSmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      widget.call(-1);
                    },
                    child: Text("Volver a Intentar",
                        style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                          color: Color.fromRGBO(58, 184, 234, 1),
                          fontSize: MediaQuery.of(context).size.height *
                              factorFontInput,
                          fontWeight: FontWeight.normal,
                        ))),
                  )
                ],
              )
            ],
          )),
    );
  }
}
