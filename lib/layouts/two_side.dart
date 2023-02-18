import 'package:flutter/material.dart';
import 'package:iot/colors.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TowColumn extends StatelessWidget {
  final Widget leftChild; // mior widget
  final Widget rightChild; // major widget
  const TowColumn({Key? key, required this.leftChild, required this.rightChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 280,
            height: double.infinity,
            child: leftChild,
          ),
        ),
        Expanded(
            child: Material(
          color: Colors.black.withOpacity(0.6),
          child: SizedBox(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 40),
              child: rightChild,
            ),
          ),
        ))
      ],
    );
  }
}

class LeftWidget extends StatelessWidget {
  const LeftWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [],
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

class MaxMinWidget extends StatelessWidget {
  final String max;
  final String min;
  const MaxMinWidget({
    Key? key,
    required this.max,
    required this.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('max : $max'),
        const SizedBox(height: 2),
        Text('min : $min'),
      ],
    );
  }
}

class TiltleText extends StatelessWidget {
  final int boxWidth;
  final String data;
  final IconData iconData;
  const TiltleText({
    Key? key,
    required this.data,
    required this.iconData,
    required this.boxWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return SizedBox(
      // width: boxWidth.toDouble(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Icon(
              iconData,
              size: 36,
              color: kLtGrey,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            data,
            style: txtTheme.displayMedium!
                .copyWith(fontSize: 72, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }
}

class TextCumProgress extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final int min;
  const TextCumProgress({
    Key? key,
    required this.label,
    required this.value,
    required this.max,
    required this.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value.toString()),
        Text(label),
        LinearGradProgressBar(max: max, min: min, value: value)
      ],
    );
  }
}

class TextLabel extends StatelessWidget {
  final String label;
  final int value;

  const TextLabel({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value.toString(),
            style: txtTheme.displayMedium,
          ),
          const SizedBox(height: 0),
          Text(label),
        ],
      ),
    );
  }
}

class LinearGradProgressBar extends StatelessWidget {
  final int max;
  final int min;
  final int value;
  const LinearGradProgressBar(
      {Key? key, required this.max, required this.min, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StepProgressIndicator(
      totalSteps: max - min,
      currentStep: value,
      size: 10,
      padding: 0,
      unselectedColor: kspaceBlack,
      roundedEdges: const Radius.circular(10),
      selectedGradientColor: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [themeColor1, themeColor2],
      ),
    );
  }
}
