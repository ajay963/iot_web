import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
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
  late bool ledstatus;
  late IOWebSocketChannel channel;
  late bool connected;
  late String temp;
  late String humidity;
  late String heatindex;
  int idx = 0;
  late List<TempChartData> tempList = [
    TempChartData(time: 0, temp: 0),
  ];
  @override
  void initState() {
    ledstatus = false;
    connected = false;
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
          .add(TempChartData(time: idx.toDouble(), temp: double.parse(temp)));
      idx = idx + 10;
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
              connected = true;
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
            connected = false;
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
    if (connected == true) {
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
    final _tempSensorData = Provider.of<TempData>(context);

    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temperature $temp°C | Humidity: $humidity",
                    ),
                    const SizedBox(height: 10),
                    Text("Heat Index: $heatindex°C"),
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
                    RoundedButton(
                      onTap: () {
                        if (ledstatus) {
                          sendcmd("poweroff");
                          ledstatus = false;
                        } else {
                          sendcmd("poweron");
                          ledstatus = true;
                        }
                        setState(() {});
                      },
                      buttonLabel: ledstatus ? "TURN LED OFF" : "TURN LED ON",
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
