import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/controller/temp_rgb_controller.dart';
import 'package:iot/models/info.dart';
import 'package:iot/widgets/chars.dart';
import 'package:iot/widgets/graph_charts.dart';
import 'package:iot/widgets/sliders.dart';
import '../layouts/desktop_monitor.dart';

class TempCumRGBApp extends StatelessWidget {
  TempCumRGBApp({Key? key}) : super(key: key);

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
                AtmosDataW(
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
