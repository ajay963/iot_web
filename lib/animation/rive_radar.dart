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
  const RiveRadar({Key? key}) : super(key: key);

  @override
  State<RiveRadar> createState() => _RiveRadarState();
}

class _RiveRadarState extends State<RiveRadar> {
  Artboard? _riveArtboard;
  StateMachineController? controller;
  SMIInput<double>? rotation;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/animations/loads.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.artboardByName('scan');
      StateMachineController? controller =
          StateMachineController.fromArtboard(artboard!, 'rotation');
      if (controller != null) {
        artboard.addController(controller);
        rotation = controller.findInput('rotation');
        _riveArtboard = artboard;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
        width: 300,
        child: Rive(
          artboard: _riveArtboard!,
          alignment: Alignment.center,
        ));
  }
}
