import 'package:flutter/material.dart';
import 'package:safesale/variables.dart';

class RibbonShape extends StatefulWidget {
  final Color colorOne;
  final Color colorTwo;

  const RibbonShape(this.colorOne, this.colorTwo, {Key key}) : super(key: key);
  @override
  RibbonShapeState createState() => RibbonShapeState();
}

class RibbonShapeState extends State<RibbonShape> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          child: ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: MediaQuery.of(context).size.height *
                  factorPropertyTitle *
                  0.1,
              height: MediaQuery.of(context).size.height *
                  factorPropertyTitle *
                  0.1,
              color: widget.colorTwo,
            ),
          ),
        ),
        Container(
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
        ),
      ],
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
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
