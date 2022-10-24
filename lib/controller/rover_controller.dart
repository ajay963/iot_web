import 'dart:async';
import 'dart:developer';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:iot/models/sensors.dart';
import 'package:iot/models/temp.dart';
import 'package:web_socket_channel/io.dart';

class RoverIcomingDataController extends GetxController {
  RxInt idx = 0.obs;
  late IOWebSocketChannel channel;
  Rx<bool> isConnected = false.obs;
  RxList<GraphData> tempList = [GraphData(time: 0, value: 0)].obs;
  RxList<GraphData> humidityList = [GraphData(time: 0, value: 0)].obs;
  Rx<SensorsData> sensorsData = SensorsData(
          atmosphericData: BME280(temp: 0, humidity: 0, pressure: 0),
          gpsData: NeoGPS6M(log: 0, lat: 0, seaLevel: 0, satelliteNo: 0),
          gyroData: MPU6050Gyro(xAxis: 0, yAxis: 0, zAxis: 0),
          gasData: GasData(airIndex: 0, co2: 0, ch4: 0))
      .obs;
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
          sensorsData.value = SensorsData.fromJson(message);
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
        time: idx.toDouble(),
        value: sensorsData.value.atmosphericData.humidity.toDouble()));
    humidityList.add(GraphData(
        time: idx.toDouble(),
        value: sensorsData.value.atmosphericData.temp.toDouble()));
    if (humidityList.length > 10) humidityList.removeAt(0);
    if (tempList.length > 10) tempList.removeAt(0);
    if (isConnected.value == false && idx % 10 == 0) channelconnect();
    update();
  }
}
