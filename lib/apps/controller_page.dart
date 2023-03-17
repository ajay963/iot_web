import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iot/widgets/joystick_pad.dart';

import '../utilities/colors.dart';

class ControllerPage extends StatelessWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.24 * screenSize.width),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              JoyStickWidget(
                  mode: JoystickMode.horizontal,
                  listener: (data) {
                    debugPrint('y : ${data.x * 100}');
                  }),
              rotationButtons(context),
              JoyStickWidget(
                  mode: JoystickMode.vertical,
                  listener: (data) {
                    debugPrint('x : ${data.y * 100}');
                  }),
            ]),
      ),
    );
  }

  buttons(
      {required IconData icon,
      bool flipIcon = false,
      required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          height: 50,
          width: 50,
          child: Center(
            child: Transform.rotate(
              angle: 90 * (pi / 180),
              child: Icon(
                icon,
                size: 30,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
            // border: Border.all(width: 4, color: Colors.white.withOpacity(0.3)),

            // boxShadow: [
            //   BoxShadow(
            //       color: CustomColors.redShade1.withOpacity(0.4),
            //       offset: const Offset(0, 4),
            //       blurRadius: 24,
            //       spreadRadius: 6)
            // ]
          ),
        ),
      ),
    );
  }

  rotationButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buttons(icon: Iconsax.flash_1, onTap: () {}),
        buttons(icon: Iconsax.colorfilter, onTap: () {}),
        buttons(
            icon: Iconsax.close_circle,
            onTap: () {
              Navigator.pop(context);
            }),
      ],
    );
  }
}
