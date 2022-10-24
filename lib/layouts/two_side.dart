import 'package:flutter/material.dart';

class TowColumn extends StatelessWidget {
  final Widget leftChild;
  final Widget rightChild;
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
