import 'package:flutter/material.dart';
import 'package:iot/widgets/text_widgets.dart';

class TowColumn extends StatelessWidget {
  final Widget leftChild; // mior widget
  final Widget rightChild; // major widget
  const TowColumn({Key? key, required this.leftChild, required this.rightChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 280,
          height: double.infinity,
          child: leftChild,
        ),
        Expanded(child: rightChild)
      ],
    );
  }
}

class LeftWidget extends StatelessWidget {
  const LeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AtmosDataWidget(
            airIndex: 78, carbonMonoxide: 266, methane: 187, conductivity: 90),
        SatelliteInfoWidget(
            seaLevel: 908, satelliteNo: 12, lat: 987239, long: 923782)
      ],
    );
  }
}

class RightWidget extends StatelessWidget {
  const RightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Row(), Row()],
    );
  }
}
