import 'package:flutter/material.dart';
import 'package:iot/utilities/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RotationGuage extends StatelessWidget {
  final Color color1;
  final Color color2;
  final int value;

  const RotationGuage({
    Key? key,
    required this.color1,
    required this.color2,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 120,
            startAngle: 140,
            endAngle: 400,
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
                        text: value.toString() + '\n',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: color1),
                      ),
                      TextSpan(
                        text: 'cm/s',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 20,
                            color: CustomColors.greyShade3,
                            letterSpacing: 1.5),
                      ),
                    ]),
                  ))
            ],
            pointers: [
              RangePointer(
                value: value.toDouble(),
                enableAnimation: true,
                width: 10,
                gradient:
                    SweepGradient(colors: [if (value > 20) color1, color2]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
