import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
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
                gradient:
                    SweepGradient(colors: [color1.withOpacity(0), color2]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
