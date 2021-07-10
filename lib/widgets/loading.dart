import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/painters/softpaint.dart';

class LoadingPage extends StatefulWidget {
  final double opacity;

  const LoadingPage({this.opacity = 1});
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(child: SvgPicture.asset('images/LoadingImage.svg')),
            Container(
              child: Text("Cargando  ...",
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Color(0xffA6DDEB),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
}
