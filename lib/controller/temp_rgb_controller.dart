import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/models/info.dart';
import 'package:iot/models/temp.dart';
import 'package:web_socket_channel/io.dart';

class IncomingDataController extends GetxController {
  RxInt idx = 0.obs;
  late IOWebSocketChannel channel;
  Rx<RGBled> rgbLed = RGBled(red: 0, blue: 0, green: 0).obs;
  Rx<AtmosDataModel> atmosData = AtmosDataModel(temp: 0, humidity: 0).obs;
  Rx<bool> isConnected = false.obs;
  RxList<GraphData> tempList = [GraphData(time: 0, value: 0)].obs;
  RxList<GraphData> humidityList = [GraphData(time: 0, value: 0)].obs;
  @override
  void onInit() {
    isConnected.value = false;
    Timer.periodic(const Duration(seconds: 1), updateGraph);
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
          atmosData.value = AtmosDataModel.fromJson(message);
          if (atmosData.value.temp > 87) atmosData.value.temp = 86;
          if (atmosData.value.temp < 0) atmosData.value.temp = 0;
          if (atmosData.value.humidity > 206) atmosData.value.humidity = 208;
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
    if (isConnected.value == true) {
      log(cmd);
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
      log(cmd);
      log("Websocket is not connected.");
    }
  }

  void updateGraph(Timer time) {
    idx = idx + 1;
    tempList.add(GraphData(
        time: idx.toDouble(), value: atmosData.value.temp.toDouble()));
    humidityList.add(GraphData(
        time: idx.toDouble(), value: atmosData.value.humidity.toDouble()));
    if (humidityList.length > 11) humidityList.removeAt(0);
    if (tempList.length > 11) tempList.removeAt(0);
    if (isConnected.value == false && idx % 10 == 0) channelconnect();
    update();
  }

  void setRed({required int data}) {
    rgbLed.value.red = data;
    update();
  }

  void setBlue({required int data}) {
    rgbLed.value.blue = data;
    update();
  }

  void setGreen({required int data}) {
    rgbLed.value.green = data;
    update();
  }
}
