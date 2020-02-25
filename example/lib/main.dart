import 'package:flutter/material.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:flutter_gauge/gaugetextpainter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 60),
            child: FlutterGauge(
              width: MediaQuery.of(context).size.width,
              index: 1,
              hand: Hand.short,
              ticks: Tick.testTicks(),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  index: 0.5,
                  hand: Hand.short,
                  ticks: Tick.testTicks(
                    tickPosition: TickPosition.inside,
                    textPostion: NumberInAndOut.inside,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  handSize: 30,
                  width: 200,
                  index: 0.5,
                  fontFamily: "Iran",
                  ticks: Tick.allGreyNoNumbers(),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  handSize: 30,
                  width: 200,
                  index: 0.8,
                  fontFamily: "Iran",
                  hand: Hand.short,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    color: Colors.black38,
                    child: FlutterGauge(
                      handSize: 30,
                      width: 200,
                      index: 0.65,
                      fontFamily: "Iran",
                      hand: Hand.none,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  index: 0.5,
                  widthCircle: 10,
                ),
              ),
//              Expanded(child: FlutterGauge(index: 25.0,counterStyle : TextStyle(color: Colors.black,fontSize: 25,),secondsMarker: SecondsMarker.secondsAndMinute,number: Number.all,numberInAndOut: NumberInAndOut.outside,)),
            ],
          ),
          Row(
            children: <Widget>[
//              Expanded(child: FlutterGauge(handSize: 30,width: 200,index: 65.0,fontFamily: "Iran",end: 100,number: Number.endAndCenterAndStart,secondsMarker: SecondsMarker.secondsAndMinute,counterStyle: TextStyle(color: Colors.black,fontSize: 25,)),),
//              Expanded(child: FlutterGauge(secondsMarker: SecondsMarker.none,hand: Hand.short,number: Number.none,width: 200,index: 38.0,fontFamily: "Iran",counterStyle: TextStyle(color: Colors.black,fontSize: 35),counterAlign: CounterAlign.center,isDecimal: false),),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  handSize: 30,
                  width: 200,
                  index: 80.0,
                  fontFamily: "Iran",
                  hand: Hand.short,
                ),
              ),
//              Expanded(child: FlutterGauge(handSize: 30,width: 200,index: 65.0,fontFamily: "Iran",end: 500,number: Number.endAndStart,secondsMarker: SecondsMarker.minutes,isCircle: false,counterStyle: TextStyle(color: Colors.black,fontSize: 25,)),),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                    color: Colors.black38,
                    child: FlutterGauge(
                      handSize: 30,
                      width: 200,
                      index: 0,
                      fontFamily: "Iran",
                      hand: Hand.none,
                    )),
              ),
//              Expanded(child: FlutterGauge(width: 200,index: 67.3,fontFamily: "Iran",counterStyle: TextStyle(color: Colors.black,fontSize: 35,),numberInAndOut: NumberInAndOut.outside,counterAlign: CounterAlign.center,secondsMarker: SecondsMarker.secondsAndMinute,hand: Hand.short),),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  index: 0.5,
                  widthCircle: 10,
                ),
              ),
//              Expanded(child: FlutterGauge(index: 25.0,counterStyle : TextStyle(color: Colors.black,fontSize: 25,),secondsMarker: SecondsMarker.secondsAndMinute,number: Number.all,numberInAndOut: NumberInAndOut.outside,)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: FlutterGauge(
                  index: 0.5,
                  width: 270,
                  widthCircle: 10,
                ),
              ),
            ],
          ),
          FlutterGauge(
            handSize: 30,
            width: 270,
            index: 0.65,
            fontFamily: "Iran",
          ),
          FlutterGauge(
            index: 0.5,
            width: 270,
            widthCircle: 10,
          ),
        ],
      ),
    );
  }
}
