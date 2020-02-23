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

  /// Style of text to draw tick text with [TextStyle] object
  final TextStyle textStyle;

  double get calcWidth {
    if (text == null || text.trim().isEmpty) {
      return 0.0;
    }

    final textPainter = _makeTextPainter();
    textPainter.text = new TextSpan(
      text: text,
      style: TextStyle(backgroundColor: Colors.red, fontSize: 12),
    );

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
    this.textStyle,
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

  static List<Tick> testTicks({
    TickPosition tickPosition = TickPosition.outside,
    NumberInAndOut textPostion = NumberInAndOut.outside,
  }) {
    var ticks = <Tick>[];
    // сперва зарубки внутренние для зарработка
    ticks += List<int>.generate(5, (i) => i + 1)
        .map((i) => Tick(
              percent: (i - 1) * 0.25,
              position: tickPosition,
              length: TickLength.short,
              width: TickWidth.thin,
              color: Colors.black,
              text: "${2500 * (i - 1)}",
              numberInAndOut: textPostion,
            ))
        .toList();
    // теперь внешние для процентов

    return ticks;
  }
}

class GaugeTextPainter extends CustomPainter {
  final Paint tickPaint;
  final double radius;
  final TextPainter textPainter;

  final double widthCircle;
  final List<Tick> ticks;

  GaugeTextPainter({
    this.widthCircle,
    this.radius,
    this.ticks,
  })  : tickPaint = Paint(),
        textPainter = _makeTextPainter();

  @override
  void paint(Canvas canvas, Size size) {
    if (ticks == null || ticks.isEmpty) {
      return;
    }

    for (Tick tick in ticks) {
      canvas.save();
      canvas.translate(size.width / 2, size.height);
      canvas.rotate(-pi / 2 + pi * tick.percent);
      tickPaint.color = Colors.red; //tick.color;
      tickPaint.strokeWidth = tick.width == TickWidth.thin ? 1.0 : 2.0;

      final len = _getLenght(tick.length, widthCircle);
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
          o1 = -widthCircle / 2;
          o2 = widthCircle / 2;
          break;
      }

      canvas.drawLine(
        new Offset(0.0, -radius + o1),
        new Offset(0.0, -radius + o2),
        tickPaint,
      );

      canvas.restore();
      if (tick.text != null && tick.text.isNotEmpty) {
        canvas.save();
        canvas.translate(size.width / 2, size.height);

        var r = 0.0;
        if (tick.numberInAndOut == NumberInAndOut.inside) {
          if (tick.position == TickPosition.inside) {
            r = -radius + widthCircle / 2 + len;
          } else {
            r = -radius + widthCircle / 2;
          }
        } else {
          if (tick.position == TickPosition.outside) {
            r = -radius - widthCircle / 2 - len;
          } else {
            r = -radius - widthCircle / 2;
          }
        }

        final a = pi - pi * (1 - tick.percent);
        canvas.translate(r * cos(a), r * sin(a));

        // Для нашей ситуации, когда мы хотим писать текст строго горизонтально,
        // нам надо учитывать, в какой четверти мы его рисуем чтобы правильно задавать
        // выравнивание и направление текста
        textPainter.text = new TextSpan(
          text: tick.text,
          style: tick.textStyle ??
              TextStyle(backgroundColor: Colors.red, fontSize: 12),
        );

        textPainter.layout();

        textPainter.paint(canvas, _getOffset(tick, textPainter));

        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(GaugeTextPainter oldDelegate) {
    return false;
  }
}

/// Calculates offset for painting text using given textpainter
/// for given tick
///
/// @param tick - [Tick] to calculate offset for
/// @param painter - [TextPainter] to calculate offset for. It should be already layed out
///
/// @return [Offset] to be passed to [Texpainter.paint] method
Offset _getOffset(Tick tick, TextPainter painter) {
  if (tick.percent == 0.5) {
    // мы на самом верху, рисуем текст посередине
    return Offset(-painter.width / 2,
        tick.numberInAndOut == NumberInAndOut.outside ? -painter.height : 0.0);
  }

  if (tick.percent < 0.5) {
    if (tick.percent > .05)
      return Offset(
          tick.position == TickPosition.outside ? -painter.width : 0.0,
          tick.position == TickPosition.outside ? -painter.height : 0.0);
    else
      return Offset(
          tick.position == TickPosition.outside ? -painter.width : 0.0,
          -painter.height);
  }

  if (tick.percent < 0.95)
    return Offset(tick.position == TickPosition.outside ? 0.0 : -painter.width,
        tick.position == TickPosition.outside ? -painter.height : 0.0);
  else
    return Offset(tick.position == TickPosition.outside ? 0.0 : -painter.width,
        -painter.height);
}

double _getLenght(TickLength length, double ringWidth) {
  return length == TickLength.long ? ringWidth : ringWidth / 2;
}

TextPainter _makeTextPainter() => TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
