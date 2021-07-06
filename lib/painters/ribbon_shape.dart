import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/variables.dart';

class RibbonShape extends StatefulWidget {
  final String icon;
  final Color color;
  final int total;

  const RibbonShape(this.icon, this.color, this.total, {Key key})
      : super(key: key);
  @override
  RibbonShapeState createState() => RibbonShapeState();
}

class RibbonShapeState extends State<RibbonShape> {
  @override
  Widget build(BuildContext context) {
    final double _propertyIconSize =
        MediaQuery.of(context).size.height * factorRighBarVideoIconSize;
    return Container(
      width: _propertyIconSize * 2,
      height: _propertyIconSize * 2 +
          MediaQuery.of(context).size.height * factorSmallIconSize,
      child: Stack(children: [
        Container(
          height: _propertyIconSize * 2,
          width: _propertyIconSize * 2,
          decoration: new BoxDecoration(
              border: new Border.all(color: widget.color, width: 1.0),
              borderRadius: new BorderRadius.circular(50.0),
              color: widget.color,
              boxShadow: [new BoxShadow(color: widget.color, blurRadius: 8.0)]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              widget.icon,
              //width: _propertyIconSize,
              //height: _propertyIconSize,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          right: 1,
          bottom: _propertyIconSize -
              MediaQuery.of(context).size.height * factorSmallIconSize / 2,
          child: Container(
            width: MediaQuery.of(context).size.height * factorSmallIconSize,
            height: MediaQuery.of(context).size.height * factorSmallIconSize,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  new BoxShadow(color: widget.color, blurRadius: 8.0)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.total > 99
                      ? '99+'
                      : widget.total.toString(), //--total.toString(),
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: widget.color,
                      fontSize: MediaQuery.of(context).size.height *
                          factorFontSmall *
                          .8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //textAlign: TextAlign.center
                ),
              ],
            ),
          ),
        ),
      ]),
    );
    /* Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.height *
                  factorPropertyTitle *
                  0.1),
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
              width: MediaQuery.of(context).size.height *
                  factorPropertyTitle *
                  0.4,
              height: MediaQuery.of(context).size.height *
                  factorPropertyTitle *
                  0.5,
              color: widget.colorOne,
            ),
          ),
        ),*/
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(40.0, size.height);
    path.lineTo(size.width / 2, size.height - 20);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 10);

    var firstControlPoint = Offset(5.5, 2.0);
    var firstPoint = Offset(5.0, 5.0);
    path.quadraticBezierTo(size.width - 03, 0.5, size.width - 10, 0);

    var secondControlPoint = Offset(2.0, 7.5);
    var secondPoint = Offset(0.0, 15.0);
    //path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
    //  secondPoint.dx, secondPoint.dy);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
