import 'dart:math';

import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  Color lineColor;
  double width;
  final angle = 2 * pi / 60;

  LinePainter({
    this.lineColor,
    this.width,
  });
  @override
  void paint(Canvas canvas, Size size) {
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height);
    double radius = min(size.width / 2, size.height) - width / 2;

    canvas.drawArc(
      new Rect.fromCircle(center: center, radius: radius),
      -pi,
      pi,
      false,
      line,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
