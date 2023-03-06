import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/models/info.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controller/rover_controller.dart';

class SingleHandControl extends StatefulWidget {
  const SingleHandControl({Key? key}) : super(key: key);

  @override
  State<SingleHandControl> createState() => _SingleHandControlState();
}

class _SingleHandControlState extends State<SingleHandControl> {
  final RoverIcomingDataControllerTest data =
      Get.put(RoverIcomingDataControllerTest());
  double leftWheelVal = 0;
  double rightWheelVal = 0;
  setWheelValue({double? leftVal, double? rightVal}) {
    if (leftVal != null) {
      leftWheelVal = leftVal.roundToDouble();
    }
    if (rightVal != null) {
      rightWheelVal = rightVal.roundToDouble();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.cyan.shade300,
            child: const Icon(Icons.send),
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
              child: GetBuilder<RoverIcomingDataControllerTest>(
                  builder: (RoverIcomingDataControllerTest dataController) {
                if (dataController.isConnected.value == true) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        dataController.sensorsData.value.atmosData.temp
                            .toString(),
                        style: txtTheme.bodyMedium,
                      ),
                      WheelGauge(
                        value: leftWheelVal,
                        trackColor: Colors.grey.shade300,
                        pathColor1: Colors.blue,
                        pathColor2: Colors.cyan,
                        minimum: 0,
                        maximum: 10,
                        onValueChanged: (value) {
                          setWheelValue(leftVal: value);
                          String cmd = RadialControl(
                                  leftPower: leftWheelVal.toInt(),
                                  rightPower: rightWheelVal.toInt(),
                                  isLeftPostive: true,
                                  isRightPositive: true,
                                  ledBrightness: 0)
                              .toJson();
                          dataController.directSendcmd(cmd);
                        },
                        onValueChanging: (value) {
                          setWheelValue(leftVal: value.value);
                          String cmd = RadialControl(
                                  leftPower: leftWheelVal.toInt(),
                                  rightPower: rightWheelVal.toInt(),
                                  isLeftPostive: true,
                                  isRightPositive: true,
                                  ledBrightness: 0)
                              .toJson();
                          dataController.sendcmd(cmd);
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  );
                }

                // return loading animation
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      // const LoadAnimation(),
                      const CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Reconnectng...',
                        style: txtTheme.bodyLarge!.copyWith(fontSize: 20),
                      )
                    ],
                  ),
                );
              }))),
    );
  }
}

class WheelControllerMobile extends StatefulWidget {
  const WheelControllerMobile({Key? key}) : super(key: key);

  @override
  State<WheelControllerMobile> createState() => _WheelControllerMobileState();
}

class _WheelControllerMobileState extends State<WheelControllerMobile> {
  double leftWheelVal = 0;
  double rightWheelVal = 0;
  setWheelValue({double? leftVal, double? rightVal}) {
    if (leftVal != null) {
      leftWheelVal = leftVal.roundToDouble();
    }
    if (rightVal != null) {
      rightWheelVal = rightVal.roundToDouble();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Scaffold(
      body: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WheelGauge(
                    value: leftWheelVal,
                    trackColor: Colors.grey.shade300,
                    pathColor1: Colors.blue,
                    pathColor2: Colors.cyan,
                    minimum: 0,
                    maximum: 10,
                    onValueChanged: (value) => setWheelValue(leftVal: value),
                    onValueChanging: (value) =>
                        setWheelValue(leftVal: value.value),
                  ),
                  WheelGauge(
                    value: rightWheelVal,
                    trackColor: Colors.grey.shade300,
                    pathColor1: Colors.blue,
                    pathColor2: Colors.cyan,
                    minimum: 0,
                    maximum: 10,
                    onValueChanged: (value) => setWheelValue(rightVal: value),
                    onValueChanging: (value) =>
                        setWheelValue(rightVal: value.value),
                  ),
                ],
              ))),
    );
  }
}

class WheelGauge extends StatelessWidget {
  final double value;
  final Function(double)? onValueChanged;
  final Function(ValueChangingArgs)? onValueChanging;
  final Color trackColor;
  final Color pathColor1;
  final Color pathColor2;
  final double minimum;
  final double maximum;
  const WheelGauge({
    Key? key,
    required this.value,
    this.onValueChanged,
    this.onValueChanging,
    this.trackColor = Colors.white,
    this.pathColor1 = Colors.orange,
    this.pathColor2 = Colors.deepOrange,
    this.minimum = 0,
    this.maximum = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: minimum,
          maximum: maximum,
          // interval: 1,
          startAngle: 270,
          endAngle: 270,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(color: trackColor, thickness: 30),
          pointers: <GaugePointer>[
            RangePointer(
                value: value,
                cornerStyle: CornerStyle.bothCurve,
                width: 30,
                sizeUnit: GaugeSizeUnit.logicalPixel,
                gradient: SweepGradient(
                  colors: <Color>[pathColor1, pathColor2],
                )),
            MarkerPointer(
              value: value - (maximum - minimum) * 0.02,
              enableDragging: true,
              borderWidth: 5,
              color: Colors.white.withOpacity(0.8),
              // markerOffset: 10,
              markerHeight: 20,
              markerWidth: 20,
              markerType: MarkerType.circle,
              onValueChanged: onValueChanged,
              onValueChanging: onValueChanging,
            ),
          ],

          annotations: [
            GaugeAnnotation(
                positionFactor: 0.08,
                widget: Center(
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey, fontSize: 52),
                  ),
                ))
          ],
        ),
      ],
    );
  }
}
