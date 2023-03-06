import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../provider/crawler_data.dart';
import '../utilities/themes.dart';

class CrJoyStickPad extends StatelessWidget {
  const CrJoyStickPad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(alignment: Alignment.center, children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.4),
          ),
        ),
        const _RotationGuage(),
        SizedBox(
            height: 240,
            width: 240,
            child: _JoyStickController(onChange: () {})),
      ]),
    );
  }
}

class _RotationGuage extends StatelessWidget {
  const _RotationGuage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _crawlerData = Provider.of<CrawlerData>(context);
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          startAngle: 270,
          endAngle: 270,
          showTicks: false,
          showLabels: false,
          radiusFactor: 1.1,
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 100,
              color: Colors.white.withOpacity(0.2),
            ),
          ],
          pointers: [
            RangePointer(
              value: _crawlerData.getXPosition.toDouble().abs(),
              cornerStyle: CornerStyle.bothCurve,
              enableAnimation: true,
              animationDuration: 200,
              width: 10,
              color: Colors.white,
              gradient: const SweepGradient(colors: [kThemeShadeMagenta]),
            ),
            MarkerPointer(
              value: _crawlerData.getXPosition.toDouble().abs(),
              enableAnimation: true,
              markerHeight: 8,
              markerWidth: 8,
              color: Colors.white.withOpacity(0.6),
              markerType: MarkerType.circle,
            ),
          ],
        ),
      ],
    );
  }
}

class _JoyStickController extends StatefulWidget {
  final Function onChange;

  const _JoyStickController({Key? key, required this.onChange})
      : super(key: key);

  @override
  State<_JoyStickController> createState() => __JoyStickControllerState();
}

class __JoyStickControllerState extends State<_JoyStickController> {
  double _x = 0;
  double _y = 0;

  final JoystickMode _joystickMode = JoystickMode.all;
  void changePosistion(double xStep, double yStep) {
    _x = xStep * 10;
    _y = yStep * -10;
  }

  void resetPosistion() {
    setState(() {
      _x = 0;
      _y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final TextTheme txtTheme = Theme.of(context).textTheme
    final _crawlerData = Provider.of<CrawlerData>(context);

    return Joystick(
      mode: _joystickMode,
      period: const Duration(microseconds: 200),
      stick: Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      base: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent, width: 10),
        ),
      ),
      stickOffsetCalculator: const CircleStickOffsetCalculator(),
      listener: (details) {
        changePosistion(details.x, details.y);
        _crawlerData.setXPosition(x: _x.toInt());
        _crawlerData.setYPosition(y: _y.toInt());
        widget.onChange();
        setState(() {});
      },
      onStickDragEnd: () {
        resetPosistion();
        _crawlerData.setXPosition(x: 0);
        _crawlerData.setYPosition(y: 0);
      },
    );
  }
}
