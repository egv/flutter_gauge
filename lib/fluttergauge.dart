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
  final double highlightStart;
  final double highlightEnd;
  final String fontFamily;
  final double widthCircle;
  final PublishSubject<double> eventObservable;
  final Hand hand;
  final Map isMark;
  final double handSize;
  final double shadowHand;
  final Color circleColor;
  final Color handColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final double paddingHand;
  final List<Tick> ticks;

  FlutterGaugeMain({
    this.paddingHand = 30.0,
    this.circleColor = Colors.cyan,
    this.handColor = Colors.black,
    this.backgroundColor = Colors.cyan,
    this.indicatorColor = Colors.black,
    this.shadowHand = 4.0,
    this.hand = Hand.long,
    this.isMark,
    this.handSize = 30,
    this.ticks,
    this.highlightStart,
    this.highlightEnd,
    this.eventObservable,
    @required this.fontFamily,
    @required this.widthCircle,
  });

  @override
  _FlutterGaugeMainState createState() => new _FlutterGaugeMainState(
        this.eventObservable,
      );
}

class _FlutterGaugeMainState extends State<FlutterGaugeMain>
    with TickerProviderStateMixin {
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

  _FlutterGaugeMainState(
    PublishSubject<double> eventObservable,
  ) {
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
      (value >= 1) ? reloadData(1.0) : reloadData(value);
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
          final maxTickWidth = _maxOuterWidth(widget.ticks);
          final ringWidth = size.width - widget.widthCircle - maxTickWidth;
          return Container(
            height: size.height,
            width: size.width,
            // color: Colors.amber,
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // color: Colors.green,
                    width: ringWidth,
                    height: ringWidth / 2,
                    child: Stack(fit: StackFit.passthrough, children: [
                      ..._buildCircle(context, constraints),
                      ..._buildHand(context, constraints),
                    ]),
                  ),
                ),
                CustomPaint(
                  painter: GaugeTextPainter(
                    radius: ringWidth / 2 - widget.widthCircle / 2,
                    widthCircle: widget.widthCircle,
                    ticks: widget.ticks,
                  ),
                ),
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

  List<Widget> _buildHand(BuildContext context, BoxConstraints constraints) => [
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
                color: this.widget.handColor,
                handSize: widget.handSize),
          ),
        )),
      ];
}

double _maxOuterWidth(List<Tick> ticks) {
  if (ticks == null || ticks.isEmpty) {
    return 0;
  }

  final outerTicks = ticks
      .where((e) => e.numberInAndOut == NumberInAndOut.outside)
      .map((e) => e.calcWidth);
  if (outerTicks.isEmpty) {
    return 0.0;
  }

  return outerTicks.reduce((a, b) => max(a, b));
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
