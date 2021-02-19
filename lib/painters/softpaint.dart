import 'package:flutter/material.dart';
import 'dart:ui';

class PainterSoft extends CustomPainter {
  final Color colorUp;
  final Color colorDown;
  final Color borderColor;
  final int index1;
  final int index2;

  PainterSoft(
      this.colorUp, this.colorDown, this.borderColor, this.index1, this.index2);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintback = Paint()..color = this.colorDown;

    Path pathback = Path();
    pathback.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(20)));
    canvas.drawPath(pathback, paintback);

    Paint paint = Paint();
    Path path = Path();
    int index1 = this.index1;
    int index2 = this.index2;
    // Path number 1
    //paint.style = PaintingStyle.stroke;

    paint.color = this.colorUp;
    path = Path();
    path.lineTo(0, size.height / 20 * index1 + 20);
    path.cubicTo(
        size.width / 30 * 1,
        (index1 * size.height / 20) + size.height * (index2 - index1) / 20 / 2,
        size.width / 30 * 25,
        (index2 * size.height / 20) - size.height * (index2 - index1) / 20 / 2,
        size.width,
        (size.height / 20 * index2) - 20);
    path.lineTo(size.width, 20);
    path.quadraticBezierTo(size.width, 0, size.width - 20, 0);
    path.lineTo(20, 0);
    path.quadraticBezierTo(0, 0, 0, 20);

    canvas.drawPath(path, paint);
    Paint paintborder = Paint()
      ..color = this.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path pathborder = Path();
    pathborder.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(20)));
    canvas.drawPath(pathborder, paintborder);

    Paint paintmiddle = Paint()
      ..color = this.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Path pathmiddle = Path();
    pathmiddle.moveTo(0, (index1 * size.height / 20) + 20);
    //path.lineTo(0, (index1 * size.height / 20) + 20);
    pathmiddle.cubicTo(
        size.width / 30 * 1,
        (index1 * size.height / 20) + size.height * (index2 - index1) / 20 / 2,
        size.width / 30 * 25,
        (index2 * size.height / 20) - size.height * (index2 - index1) / 20 / 2,
        size.width,
        (size.height / 20 * index2) - 20);
    canvas.drawPath(pathmiddle, paintmiddle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
