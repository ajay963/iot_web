// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iot/colors.dart';
import 'package:iot/provider/sensors_data.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:iot/widgets/radial_gauges.dart';
import 'package:iot/models/temp.dart';
import 'package:web_socket_channel/io.dart';

const int boxSize = 5;

class SensorMonitorPannel extends StatefulWidget {
  const SensorMonitorPannel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SensorMonitorPannel();
  }
}

class _SensorMonitorPannel extends State<SensorMonitorPannel> {
  late bool ledstatus;
  late IOWebSocketChannel channel;
  late bool isConnected;

  int timer = 0; //

  // Weather Data
  late String temp;
  late String humidity;
  late String heatindex;

  // GPS Data
  late int satelliteNo;
  late int seaLevel;

  // Gyro Data
  late int xAxis;
  late int yAxis;
  late int zAxis;

  // ultra sonic data
  late int collisionDistance;

  late List<GraphData> tempList = [
    GraphData(time: 0, value: 0),
  ];
  @override
  void initState() {
    ledstatus = false;
    isConnected = false;
    temp = "0";
    humidity = "0";
    heatindex = "0";
    Timer.periodic(const Duration(seconds: 1), updateGraph);
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.initState();
  }

  void updateGraph(Timer time) {
    setState(() {
      tempList
          .add(GraphData(time: timer.toDouble(), value: double.parse(temp)));
      timer++;
      if (tempList.length > 11) tempList.removeAt(0);
    });
  }

  channelconnect() {
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.4.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              isConnected = true;
            } else if (message.substring(0, 6) == "{'temp") {
              message = message.replaceAll(RegExp("'"), '"');

              Map<String, dynamic> jsondata = json.decode(message);
              setState(() {
                temp = jsondata["temp"];
                humidity = jsondata["humidity"];
                heatindex = jsondata["heat"];
              });
            } else if (message == "poweron:success") {
              ledstatus = true;
            } else if (message == "poweroff:success") {
              ledstatus = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            isConnected = false;
          });
        },
        onError: (error) {
          print("error" + error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (isConnected == true) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
                width: 700,
                child: GyroAxisData(xAxis: 15, yAxis: 12, zAxis: 36)),
          ),
          const SizedBox(height: 80),
          Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: CrJoyStickPad(),
            ),
          ),
          SizedBox(height: 100),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AtmosData(temp: '45', humidity: '33'),
                SizedBox(
                  width: 50,
                ),
                GPSdata(
                    satelliteNo: 6,
                    seaLevel: 1078,
                    connected: isConnected,
                    collisionDistance: 43),
              ],
            ),
          ),
        ]);
  }
}

class GPSdata extends StatelessWidget {
  const GPSdata({
    Key? key,
    required this.satelliteNo,
    required this.seaLevel,
    required this.connected,
    required this.collisionDistance,
  }) : super(key: key);

  final int satelliteNo;
  final int seaLevel;

  final bool connected;
  final int collisionDistance;

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: boxSize.toDouble()),
            Text(
                'satellite: ' +
                    satelliteNo.toString() +
                    '   ' +
                    'sea level : ' +
                    seaLevel.toString() +
                    ' meter',
                style: txtTheme.bodyLarge),
            SizedBox(height: boxSize.toDouble()),
            RichText(
                text: TextSpan(style: txtTheme.bodyMedium, children: [
              const TextSpan(text: 'websocket '),
              if (connected)
                TextSpan(text: 'connected ', style: txtTheme.bodySmall)
              else
                TextSpan(text: 'disconnected ', style: txtTheme.bodySmall),
              const TextSpan(text: '  '),
            ]))
          ]),
    );
  }
}

class GyroAxisData extends StatelessWidget {
  final int xAxis;
  final int yAxis;
  final int zAxis;

  const GyroAxisData(
      {Key? key, required this.xAxis, required this.yAxis, required this.zAxis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: xAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: yAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('y-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: zAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}

class AtmosData extends StatelessWidget {
  final String temp;
  final String humidity;
  const AtmosData({Key? key, required this.temp, required this.humidity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(text: temp, style: txtTheme.displayMedium),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(4, -20),
                child: Text(
                  'o',
                  //superscript is usually smaller in size
                  textScaleFactor: 0.7,
                  style: txtTheme.bodyMedium,
                ),
              ),
            ),
            TextSpan(text: '  temp', style: txtTheme.bodySmall),
          ]),
        ),
        SizedBox(width: 30),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: humidity, style: txtTheme.displayMedium),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(4, -20),
                child: Text(
                  'o',
                  //superscript is usually smaller in size
                  textScaleFactor: 0.7,
                  style: txtTheme.bodyMedium,
                ),
              ),
            ),
            TextSpan(text: '  humidity', style: txtTheme.bodySmall),
          ]),
        ),
      ],
    );
  }
}
