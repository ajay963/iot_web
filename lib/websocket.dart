import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:iot/models/info.dart';
import 'package:iot/models/temp.dart';
import 'package:iot/provider/sensors_data.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:iot/widgets/graph_charts.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
      debugPrint("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _tempSensorData = Provider.of<TempData>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WindowTitleBarBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.purple,
                    child: MoveWindow(
                      child: const Center(
                        child: Text(
                          'ESP32-Flutter',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Temperature $temp°C | Humidity: $humidity",
                      ),
                      const SizedBox(height: 10),
                      Text("timer : " + idx.toString()),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 200,
                        // width: 400,
                        child: Charts(
                          tempList: tempList,
                          xAisLabel: 'Time',
                          yAxisLabel: 'Temp',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                          child: connected
                              ? const Text("WEBSOCKET: CONNECTED")
                              : const Text("DISCONNECTED")),
                      Container(
                          child: ledstatus
                              ? const Text("LED IS: ON")
                              : const Text("LED IS: OFF")),
                      const SizedBox(height: 30),
                      Slider(
                          value: red.toDouble(),
                          min: 0,
                          max: 255,
                          thumbColor: Colors.red,
                          activeColor: Colors.red.shade400,
                          inactiveColor: Colors.red.shade100,
                          onChanged: (double value) {
                            red = value.toInt();
                            setState(() {});
                          },
                          onChangeEnd: (rValue) {
                            red = rValue.toInt();
                            sendcmd(
                                rgbJson(red: red, blue: blue, green: green));
                          }),
                      const SizedBox(height: 30),
                      Slider(
                        value: blue.toDouble(),
                        min: 0,
                        max: 255,
                        thumbColor: Colors.blue,
                        activeColor: Colors.blue.shade400,
                        inactiveColor: Colors.blue.shade100,
                        onChangeEnd: (bValue) {
                          blue = bValue.toInt();
                          sendcmd(rgbJson(red: red, blue: blue, green: green));
                        },
                        onChanged: (double value) {
                          blue = value.toInt();
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 30),
                      Slider(
                          value: green.toDouble(),
                          min: 0,
                          max: 255,
                          thumbColor: Colors.green,
                          activeColor: Colors.green.shade400,
                          inactiveColor: Colors.green.shade100,
                          onChanged: (double value) {
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
    );
  }
}
