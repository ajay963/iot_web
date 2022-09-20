import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/controller/websocket_controller.dart';
import 'package:iot/models/info.dart';
import 'package:iot/models/temp.dart';
import 'package:iot/widgets/chars.dart';
import 'package:iot/widgets/graph_charts.dart';
import 'package:iot/widgets/sliders.dart';
import 'package:web_socket_channel/io.dart';
import 'layouts/desktop_monitor.dart';

class WebsocketMobile extends StatelessWidget {
  WebsocketMobile({Key? key}) : super(key: key);

  final IncomingDataController data = Get.put(IncomingDataController());

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                ? Colors.transparent
                : Colors.black,
        body: SizedBox(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: GetBuilder<IncomingDataController>(builder: (incomingData) {
              if (incomingData.isConnected.value) {
                return ViewAndControlCenter(txtTheme: txtTheme);
              }
              return NoConenction();
            }),
          ),
        ),
      ),
    );
  }
}

class ViewAndControlCenter extends StatelessWidget {
  ViewAndControlCenter({
    Key? key,
    required this.txtTheme,
  }) : super(key: key);

  final TextTheme txtTheme;
  final incomingData = Get.find<IncomingDataController>();
  String rgbJson({required int red, required int blue, required int green}) {
    return RGBled(red: red, blue: blue, green: green).toJson();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    child: incomingData.isConnected.value
                        ? const Text("Websocket: Connected")
                        : const Text("Websocket: Disconnected")),
                const SizedBox(height: 30),
                AtmosData(
                  temp: incomingData.atmosData.value.temp.toString(),
                  humidity: incomingData.atmosData.value.humidity.toString(),
                ),
                const SizedBox(height: 10),
                Text("timer : " + incomingData.idx.toString()),
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
                    list: incomingData.tempList,
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
                    list: incomingData.humidityList,
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
                    value: incomingData.rgbLed.value.red,
                    min: 0,
                    max: 255,
                    fullWidth: true,
                    colorsList: const [
                      Colors.orange,
                      Colors.red,
                    ],
                    onChanged: (value) {
                      incomingData.setRed(data: value.toInt());
                    },
                    onChangeEnd: (rValue) {
                      incomingData.rgbLed.value.red = rValue.toInt();
                      incomingData.sendcmd(rgbJson(
                          red: incomingData.rgbLed.value.red,
                          blue: incomingData.rgbLed.value.blue,
                          green: incomingData.rgbLed.value.green));
                    }),
                const SizedBox(height: 20),
                SliderWidget(
                  value: incomingData.rgbLed.value.blue,
                  min: 0,
                  max: 255,
                  fullWidth: true,
                  colorsList: const [Colors.cyan, Colors.blue],
                  onChanged: (value) {
                    incomingData.setBlue(data: value.toInt());
                  },
                  onChangeEnd: (bValue) {
                    incomingData.rgbLed.value.blue = bValue.toInt();
                    incomingData.sendcmd(rgbJson(
                        red: incomingData.rgbLed.value.red,
                        blue: incomingData.rgbLed.value.blue,
                        green: incomingData.rgbLed.value.green));
                  },
                ),
                const SizedBox(height: 20),
                SliderWidget(
                    value: incomingData.rgbLed.value.green,
                    min: 0,
                    max: 255,
                    fullWidth: true,
                    colorsList: const [Colors.teal, Colors.green],
                    onChanged: (value) {
                      incomingData.setGreen(data: value.toInt());
                    },
                    onChangeEnd: (gValue) {
                      incomingData.rgbLed.value.green = gValue.toInt();
                      incomingData.sendcmd(rgbJson(
                          red: incomingData.rgbLed.value.red,
                          blue: incomingData.rgbLed.value.blue,
                          green: incomingData.rgbLed.value.green));
                    }),
              ],
            ),
          )
        ]);
  }
}

// Abonded code
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
  List<GraphData> tempList = [GraphData(time: 0, value: 0)];
  List<GraphData> humidityList = [GraphData(time: 0, value: 0)];
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
      tempList.add(GraphData(time: idx.toDouble(), value: temp.toDouble()));
      idx = idx + 1;

      humidityList
          .add(GraphData(time: idx.toDouble(), value: humidity.toDouble()));

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
        backgroundColor:
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                ? Colors.transparent
                : Colors.black,
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
