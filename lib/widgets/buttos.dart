import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../utilities/colors.dart';

class CustomBackButton extends StatelessWidget {
  final Function() onTap;

  const CustomBackButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Ink(
        height: 56,
        width: 56,
        child: const Center(
          child: Icon(
            Iconsax.arrow_left,
            color: Colors.white,
            size: 20,
          ),
        ),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: CustomColors.blackShade1),
      ),
    );
  }
}
