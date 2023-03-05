import 'package:flutter/material.dart';
import 'package:iot/gradient_model.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                size: 42,
                color: Colors.white,
              ),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              color: Colors.white.withOpacity(0.2),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.2), width: 6),
                bottom:
                    BorderSide(color: Colors.white.withOpacity(0.2), width: 6),
                right:
                    BorderSide(color: Colors.white.withOpacity(0.2), width: 6),
                left:
                    BorderSide(color: Colors.white.withOpacity(0.2), width: 6),
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
          height: (isSelected) ? 10 : 60,
        ),
        Text(
          title,
          style: textTheme.displayMedium,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeIn,
          height: (!isSelected) ? 10 : 60,
        ),
        Text(
          description,
          style: textTheme.bodyMedium,
        )
      ],
    );
  }
}
