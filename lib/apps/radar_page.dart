import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/material.dart';
import 'package:iot/animation/rive_radar.dart';
import 'package:iot/models/gradient_model.dart';
import 'package:line_icons/line_icon.dart';

import '../utilities/colors.dart';
import '../widgets/buttos.dart';

class RadarPage extends StatefulWidget {
  const RadarPage({Key? key}) : super(key: key);

  @override
  State<RadarPage> createState() => _RadarPageState();
}

class _RadarPageState extends State<RadarPage> {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  double angle = 0;
  bool isObs = false;
  late DateTime prevTime;
  double radian = 0;

  setAngle(double value) {
    Duration timeDiff = DateTime.now().difference(prevTime);
    prevTime = DateTime.now();
    double radCal = (value * timeDiff.inMilliseconds) / 1000;
    radian = radian + radCal;
    angle = radian * (180 / pi);
    angle = angle % 360;
    isObs = (angle > 70);
    debugPrint('angle $angle');
    setState(() {});
  }

  @override
  void initState() {
    prevTime = DateTime.now();
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            setAngle(event.x);
          });
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomBackButton(onTap: () => Navigator.pop(context)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CurvedContainer(
        height: 250,
        gradientColors: (isObs)
            ? CustomGradients.lavaGradient
            : CustomGradients.naturegreenGradient,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 0.1 * MediaQuery.of(context).size.width,
              vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: angle.round().toString() + '\n',
                    style: textTheme.displayLarge!.copyWith(fontSize: 20)),
                TextSpan(text: 'Obstacle distance', style: textTheme.bodyMedium)
              ])),
              InkWell(
                onTap: () {},
                child: Transform.rotate(
                  angle: angle.round() * (pi / 180),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.4)),
                      child: Center(
                          child: Icon(
                        LineIcon.compass().icon,
                        size: 60,
                        color: Colors.white,
                      ))),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Radar',
                style: textTheme.bodyMedium!
                    .copyWith(fontSize: 36, color: CustomColors.blackShade1),
              ),
            ),
            SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
            Center(
              child: SizedBox(
                  height: 0.8 * MediaQuery.of(context).size.width,
                  width: 0.8 * MediaQuery.of(context).size.width,
                  child: RiveRadar(
                    angle: angle,
                    isObstacle: isObs,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.1 * MediaQuery.of(context).size.width,
                  vertical: 10),
              child: Row(
                children: [
                  Icon(
                    LineIcon.circle(
                      size: 40,
                    ).icon,
                    size: 40,
                    color: CustomColors.greyShade2,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: '${angle.round().toString()}\n',
                      style: textTheme.displaySmall!.copyWith(
                          color: CustomColors.greyShade2, letterSpacing: 2),
                    ),
                    TextSpan(
                      text: 'yaw axis',
                      style: textTheme.bodyMedium!.copyWith(
                          fontSize: 20, color: CustomColors.greyShade3),
                    )
                  ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedContainer extends StatelessWidget {
  final double height;
  final GradientModel gradientColors;
  final Widget? child;

  const CurvedContainer({
    Key? key,
    required this.height,
    required this.gradientColors,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Opacity(opacity: 0.4, child: curvedBox(h: height + 40)),
        curvedBox(h: height),
        child ?? const SizedBox(),
      ],
    );
  }

  Widget curvedBox({required double h}) {
    return ClipPath(
      clipper: CurveClipper(),
      child: AnimatedContainer(
        height: h,
        width: double.infinity,
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [gradientColors.color1, gradientColors.color2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
      ),
    );
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curveHeight = 140;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);

    Path path = Path()
      ..lineTo(0, curveHeight)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, curveHeight)
      ..quadraticBezierTo(controlPoint.dx, 0, 0, curveHeight)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
