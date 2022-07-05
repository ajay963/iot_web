import 'package:flutter/material.dart';
import 'package:iot/themes.dart';
import 'package:line_icons/line_icons.dart';

class CollisionWidget extends StatelessWidget {
  final double distance;
  const CollisionWidget({Key? key, required this.distance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: Text(
            '${distance.toInt()} Ahead',
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'collision alert',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(width: 20),
            const Icon(
              LineIcons.exclamationTriangle,
              color: kThemeShadeMagenta,
            )
          ],
        )
      ],
    );
  }
}
