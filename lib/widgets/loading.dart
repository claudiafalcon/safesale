import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/painters/softpaint.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PainterSoft(
          Color.fromRGBO(58, 184, 234, 1), Colors.white, Colors.white, 0, 20),
      child: Container(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(child: SvgPicture.asset('images/LoadingImage.svg')),
              Container(
                child: Text("Cargando ...",
                    style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                        color: Color(0xff003b8b),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    textAlign: TextAlign.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
