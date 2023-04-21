import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/animation/rive_radar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../controller/rover_controller.dart';

class AtmosMobileView extends StatelessWidget {
  AtmosMobileView({Key? key}) : super(key: key);
  final RoverIcomingDataControllerTest data =
      Get.put(RoverIcomingDataControllerTest());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RoverIcomingDataControllerTest>(
          builder: (RoverIcomingDataControllerTest dataController) {
        if (dataController.isConnected.value = true) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 0.2 * MediaQuery.of(context).size.height,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 24,
                          color: Colors.orange.withOpacity(0.4),
                          offset: const Offset(0, 0),
                        )
                      ]),
                ),
                const Text('AQI Index'),
                SizedBox(
                  height: 0.2 * MediaQuery.of(context).size.height,
                ),
                const Text('Pollutants'),
                SizedBox(
                  height: 0.1 * MediaQuery.of(context).size.height,
                ),
                Row(
                  children: const [],
                )
                // ElevatedButton(onPressed: (){
                //   dataController.
                // }, child: Text('send data')),
              ],
            ),
          );
        }
        return const LoadAnimation();
      }),
    );
  }

  Widget circularProgress({required int value, required BuildContext context}) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          startAngle: 270,
          endAngle: 270,
          showTicks: false,
          showLabels: false,
          radiusFactor: 0.7,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: -270,
                positionFactor: 0.2,
                widget: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: value.toString(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -4),
                        child: const Text(
                          'o',
                          //superscript is usually smaller in size
                          textScaleFactor: 0.7,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  ]),
                ))
          ],
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 100,
              startWidth: 6,
              endWidth: 6,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
          pointers: [
            RangePointer(
              value: value.toDouble(),
              enableAnimation: true,
              width: 6,
              color: Colors.white,
              gradient: const SweepGradient(colors: [Colors.orange]),
            ),
          ],
        ),
      ],
    );
  }
}
