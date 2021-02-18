import 'package:flutter/material.dart';
import 'dart:ui';

class PainterSoft extends CustomPainter {
  final Color color;

  PainterSoft(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();
    Path pathborder = Path();

    Paint borderPaint = Paint()..strokeWidth = 3;
    borderPaint.style = PaintingStyle.stroke;

    borderPaint.color = Colors.white;

    // Path number 1
    //paint.style = PaintingStyle.stroke;

    paint.color = this.color;
    path = Path();
    path.lineTo(size.width, size.height);
    path.cubicTo(size.width, size.height * 0.88, size.width * 0.44,
        size.height * 0.84, size.width * 0.19, size.height * 0.81);
    path.cubicTo(size.width * 0.12, size.height * 0.8, size.width * 0.07,
        size.height * 0.8, size.width * 0.05, size.height * 0.79);
    path.cubicTo(-0.01, size.height * 0.78, 0, size.height * 0.71, 0,
        size.height * 0.71);
    path.cubicTo(
        0, size.height * 0.71, 0, size.height * 0.08, 0, size.height * 0.08);
    path.cubicTo(
        0, size.height * 0.03, size.width * 0.03, 0, size.width * 0.06, 0);
    path.cubicTo(
        size.width * 0.06, 0, size.width * 0.95, 0, size.width * 0.95, 0);
    path.cubicTo(size.width * 0.98, 0, size.width, size.height * 0.03,
        size.width, size.height * 0.08);
    path.cubicTo(size.width, size.height * 0.08, size.width, size.height,
        size.width, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
