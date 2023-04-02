import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoadAnimation extends StatelessWidget {
  const LoadAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        height: 300,
        width: 300,
        child: Center(
          child: RiveAnimation.asset(
            'assets/animations/loads.riv',
            artboard: 'wait',
            animations: ['loop'],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class RiveRadar extends StatefulWidget {
  final double angle;
  final bool isObstacle;
  const RiveRadar({
    Key? key,
    required this.angle,
    required this.isObstacle,
  }) : super(key: key);

  @override
  State<RiveRadar> createState() => _RiveRadarState();
}

class _RiveRadarState extends State<RiveRadar> {
  Artboard? _riveArtboard;
  StateMachineController? controller;
  SMIInput<double>? rotation;
  SMIInput<bool>? obstacle;
  late Timer timer;

  @override
  void initState() {
    timer =
        Timer.periodic(const Duration(milliseconds: 300), (timer) => setUp());
    super.initState();
    rootBundle.load('assets/animations/loads.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.artboardByName('scan');
      StateMachineController? controller =
          StateMachineController.fromArtboard(artboard!, 'radar');
      if (controller != null) {
        artboard.addController(controller);
        try {
          rotation = controller.findInput('rotation');
          obstacle = controller.findInput('obs');
        } catch (error) {
          debugPrint(error.toString());
        }
        _riveArtboard = artboard;
        setState(() {});
      }
    });
  }

  void setUp() {
    debugPrint('value changing');

    rotation?.value = widget.angle;
    obstacle?.value = widget.isObstacle;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (_riveArtboard != null) {
        return Rive(
          artboard: _riveArtboard!,
          alignment: Alignment.center,
          fit: BoxFit.cover,
        );
      }
      return const Center(
        child: SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
