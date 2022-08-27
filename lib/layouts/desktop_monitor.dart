// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iot/colors.dart';
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

  late List<TempChartData> tempList = [
    TempChartData(time: 0, temp: 0),
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
          .add(TempChartData(time: timer.toDouble(), temp: double.parse(temp)));
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
          SizedBox(height: 40),
          SizedBox(
            height: 180,
            child: DashRadialSpeedGauge(
                value: 34, color1: themeColor1, color2: themeColor2),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 500, child: GyroAxisData(xAxis: 15, yAxis: 12, zAxis: 36)),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
            child: SensorsDataDisplay(
                temp: 24.toString(),
                humidity: 28.toString(),
                satelliteNo: 6,
                seaLevel: 1078,
                connected: isConnected,
                collisionDistance: 43),
          ),
        ]);
  }
}

class SensorsDataDisplay extends StatelessWidget {
  const SensorsDataDisplay({
    Key? key,
    required this.temp,
    required this.humidity,
    required this.satelliteNo,
    required this.seaLevel,
    required this.connected,
    required this.collisionDistance,
  }) : super(key: key);

  final String temp;
  final String humidity;
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
            Text(
              temp + '     ' + 'Humidity : ' + humidity,
              style: txtTheme.bodyLarge,
            ),
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
              const TextSpan(text: 'collision '),
              TextSpan(
                  text: collisionDistance.toString(),
                  style: txtTheme.bodySmall),
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
                height: 150,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RotationGuage(
                        label: 'x-axis',
                        color1: themeColor1,
                        color2: themeColor2,
                        value: xAxis),
                    const SizedBox(height: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RotationGuage(
                        label: 'y-axis',
                        color1: themeColor1,
                        color2: themeColor2,
                        value: yAxis),
                    const SizedBox(height: 5),
                    const Text('y-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RotationGuage(
                        label: 'z-axis',
                        color1: themeColor1,
                        color2: themeColor2,
                        value: zAxis),
                    const SizedBox(height: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}