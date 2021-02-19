import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/painters/softpaint.dart';

class EmptyPage extends StatefulWidget {
  @override
  _EmptyPageState createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
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
                child: Text("No hay Resultados",
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
