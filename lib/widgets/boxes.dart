import 'package:flutter/material.dart';

class ColorBox extends StatelessWidget {
  final Color colorCode;
  final Function() onTap;
  const ColorBox({
    Key? key,
    required this.colorCode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _boxSize = (MediaQuery.of(context).size.width > 600) ? 60 : 40;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      splashColor: Colors.white.withOpacity(0.5),
      child: Ink(
        height: _boxSize,
        width: _boxSize,
        decoration: BoxDecoration(
            color: colorCode, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

class GradientBox extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String graientName;
  final Function() onTap;
  const GradientBox({
    Key? key,
    required this.color1,
    required this.color2,
    required this.graientName,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _boxSize = (MediaQuery.of(context).size.width > 600) ? 60 : 40;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      splashColor: Colors.white.withOpacity(0.5),
      child: Ink(
        height: _boxSize,
        width: _boxSize,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
      ),
    );
  }
}
