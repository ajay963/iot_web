import 'package:flutter/material.dart';
import 'package:iot/models/gradient_model.dart';

import '../utilities/colors.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final GradientModel gradient;
  final IconData icon;
  final bool isSelected;
  const CustomCard({
    Key? key,
    required this.title,
    required this.description,
    required this.gradient,
    required this.icon,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.1 * MediaQuery.of(context).size.height),
          Center(
            child: Container(
              alignment: Alignment.center,
              height: 140,
              width: 140,
              child: Container(
                alignment: Alignment.center,
                height: 140,
                width: 140,
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: Icon(
                    icon,
                    size: 52,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border(
                    top: BorderSide(
                        color: Colors.white.withOpacity(0.2), width: 6),
                    bottom: BorderSide(
                        color: Colors.white.withOpacity(0.2), width: 6),
                    right: BorderSide(
                        color: Colors.white.withOpacity(0.2), width: 6),
                    left: BorderSide(
                        color: Colors.white.withOpacity(0.2), width: 6),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [gradient.color1, gradient.color2],
                    center: Alignment.topLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.color1.withOpacity(0.5),
                      offset: const Offset(0, 10),
                      blurRadius: 24,
                      spreadRadius: 4,
                    )
                  ]),
            ),
          ),
          SizedBox(height: 0.1 * MediaQuery.of(context).size.height),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            height: (isSelected) ? 10 : 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              title,
              style: textTheme.displayMedium!
                  .copyWith(color: CustomColors.blackShade2),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeIn,
            height: (!isSelected) ? 10 : 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                description,
                style: textTheme.bodyMedium!
                    .copyWith(color: CustomColors.greyShade3),
              ),
            ),
          )
        ],
      ),
    );
  }
}
