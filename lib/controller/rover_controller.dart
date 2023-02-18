import 'dart:async';
import 'dart:developer';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iot/controller/sensors_controller.dart';
import 'package:iot/models/temp.dart';
import 'package:web_socket_channel/io.dart';

class RoverIcomingDataControllerTest extends GetxController {
  int timeCtr = 0;
  RxInt idx = 0.obs;
  late IOWebSocketChannel channel;
  Rx<bool> isConnected = false.obs;
  RxList<GraphData> tempList = [GraphData(time: 0, value: 0)].obs;
  RxList<GraphData> humidityList = [GraphData(time: 0, value: 0)].obs;
  Rx<Test1> sensorsData = Test1(
          atmosData: BME280(temp: 0, humidity: 0, pressure: 0, altitude: 0),
          obstacle: 0,
          aqi: 0)
      .obs;
  MaxMin tempMaxMin = MaxMin(maxValue: 0, minValue: 100);
  MaxMin humidityMaxMin = MaxMin(maxValue: 0, minValue: 100);
  @override
  void onInit() {
    isConnected.value = false;
    Timer.periodic(const Duration(seconds: 1), _updateGraphAndValues);
    Timer.periodic(const Duration(milliseconds: 10), (Timer time) {
      log('counter: $timeCtr');
      timeCtr++;
      if (timeCtr > 15000) timeCtr = 0;
    });
    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.onInit();
  }

  channelconnect() {
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.4.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          debugPrint(message);
          isConnected.value = true;
          sensorsData.value = Test1.fromJson(message);
        },
        onDone: () {
          //if WebSocket is disconnected
          debugPrint("Websocket is closed");
          isConnected.value = false;
        },
        onError: (error) {
          // debugPrint("error" + error.toString());
        },
      );
    } catch (_) {
      debugPrint("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (isConnected.value == true && timeCtr > 15) {
      log(cmd);
      channel.sink.add(cmd);
      timeCtr = 0;
    } else if (timeCtr <= 15) {
      log("holded for time.");
    } else {
      channelconnect();
      log(cmd);
      log("Websocket is not connected.");
    }
  }

  Future<void> directSendcmd(String cmd) async {
    if (isConnected.value == true) {
      log(cmd);
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
      log(cmd);
      log("Websocket is not connected.");
    }
  }

  void _updateGraphAndValues(Timer time) {
    idx = idx + 1;
    tempList.add(GraphData(
        time: idx.toDouble(),
        value: sensorsData.value.atmosData.temp.toDouble()));
    humidityList.add(GraphData(
        time: idx.toDouble(),
        value: sensorsData.value.atmosData.humidity.toDouble()));
    if (humidityList.length > 10) humidityList.removeAt(0);
    if (tempList.length > 10) tempList.removeAt(0);
    if (isConnected.value == false && idx % 10 == 0) channelconnect();
    if (idx > 10) {
      tempMaxMin.setMaxMin(value: sensorsData.value.atmosData.temp);
      humidityMaxMin.setMaxMin(value: sensorsData.value.atmosData.humidity);
    }
    update();
  }
}
