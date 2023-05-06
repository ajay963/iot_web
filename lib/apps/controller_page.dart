import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iot/utilities/logger.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:vibration/vibration.dart';

import '../controller/master_controller.dart';
import '../models/info.dart';
import '../utilities/colors.dart';

var log = getLogger("rover controller");

const String gyroAssetPath = "assets/gyro.svg";

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  int velocityX = 0;
  int velocityY = 0;
  final MasterDataController data = Get.find<MasterDataController>();

  ControlData mData = ControlData(x: 0, y: 0, r: 0, g: 0, b: 0, led: false);
  setVelocity({double? x_data, double? y_data}) {
    log.i("x-axis : $x_data y-data : $y_data");

    if (x_data != null) {
      mData.x = x_data.toInt();
    }
    if (y_data != null) {
      mData.y = y_data.toInt();
    }
    // mData = mData.copyWith(x: velocityX, y: velocityY);
    // log.i(mData.toString());
    log.i(mData.toJson().toString());
    data.sendcmd(mData.toJson());
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
      body: GetBuilder<MasterDataController>(
          builder: (MasterDataController data) {
        return Stack(alignment: Alignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              boundaryErrorWidgets(data.sensorsData.value.reflex.lClr,
                  size: screenSize, flip: true),
              boundaryErrorWidgets(data.sensorsData.value.reflex.rClr,
                  size: screenSize),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.24 * screenSize.width),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  JoyStickWidget(
                    mode: JoystickMode.horizontal,
                    listener: (data) {
                      setVelocity(y_data: data.x * 100);
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 80),
                      rotationButtons(context),

                      Transform.rotate(
                        angle: (data.sensorsData.value.reflex.roll + 90) *
                            (pi / 180),
                        child: SizedBox(
                            height: 80,
                            width: 80,
                            child: SvgPicture.asset(gyroAssetPath)),
                      ),
                      // Transform.rotate(
                      //   angle: 90 * (pi / 180),
                      //   child: RichText(
                      //     textAlign: TextAlign.center,
                      //     text: TextSpan(children: [
                      //       TextSpan(
                      //         text: velocityY.toString() + '\t',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .displaySmall!
                      //             .copyWith(color: CustomColors.redShade1),
                      //       ),
                      //       TextSpan(
                      //         text: 'cm/s',
                      //         style: Theme.of(context)
                      //             .textTheme
                      //             .bodyMedium!
                      //             .copyWith(
                      //                 fontSize: 20,
                      //                 color: CustomColors.greyShade3,
                      //                 letterSpacing: 1.5),
                      //       ),
                      //     ]),
                      //   ),
                      // ),

                      // Transform.rotate(
                      //   angle: 90 * (pi / 180),
                      //   child: SizedBox(
                      //     width: 200,
                      //     child: RotationGuage(
                      //       color1: CustomColors.magentaShade1,
                      //       color2: CustomColors.redShade1,
                      //       value: velocityY,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  JoyStickWidget(
                    mode: JoystickMode.vertical,
                    listener: (data) {
                      setVelocity(x_data: data.y * 100);
                    },
                  ),
                ]),
          ),
        ]);
      }),
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
    // if distance is less than 10 cm then alert the user by heptic (vibration)
    if (value < 10) {
      hepticFn();
    }

    double opacityVal = (value < 10) ? (10 - value) / 10 : 0;

    return Visibility(
      visible: (value < 10),
      child: Opacity(
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
      ),
    );
  }
}
