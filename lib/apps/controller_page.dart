import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:vibration/vibration.dart';

import '../controller/rover_controller.dart';
import '../models/info.dart';
import '../utilities/colors.dart';
import '../widgets/radial_gauges.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int velocityX = 0;
  int velocityY = 0;
  final RoverIcomingDataControllerTest websocket =
      Get.put(RoverIcomingDataControllerTest());
  ControlData mData = ControlData(x: 0, y: 0, r: 0, g: 0, b: 0, led: false);
  setVelocity({double? x, double? y}) {
    if (x != null) {
      debugPrint('x : $x}');
      velocityX = x.toInt();
    }
    if (y != null) {
      debugPrint('y : $y}');
      velocityY = y.toInt();
    }
    if (x != null && x < 0) velocityX = -1 * x.toInt();
    if (y != null && y < 0) velocityY = -1 * y.toInt();

    mData.x = velocityX;
    mData.y = velocityY;
    // mData = mData.copyWith(x: velocityX, y: velocityY);
    debugPrint(mData.toString());
    debugPrint(mData.toJson().toString());
    websocket.sendcmd(mData.toJson());
    setState(() {});
  }

  @override
  void dispose() {
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            boundaryErrorWidgets(velocityY, size: screenSize, flip: true),
            boundaryErrorWidgets(velocityX, size: screenSize),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.24 * screenSize.width),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JoyStickWidget(
                  mode: JoystickMode.horizontal,
                  listener: (data) {
                    setVelocity(y: data.x * 100);
                  },
                ),
                Row(
                  children: [
                    rotationButtons(context),
                    Transform.rotate(
                      angle: 90 * (pi / 180),
                      child: SizedBox(
                        width: 200,
                        child: RotationGuage(
                          color1: CustomColors.magentaShade1,
                          color2: CustomColors.redShade1,
                          value: velocityY,
                        ),
                      ),
                    ),
                  ],
                ),
                JoyStickWidget(
                  mode: JoystickMode.vertical,
                  listener: (data) {
                    setVelocity(x: data.y * 100);
                  },
                ),
              ]),
        ),
      ]),
    );
  }

  buttons(
      {required IconData icon, bool isOn = false, required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: InkWell(
        onTap: onTap,
        splashColor: CustomColors.magentaShade1,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          height: 50,
          width: 50,
          child: Center(
            child: Transform.rotate(
              angle: 90 * (pi / 180),
              child: Icon(
                icon,
                size: 30,
                color: CustomColors.greyShade3,
              ),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              // border: Border.all(width: 4, color: Colors.white.withOpacity(0.3)),

              boxShadow: [
                BoxShadow(
                    color: CustomColors.redShade1.withOpacity(0.2),
                    offset: const Offset(-4, 0),
                    blurRadius: 10,
                    spreadRadius: 0)
              ]),
        ),
      ),
    );
  }

  hepticFn() {
    Vibration.vibrate();
  }

  rotationButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buttons(icon: Iconsax.flash_1, onTap: () {}),
        buttons(
            icon: Iconsax.close_circle,
            onTap: () {
              Navigator.pop(context);
            }),
      ],
    );
  }

  boundaryErrorWidgets(int value, {required Size size, bool flip = false}) {
    if (value > 90) {
      value = value;
      hepticFn();
    } else {
      value = 0;
    }

    double opacityVal = value / 100;

    return Opacity(
      opacity: 0.4,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: 0.3 * size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            CustomColors.redShade1.withOpacity(opacityVal),
            Colors.white.withOpacity(0)
          ],
          begin: (flip) ? Alignment.topCenter : Alignment.bottomCenter,
          end: (flip) ? Alignment.bottomCenter : Alignment.topCenter,
        )),
      ),
    );
  }
}
