import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';

class CustomBackButton extends StatelessWidget {
  final Function() onTap;
  const CustomBackButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
        height: 36,
        width: 36,
        decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color(0x88aaaaaa),
                  blurRadius: 12,
                  offset: Offset(0, 4))
            ]),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          // hoverColor: Colors.green,
          child: LineIcon.arrowLeft(
            color: Colors.grey,
            size: 20,
          ),
        ));
  }
}
