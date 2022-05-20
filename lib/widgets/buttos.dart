import 'package:flutter/material.dart';
import 'package:iot/colors.dart';

class CustomRoudedButto extends StatelessWidget {
  final String text;
  final Function() onTap;
  const CustomRoudedButto({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme _txtTheme = Theme.of(context).textTheme;
    // final _color = Provider.of<LightData>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      hoverColor: Colors.white.withOpacity(0.2),
      onTap: onTap,
      child: Ink(
        height: 40,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(text, style: _txtTheme.bodyText1)),
        decoration: BoxDecoration(
          color: (Theme.of(context).brightness == Brightness.light)
              ? kLtGrey
              : kDarkBlack,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String itemLabel;
  final Function() onTap;
  const GradientButton({
    Key? key,
    required this.itemLabel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _txtTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: onTap,
      child: Ink(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(itemLabel, style: _txtTheme.headline1),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String buttonLabel;
  final double fontSize;
  final double horizontalPadding;
  final Function() onTap;
  const RoundedButton(
      {Key? key,
      required this.buttonLabel,
      required this.onTap,
      this.horizontalPadding = 60,
      this.fontSize = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    final TextTheme _txtTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      splashColor: Colors.orange.shade100,
      child: Ink(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.center,
          style: _txtTheme.labelMedium!.copyWith(
            fontSize: fontSize,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onTap: onTap,
    );
  }
}

class CircularButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final bool state;
  const CircularButton(
      {Key? key, required this.icon, required this.onTap, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme _txtTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      splashColor: Colors.orange.shade100,
      child: Ink(
        height: 60,
        width: 60,
        child: Icon(
          icon,
          size: 24,
          color: Colors.orange,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (state) ? Colors.white : Colors.white.withOpacity(0.5),
        ),
      ),
      onTap: onTap,
    );
  }
}
