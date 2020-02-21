library flutter_gauge;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gauge/fluttergauge.dart';
import 'package:flutter_gauge/gaugetextpainter.dart';
import 'package:rxdart/rxdart.dart';

export 'package:flutter_gauge/gaugetextpainter.dart';

enum SecondsMarker { minutes, secondsAndMinute, all, none, seconds }

enum Number {
  all,
  endAndStart,
  endAndCenterAndStart,
  none,
}

enum NumberInAndOut { inside, outside }

enum CounterAlign {
  none,
  center,
  top,
  bottom,
}

enum Hand { none, long, short }

enum Animate { none, knock, forget }

class FlutterGauge extends StatefulWidget {
  final int start;
  final int end;
  final String fontFamily;
  final double widthCircle;
  final double index;
  final double width;
  final CounterAlign counterAlign;
  final Hand hand;
  final bool isCircle;
  final double handSize;
  final bool isDecimal;
  final double shadowHand;
  final Color circleColor;
  final Color handColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final double paddingHand;
  final Animate animate;
  final TextStyle counterStyle;

  final List<Tick> ticks;

  FlutterGauge({
    this.isDecimal = true,
    this.counterStyle,
    this.width,
    this.animate = Animate.knock,
    this.paddingHand = 30.0,
    this.circleColor = Colors.cyan,
    this.handColor = Colors.black,
    this.backgroundColor = Colors.cyan,
    this.indicatorColor = Colors.black,
    this.shadowHand = 4.0,
    this.counterAlign = CounterAlign.bottom,
    this.isCircle = true,
    this.hand = Hand.long,
    this.handSize = 30,
    this.start = 0,
    this.end = 100,
    @required this.index,
    this.fontFamily = "",
    this.widthCircle = 20,
    this.ticks,
  });

  @override
  _FlutterGaugeState createState() => _FlutterGaugeState();
}

class _FlutterGaugeState extends State<FlutterGauge> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 400), () {
      eventObservable.add(widget.index);
    });
  }

  PublishSubject<double> eventObservable = new PublishSubject();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          FlutterGaugeMain(
            ticks: widget.ticks,
            isDecimal: widget.isDecimal,
            counterStyle: widget.counterStyle,
            paddingHand: widget.paddingHand,
            circleColor: widget.circleColor,
            handColor: widget.handColor,
            backgroundColor: widget.backgroundColor,
            indicatorColor: widget.indicatorColor,
            shadowHand: widget.shadowHand,
            counterAlign: widget.counterAlign,
            isCircle: widget.isCircle,
            hand: widget.hand,
            handSize: widget.handSize,
            start: widget.start,
            end: widget.end,
            highlightStart: (widget.end / widget.end.toInt()),
            highlightEnd: (0 / widget.end.toInt()),
            eventObservable: eventObservable,
            fontFamily: widget.fontFamily,
            widthCircle: widget.widthCircle > 30 ? 30 : widget.widthCircle,
          ),
        ],
      );
}
