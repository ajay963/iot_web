import 'package:flutter/material.dart';
import 'package:iot/widgets/radial_gauges.dart';

import '../utilities/colors.dart';

const int boxSize = 5;

class GPSdataW extends StatelessWidget {
  const GPSdataW({
    Key? key,
    required this.satelliteNo,
    required this.seaLevel,
    required this.connected,
    required this.collisionDistance,
  }) : super(key: key);

  final int satelliteNo;
  final int seaLevel;

  final bool connected;
  final int collisionDistance;

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: boxSize.toDouble()),
            Text(
                'satellite: ' +
                    satelliteNo.toString() +
                    '   ' +
                    'sea level : ' +
                    seaLevel.toString() +
                    ' meter',
                style: txtTheme.bodyLarge),
            SizedBox(height: boxSize.toDouble()),
            RichText(
                text: TextSpan(style: txtTheme.bodyMedium, children: [
              const TextSpan(text: 'websocket '),
              if (connected)
                TextSpan(text: 'connected ', style: txtTheme.bodySmall)
              else
                TextSpan(text: 'disconnected ', style: txtTheme.bodySmall),
              const TextSpan(text: '  '),
            ]))
          ]),
    );
  }
}

class GyroAxisDataW extends StatelessWidget {
  final int xAxis;
  final int yAxis;
  final int zAxis;

  const GyroAxisDataW(
      {Key? key, required this.xAxis, required this.yAxis, required this.zAxis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: xAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: yAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('y-axis')
                  ],
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 80,
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: RotationGuage(
                          color1: themeColor1,
                          color2: themeColor2,
                          value: zAxis),
                    ),
                    const SizedBox(width: 5),
                    const Text('x-axis')
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}

class AtmosDataW extends StatelessWidget {
  final String temp;
  final String humidity;
  const AtmosDataW({Key? key, required this.temp, required this.humidity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        RichText(
          text: TextSpan(children: [
            TextSpan(text: temp, style: txtTheme.displayMedium),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(4, -20),
                child: Text(
                  'o',
                  //superscript is usually smaller in size
                  textScaleFactor: 0.7,
                  style: txtTheme.bodyMedium,
                ),
              ),
            ),
            TextSpan(text: '  temp', style: txtTheme.bodySmall),
          ]),
        ),
        const SizedBox(width: 30),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: humidity + '%', style: txtTheme.displayMedium),
            TextSpan(text: '  humidity', style: txtTheme.bodySmall),
          ]),
        ),
      ],
    );
  }
}
