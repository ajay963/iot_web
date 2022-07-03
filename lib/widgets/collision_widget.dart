import 'package:flutter/material.dart';

class CollisionIdget extends StatelessWidget {
  final double distance;
  const CollisionIdget({Key? key, required this.distance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text('${distance.toInt()} Ahead'),
        Row(
          children: [
            Text(
              'collision alert',
              style: textTheme.bodySmall,
            ),
            const Icon(Icons.warning)
          ],
        )
      ],
    );
  }
}
