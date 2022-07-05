import 'package:flutter/material.dart';

class CrawlerInfo extends StatelessWidget {
  final int speed;
  final int temp;
  final int humidity;
  const CrawlerInfo(
      {Key? key,
      required this.speed,
      required this.temp,
      required this.humidity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$speed kmph', style: textTheme.bodyLarge),
        Text('Temp: $temp c', style: textTheme.bodyMedium),
        Text('Hunidity: $humidity c', style: textTheme.bodyMedium),
      ],
    );
  }
}
