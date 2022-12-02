import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/Material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot/layouts/two_side.dart';

class AQIDesktopView extends StatelessWidget {
  const AQIDesktopView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: MoveWindow(),
          ),
          Text(
            'Air Quality Index',
            style: txtTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Text(
                '2432',
                style: txtTheme.displayMedium,
              ),
              const SizedBox(width: 20),
              const MaxMinWidget(max: '24', min: '9')
            ],
          ),
          const SizedBox(height: 10),
          const SizedBox(
              width: 200,
              child: LinearGradProgressBar(max: 224, min: 9, value: 42)),
          const SizedBox(height: 60),
          Text('Other Gases', style: txtTheme.bodyMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextLabel(label: 'Carbon Monoxide', value: 2433),
                  SizedBox(height: 10),
                  LinearGradProgressBar(max: 3000, min: 0, value: 2433),
                ],
              ),
              const SizedBox(width: 100),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextLabel(label: 'Flamable Gases', value: 324),
                  SizedBox(height: 10),
                  LinearGradProgressBar(max: 900, min: 0, value: 324),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
