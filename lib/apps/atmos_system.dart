import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/Material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iot/layouts/two_side.dart';
import 'package:iot/rive_radar.dart';
import 'package:iot/widgets/graph_charts.dart';

import '../controller/rover_controller.dart';

class AtmosDesktopView extends StatelessWidget {
  AtmosDesktopView({Key? key}) : super(key: key);
  final RoverIcomingDataControllerTest data =
      Get.put(RoverIcomingDataControllerTest());

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GetBuilder<RoverIcomingDataControllerTest>(
          builder: (RoverIcomingDataControllerTest dataController) {
        if (!dataController.isConnected.value) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                const LoadAnimation(),
                Text(
                  'Reconnectng...',
                  style: txtTheme.bodyLarge!.copyWith(fontSize: 20),
                )
              ],
            ),
          );
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: MoveWindow(),
            ),
            Text(
              'Atmos Info',
              style: txtTheme.labelMedium,
            ),
            const SizedBox(height: 40),
            Text(
              'Temperature',
              style: txtTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TiltleText(
                    data: dataController.sensorsData.value.atmosData.temp
                        .toString(),
                    iconData: FontAwesomeIcons.temperatureHalf,
                    boxWidth: 160),
                const SizedBox(width: 20),
                MaxMinWidget(
                    max: dataController.tempMaxMin.maxValue.toString(),
                    min: dataController.tempMaxMin.minValue.toString())
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: Charts(
                list: dataController.tempList,
                xAisLabel: 'time',
                yAxisLabel: 'temperature',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Humidity',
              style: txtTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                TiltleText(
                    data: dataController.sensorsData.value.atmosData.humidity
                            .toString() +
                        '%',
                    iconData: FontAwesomeIcons.droplet,
                    boxWidth: 160),
                const SizedBox(width: 20),
                MaxMinWidget(
                  max: dataController.humidityMaxMin.maxValue.toString() + '%',
                  min: dataController.humidityMaxMin.minValue.toString() + '%',
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 140,
              child: Charts(
                list: dataController.humidityList,
                xAisLabel: 'time',
                yAxisLabel: 'temperature',
              ),
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Presuure',
                  style: txtTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TiltleText(
                        data: (dataController
                                        .sensorsData.value.atmosData.pressure /
                                    100)
                                .floor()
                                .toString() +
                            'Pa',
                        iconData: FontAwesomeIcons.wind,
                        boxWidth: 200)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Altitude',
                  style: txtTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    TiltleText(
                        data: dataController
                                .sensorsData.value.atmosData.altitude
                                .toString() +
                            'm',
                        iconData: FontAwesomeIcons.arrowUpWideShort,
                        boxWidth: 200)
                  ],
                ),
              ],
            ),
            const SizedBox(height: 80),
            Text(
              'Gases Info',
              style: txtTheme.labelMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextLabel(
                      label: ' Flammable Gases',
                      value: dataController.sensorsData.value.aqi),
                  const SizedBox(height: 10),
                  LinearGradProgressBar(
                      max: 11000,
                      min: 0,
                      value: dataController.sensorsData.value.aqi),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // CustomRoudedButto(
            //     text: 'Print JSON',
            //     onTap: () {
            //       String jsonMssg = Test1(
            //               atmosData: BME280(
            //                   temp: 46,
            //                   humidity: 78,
            //                   pressure: 782,
            //                   altitude: 2908),
            //               obstacle: 31,
            //               aqi: 152)
            //           .toJson();
            //       log(jsonMssg);
            //       // appWindow.close();
            //     })
          ],
        );
      }),
    );
  }
}

class AtmosMobileView extends StatelessWidget {
  AtmosMobileView({Key? key}) : super(key: key);
  final RoverIcomingDataControllerTest data =
      Get.put(RoverIcomingDataControllerTest());

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: GetBuilder<RoverIcomingDataControllerTest>(
          builder: (RoverIcomingDataControllerTest dataController) {
        if (!dataController.isConnected.value) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                const LoadAnimation(),
                Text(
                  'Reconnectng...',
                  style: txtTheme.bodyLarge!.copyWith(fontSize: 20),
                )
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
                child: MoveWindow(),
              ),
              Text(
                'Atmos Info',
                style: txtTheme.labelMedium,
              ),
              const SizedBox(height: 40),
              Text(
                'Temperature',
                style: txtTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              TiltleText(
                  data: dataController.sensorsData.value.atmosData.temp
                      .toString(),
                  iconData: FontAwesomeIcons.temperatureHalf,
                  boxWidth: 160),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: Charts(
                  list: dataController.tempList,
                  xAisLabel: 'time',
                  yAxisLabel: 'temperature',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Humidity',
                style: txtTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              TiltleText(
                  data: dataController.sensorsData.value.atmosData.humidity
                          .toString() +
                      '%',
                  iconData: FontAwesomeIcons.droplet,
                  boxWidth: 160),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: Charts(
                  list: dataController.humidityList,
                  xAisLabel: 'time',
                  yAxisLabel: 'temperature',
                ),
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Presuure',
                    style: txtTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TiltleText(
                          data: (dataController.sensorsData.value.atmosData
                                          .pressure /
                                      100)
                                  .floor()
                                  .toString() +
                              'Pa',
                          iconData: FontAwesomeIcons.wind,
                          boxWidth: 200)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Altitude',
                    style: txtTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      TiltleText(
                          data: dataController
                                  .sensorsData.value.atmosData.altitude
                                  .toString() +
                              'm',
                          iconData: FontAwesomeIcons.arrowUpWideShort,
                          boxWidth: 200)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text(
                'Gases Info',
                style: txtTheme.labelMedium,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextLabel(
                        label: 'Flammable Gases',
                        value: dataController.sensorsData.value.aqi),
                    const SizedBox(height: 10),
                    LinearGradProgressBar(
                        max: 11000,
                        min: 0,
                        value: dataController.sensorsData.value.aqi),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // CustomRoudedButto(
              //     text: 'Print JSON',
              //     onTap: () {
              //       String jsonMssg = Test1(
              //               atmosData: BME280(
              //                   temp: 46,
              //                   humidity: 78,
              //                   pressure: 782,
              //                   altitude: 2908),
              //               obstacle: 31,
              //               aqi: 152)
              //           .toJson();
              //       log(jsonMssg);
              //       // appWindow.close();
              //     })
            ],
          ),
        );
      }),
    );
  }
}
