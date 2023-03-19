import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iot/utilities/colors.dart';

class Assets {
  static const String arrow = 'assets/joystick/arrow.svg';
  static const String border = 'assets/joystick/border.svg';
}

class JoyStickWidget extends StatelessWidget {
  final JoystickMode mode;
  final Function(StickDragDetails) listener;
  const JoyStickWidget({
    Key? key,
    required this.listener,
    this.mode = JoystickMode.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Joystick(
        mode: mode,
        period: const Duration(milliseconds: 350),
        listener: listener,
        base: SizedBox(
          height: 0.6 * screenSize.width,
          width: 0.6 * screenSize.width,
          child: Transform.rotate(
            angle: (mode == JoystickMode.vertical) ? 0 : 90 * (pi / 180),
            child: SvgPicture.asset(
              Assets.border,
              height: 0.6 * screenSize.width,
              width: 0.6 * screenSize.width,
              fit: BoxFit.contain,
            ),
          ),
        ),
        stick: Container(
          height: 100,
          width: 100,
          child: Opacity(
            opacity: 0.4,
            child: Transform.rotate(
              angle: (mode == JoystickMode.vertical) ? 90 * (pi / 180) : 0,
              child: SvgPicture.asset(
                Assets.arrow,
              ),
            ),
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(width: 6, color: Colors.white.withOpacity(0.2)),
              gradient: const LinearGradient(
                  colors: [CustomColors.redShade1, CustomColors.redShade2],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight),
              boxShadow: [
                BoxShadow(
                    color: CustomColors.redShade1.withOpacity(0.4),
                    offset: const Offset(-4, 0),
                    blurRadius: 24,
                    spreadRadius: 6)
              ]),
        ),
      ),
    );
  }
}
