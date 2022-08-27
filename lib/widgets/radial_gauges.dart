import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RotationGuage extends StatelessWidget {
  final Color color1;
  final Color color2;
  final int value;
  final String label;
  const RotationGuage(
      {Key? key,
      required this.color1,
      required this.color2,
      required this.value,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 100,
            startAngle: 270,
            endAngle: 270,
            showTicks: false,
            showLabels: false,
            radiusFactor: 0.68,
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: -270,
                positionFactor: 0.2,
                widget: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              )
            ],
            ranges: [
              GaugeRange(
                startValue: 0,
                endValue: 100,
                color: Colors.white.withOpacity(0.2),
              ),
            ],
            pointers: [
              RangePointer(
                value: value.toDouble(),
                cornerStyle: CornerStyle.bothCurve,
                enableAnimation: true,
                width: 10,
                color: Colors.white,
                gradient: SweepGradient(colors: [color1, color2]),
              ),
              MarkerPointer(
                value: value.toDouble(),
                enableAnimation: true,
                markerHeight: 8,
                markerWidth: 8,
                color: Colors.white.withOpacity(0.6),
                markerType: MarkerType.circle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashRadialSpeedGauge extends StatelessWidget {
  final int value;
  final Color color1;
  final Color color2;
  const DashRadialSpeedGauge(
      {Key? key,
      required this.value,
      required this.color1,
      required this.color2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          startAngle: -270,
          endAngle: 160,
          minimum: 0,
          maximum: 50,
          showFirstLabel: false,
          showLabels: false,
          showTicks: false,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                angle: -270,
                positionFactor: 0,
                widget: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: value.toString(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    TextSpan(
                      text: '\nkmph',
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ]),
                ))
          ],
          axisLineStyle: const AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.2,
              color: kMdGrey,
              dashArray: <double>[10, 15]),
        ),
        RadialAxis(
            startAngle: -270,
            endAngle: -90,
            minimum: 0,
            maximum: 50,
            showFirstLabel: false,
            showLabels: false,
            showTicks: false,
            axisLineStyle: AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor,
              thickness: 0.2,
              dashArray: const <double>[10, 15],
              color: Colors.white,
              gradient: SweepGradient(
                colors: <Color>[color1, color2],
              ),
            )),
      ],
    );
  }
}
