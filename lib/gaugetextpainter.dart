import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gauge/flutter_gauge.dart';

import 'flutter_gauge.dart';

enum TickWidth { thin, wide }

enum TickLength { short, long }

/// enum that represents tick offset
enum TickPosition {
  /// inside the ring
  inside,

  /// outside the ring
  outside,

  /// above the ring
  above
}

/// This class represents datta needed to paint a tick on the gauge
class Tick {
  /// percent at which the tick is placed. It is from 0 to 1 inclusive
  final double percent;

  /// [Color] in which the tick is drawn
  final Color color;

  /// Tick's line width
  final TickWidth width;

  /// Tick's length
  final TickLength length;

  /// Position for tick (inside or outside the gauge)
  final TickPosition position;

  /// Text for the tick.
  final String text;

  /// Position to draw text
  final NumberInAndOut numberInAndOut;

  double get calcWidth {
    final textPainter = _makeTextPainter();

    textPainter.layout();

    return textPainter.width;
  }

  Tick({
    this.percent,
    this.color,
    this.width,
    this.length,
    this.position,
    this.text,
    this.numberInAndOut,
  });

  static List<Tick> allGreyNoNumbers() => List<int>.generate(101, (i) => i + 1)
      .map(
        (i) => Tick(
          percent: (i - 1) * 0.01,
          color: Colors.white38,
          width: TickWidth.thin,
          length: TickLength.long,
          position: TickPosition.above,
          text: "",
          numberInAndOut: NumberInAndOut.inside,
        ),
      )
      .toList();

  static List<Tick> testTicks() {
    var ticks = <Tick>[];
    // сперва зарубки внутренние для зарработка
    ticks += List<int>.generate(5, (i) => i + 1)
        .map((i) => Tick(
              percent: (i - 1) * 0.25,
              position: TickPosition.inside,
              length: TickLength.short,
              width: TickWidth.thin,
              color: Colors.black,
              text: "${2500 * (i - 1)}",
              numberInAndOut: NumberInAndOut.inside,
            ))
        .toList();
    // теперь внешние для процентов

    return ticks;
  }
}

class GaugeTextPainter extends CustomPainter {
  final Paint tickPaint;
  // final double radius;
  final TextPainter textPainter;

  final double widthCircle;
  final List<Tick> ticks;

  GaugeTextPainter({
    this.widthCircle,
    // this.radius,
    this.ticks,
  })  : tickPaint = Paint(),
        textPainter = _makeTextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (ticks == null || ticks.isEmpty) {
      return;
    }

    final radius = (size.width / 2);

    canvas.save();
    canvas.translate(radius, radius);

    for (Tick tick in ticks) {
      canvas.save();
      canvas.rotate(-pi / 2 + pi * tick.percent);
      tickPaint.color = Colors.red; //tick.color;
      tickPaint.strokeWidth = tick.width == TickWidth.thin ? 1.0 : 2.0;

      final len = tick.length == TickLength.long ? 20 : 10;
      var o1 = 0.0;
      var o2 = 0.0;

      switch (tick.position) {
        case TickPosition.inside:
          o1 = widthCircle / 2;
          o2 = widthCircle / 2 + len;
          break;

        case TickPosition.outside:
          o1 = -widthCircle / 2 - len;
          o2 = -widthCircle / 2;
          break;

        case TickPosition.above:
          o1 = len / 2;
          o2 = -len / 2;
          break;
      }

      canvas.drawLine(
        new Offset(0.0, -radius + o1),
        new Offset(0.0, -radius + o2),
        tickPaint,
      );

      if (tick.text != null && tick.text.isNotEmpty) {
        canvas.save();
        if (tick.numberInAndOut == NumberInAndOut.inside) {
          if (tick.position == TickPosition.inside) {
            canvas.translate(0.0, -radius + widthCircle + len);
          } else {
            canvas.translate(0.0, -radius + widthCircle);
          }
          canvas.rotate(-pi / 2);
        } else {
          if (tick.position == TickPosition.outside) {
            canvas.translate(0.0, -radius - widthCircle - len);
          } else {
            canvas.translate(0.0, -radius - widthCircle);
          }
          canvas.rotate(pi / 2);
        }

        textPainter.text = new TextSpan(
          text: tick.text,
          style: TextStyle(backgroundColor: Colors.red, fontSize: 12),
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          new Offset(-(textPainter.width / 2) - 5, -(textPainter.height / 2)),
        );
        canvas.restore();
      }
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(GaugeTextPainter oldDelegate) {
    return false;
  }
}

///counter text bottom
class GaugeTextCounter extends CustomPainter {
  final hourTickMarkLength = 30.0;
  final minuteTickMarkLength = 0.0;

  final hourTickMarkWidth = 1.5;
  final minuteTickMarkWidth = 1.0;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  int end;
  int start;
  double value;
  String fontFamily;
  CounterAlign counterAlign;
  double width;
  bool isDecimal;

  GaugeTextCounter({
    this.isDecimal,
    this.width,
    this.counterAlign,
    this.start,
    this.end,
    this.value,
    this.fontFamily,
    this.textStyle,
  })  : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ) {
    tickPaint.color = Colors.green;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final angle = 2 * pi / 60;
    final radius = size.width / 2;
    canvas.save();
    canvas.translate(radius, radius);
    for (var i = 0; i <= 60; i++) {
      if (i == 30) {
        String label;

        if (isDecimal == true) {
          label = this.value.toStringAsFixed(1);
        } else {
          label = (this.value.toInt()).toString();
        }

        canvas.save();

        if (counterAlign == CounterAlign.bottom) {
          canvas.translate(0.0, -radius + (60));
        } else if (counterAlign == CounterAlign.top) {
          canvas.translate(0.0, radius - (40));
        }

        textPainter.text = new TextSpan(text: label, style: textStyle);
        canvas.rotate(-angle * i);

        textPainter.layout();

        textPainter.paint(
            canvas,
            new Offset(-(textPainter.width / 2),
                counterAlign == CounterAlign.center ? -width : 0));

        canvas.restore();
      }

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(GaugeTextCounter oldDelegate) {
    return false;
  }
}

TextPainter _makeTextPainter() => TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
