import 'dart:async';
import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gauge/handpainter.dart';
import 'package:flutter_gauge/linepainter.dart';
import 'package:rxdart/rxdart.dart';

import 'flutter_gauge.dart';
import 'gaugetextpainter.dart';

class FlutterGaugeMain extends StatefulWidget {
  final int start;
  final int end;
  final double highlightStart;
  final double highlightEnd;
  final String fontFamily;
  final double widthCircle;
  final PublishSubject<double> eventObservable;
  final CounterAlign counterAlign;
  final Hand hand;
  final bool isCircle;
  final Map isMark;
  final double handSize;
  final double shadowHand;
  final Color circleColor;
  final Color handColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final double paddingHand;
  final TextStyle counterStyle;
  final bool isDecimal;
  final List<Tick> ticks;

  EdgeInsets padding;

  FlutterGaugeMain({
    this.isDecimal,
    this.counterStyle,
    this.paddingHand = 30.0,
    this.circleColor = Colors.cyan,
    this.handColor = Colors.black,
    this.backgroundColor = Colors.cyan,
    this.indicatorColor = Colors.black,
    this.shadowHand = 4.0,
    this.counterAlign = CounterAlign.bottom,
    this.isCircle = true,
    this.hand = Hand.long,
    this.isMark,
    this.handSize = 30,
    this.start,
    this.end,
    this.ticks,
    this.highlightStart,
    this.highlightEnd,
    this.eventObservable,
    @required this.fontFamily,
    @required this.widthCircle,
  }) {
    padding = EdgeInsets.all(widthCircle);
  }

  @override
  _FlutterGaugeMainState createState() => new _FlutterGaugeMainState(this.start,
      this.end, this.highlightStart, this.highlightEnd, this.eventObservable);
}

class _FlutterGaugeMainState extends State<FlutterGaugeMain>
    with TickerProviderStateMixin {
  int start;
  int end;
  double highlightStart;
  double highlightEnd;
  PublishSubject<double> eventObservable;
  double val = 0.0;
  double newVal;
  AnimationController percentageAnimationController;
  StreamSubscription<double> subscription;

  @override
  void dispose() {
    percentageAnimationController.dispose();
    super.dispose();
  }

  _FlutterGaugeMainState(int start, int end, double highlightStart,
      double highlightEnd, PublishSubject<double> eventObservable) {
    this.start = start;
    this.end = end;
    this.highlightStart = highlightStart;
    this.highlightEnd = highlightEnd;
    this.eventObservable = eventObservable;

    percentageAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    )..addListener(() {
        setState(() {
          val = lerpDouble(val, newVal, percentageAnimationController.value);
        });
      });
    subscription = this.eventObservable.listen((value) {
      (value >= this.end) ? reloadData(this.end.toDouble()) : reloadData(value);
    }); //(value) => reloadData(value));
  }

  reloadData(double value) {
    print(value);
    newVal = value;
    percentageAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) => Center(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          final size = _getSize(constraints);

          final ringWidth = size.width - widget.widthCircle;
          return Container(
            height: size.height,
            width: size.width,
            color: Colors.amber,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.green,
                    width: ringWidth,
                    height: ringWidth / 2,
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: _buildCircle(context, constraints),
                    ),
                  ),
                ),
                ..._buildGaugeText(context, constraints),
                ..._buildHand(context, constraints),
                ..._buildCounter(context, constraints),
              ],
            ),
          );
        }),
      );

  List<Widget> _buildCircle(
    BuildContext context,
    BoxConstraints constraints,
  ) =>
      [
        CustomPaint(
            foregroundPainter: new LinePainter(
          lineColor: this.widget.backgroundColor,
          width: widget.widthCircle,
        )),
      ];

  List<Widget> _buildCounter(
    BuildContext context,
    BoxConstraints constraints,
  ) =>
      [
        if (widget.counterAlign != CounterAlign.none)
          CustomPaint(
              painter: GaugeTextCounter(
                  isDecimal: widget.isDecimal,
                  start: this.start,
                  width: min(constraints.maxHeight, constraints.maxWidth),
                  counterAlign: widget.counterAlign,
                  end: this.end,
                  value: this.val,
                  fontFamily: widget.fontFamily,
                  textStyle: widget.counterStyle == null
                      ? TextStyle(
                          color: Colors.black,
                          fontSize: 17.0,
                          fontFamily: widget.fontFamily)
                      : widget.counterStyle))
      ];

  List<Widget> _buildGaugeText(
    BuildContext context,
    BoxConstraints constraints,
  ) =>
      [
        Container(
          height: constraints.maxWidth,
          width: constraints.maxWidth,
          padding: EdgeInsets.all(widget.widthCircle),
          child: CustomPaint(
            painter: GaugeTextPainter(
              widthCircle: widget.widthCircle,
              ticks: widget.ticks,
            ),
          ),
        )
      ];

  List<Widget> _buildHand(BuildContext context, BoxConstraints constraints) => [
        if (!(widget.hand == Hand.none || widget.hand == Hand.short))
          Center(
            child: Container(
              width: widget.handSize,
              height: widget.handSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: this.widget.indicatorColor,
              ),
            ),
          ),
        if (widget.hand != Hand.none)
          Center(
              child: Container(
            height: constraints.maxWidth,
            width: constraints.maxWidth,
            padding: EdgeInsets.all(widget.hand == Hand.short
                ? widget.widthCircle / 1.5
                : widget.paddingHand),
            child: new CustomPaint(
              painter: new HandPainter(
                  shadowHand: widget.shadowHand,
                  hand: widget.hand,
                  value: val,
                  start: this.start,
                  end: this.end,
                  color: this.widget.handColor,
                  handSize: widget.handSize),
            ),
          )),
      ];
}

Size _getSize(BoxConstraints constraints) {
  if (constraints.maxHeight.isInfinite) {
    if (constraints.maxWidth.isInfinite) {
      return null;
    }

    return Size(constraints.maxWidth, constraints.maxWidth / 2);
  } else if (constraints.maxWidth.isInfinite) {
    if (constraints.maxHeight.isInfinite) {
      return null;
    }

    return Size(constraints.maxHeight * 2, constraints.maxHeight);
  } else {
    return constraints.maxHeight * 2 < constraints.maxWidth
        ? Size(constraints.maxHeight * 2, constraints.maxHeight)
        : Size(constraints.maxWidth, constraints.maxWidth / 2);
  }
}
