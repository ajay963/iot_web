import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/models/info.dart';
import 'package:iot/models/temp.dart';
import 'package:iot/provider/sensors_data.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:iot/widgets/graph_charts.dart';
import 'package:iot/widgets/sliders.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'layouts/desktop_monitor.dart';

class WebSocketDesktop extends StatefulWidget {
  const WebSocketDesktop({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebSocketDesktop();
  }
}

class _WebSocketDesktop extends State<WebSocketDesktop> {
  bool ledstatus = false;
  late IOWebSocketChannel channel;
  bool connected = false;
  int temp = 0;
  int humidity = 0;

  // rgb value
  int red = 0;
  int blue = 0;
  int green = 0;
  int idx = 0;
  late List<TempChartData> tempList = [
    TempChartData(time: 0, temp: 0),
  ];
  late List<TempChartData> humidityList = [
    TempChartData(time: 0, temp: 0),
  ];
  @override
  void initState() {
    ledstatus = false;
    connected = false;
    temp = 0;
    humidity = 0;

    Timer.periodic(const Duration(seconds: 1), updateGraph);
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.initState();
  }

  void updateGraph(Timer time) {
    setState(() {
      tempList.add(TempChartData(time: idx.toDouble(), temp: temp.toDouble()));
      idx = idx + 1;

      humidityList
          .add(TempChartData(time: idx.toDouble(), temp: humidity.toDouble()));
      idx = idx + 1;
      if (humidityList.length > 11) humidityList.removeAt(0);
      if (tempList.length > 11) tempList.removeAt(0);
    });
  }

  channelconnect() {
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.4.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          debugPrint(message);
          setState(() {
            connected = true;
            Map<String, dynamic> jsondata = json.decode(message);
            setState(() {
              temp = jsondata["temp"];
              humidity = jsondata["humidity"];

              if (temp > 87) temp = 86;
              if (temp < 0) temp = 0;
              if (humidity > 206) humidity = 208;
            });
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          debugPrint("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          debugPrint("error" + error.toString());
        },
      );
    } catch (_) {
      debugPrint("error on connecting to websocket.");
    }
  }

  String rgbJson({required int red, required int blue, required int green}) {
    setState(() {});
    return RGBled(red: red, blue: blue, green: green).toJson();
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      log(cmd);
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
      log(cmd);
      debugPrint("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Text(
                          'Weather \nMania',
                          style: txtTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        Container(
                            child: connected
                                ? const Text("Websocket: Connected")
                                : const Text("Websocket: Disconnected")),
                        const SizedBox(height: 30),
                        AtmosData(
                            temp: temp.toString(),
                            humidity: humidity.toString()),
                        const SizedBox(height: 10),
                        Text("timer : " + idx.toString()),
                        const SizedBox(height: 10),
                        Text(
                          "Temperature",
                          style: txtTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 140,
                          // width: 400,
                          child: Charts(
                            list: tempList,
                            xAisLabel: 'Time',
                            yAxisLabel: 'Temp',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Humidity",
                          style: txtTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 140,
                          // width: 400,
                          child: Charts(
                            list: humidityList,
                            xAisLabel: 'Time',
                            yAxisLabel: 'Humidity',
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "RGB slider",
                          style: txtTheme.bodyMedium,
                        ),
                        const SizedBox(height: 30),
                        SliderWidget(
                            value: red,
                            min: 0,
                            max: 255,
                            fullWidth: true,
                            colorsList: const [
                              Colors.orange,
                              Colors.red,
                            ],
                            onChanged: (value) {
                              red = value.toInt();
                              setState(() {});
                            },
                            onChangeEnd: (rValue) {
                              red = rValue.toInt();
                              sendcmd(
                                  rgbJson(red: red, blue: blue, green: green));
                            }),
                        const SizedBox(height: 20),
                        SliderWidget(
                          value: blue,
                          min: 0,
                          max: 255,
                          fullWidth: true,
                          colorsList: const [Colors.cyan, Colors.blue],
                          onChanged: (value) {
                            blue = value.toInt();
                            setState(() {});
                          },
                          onChangeEnd: (bValue) {
                            blue = bValue.toInt();
                            sendcmd(
                                rgbJson(red: red, blue: blue, green: green));
                          },
                        ),
                        const SizedBox(height: 20),
                        SliderWidget(
                            value: green,
                            min: 0,
                            max: 255,
                            fullWidth: true,
                            colorsList: const [Colors.teal, Colors.green],
                            onChanged: (value) {
                              green = value.toInt();
                              setState(() {});
                            },
                            onChangeEnd: (gValue) {
                              green = gValue.toInt();
                              sendcmd(
                                  rgbJson(red: red, blue: blue, green: green));
                            }),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
