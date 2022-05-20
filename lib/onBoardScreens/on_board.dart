import 'package:flutter/material.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:rive/rive.dart';

// const String _gyro = 'assets/gyroWW.svg';
// const String _joystick = 'assets/joystick.svg';
// const String assetName = 'assets/image.svg';
const double _fraction = 1.5;
const String _gyroA = 'assets/gyroAW.riv';
const String _joystickA = 'assets/joyAW.riv';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pgController = PageController(
    initialPage: 0,
  );
  int _currPage = 0;
  void _pgFn() {
    (_currPage < 2) ? _currPage++ : _currPage = 0;
  }

  @override
  void dispose() {
    pgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        PageView(
          controller: pgController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) {
            _currPage = index;
            setState(() {});
          },
          children: const [
            _GyroOb(),
            _JoystickOb(),
            _HepticOb(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RoundedButton(
                buttonLabel: (_currPage == 2) ? 'Finish' : 'Next',
                onTap: () {
                  _pgFn();
                  pgController.animateToPage(_currPage,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut);
                  setState(() {});
                }),
            SizedBox(
              height: _size.height * 0.08,
            ),
          ],
        ),
      ]),
    );
  }
}

const String _gyroDes =
    "Tell you the sense of direction of the crawler as rotate or move the crawler ";
const String _joystickDes =
    "All you need to do is move the joystick with your and crawler  will move accordingly";
const String _hepticDes =
    "Before crawler hit the wall it will send you a feedback as a vibration";

class _GyroOb extends StatelessWidget {
  const _GyroOb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final TextTheme _txtTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: _size.width / _fraction,
          width: _size.width / _fraction,
          child: const RiveAnimation.asset(
            _gyroA,
            artboard: 'gyroAW',
          ),
        ),
        SizedBox(height: _size.height * 0.12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: 'Gyro\n\n', style: _txtTheme.headlineMedium),
                TextSpan(text: _gyroDes, style: _txtTheme.bodyMedium)
              ])),
        ),
        SizedBox(height: _size.height * 0.1),
        SizedBox(height: _size.height * 0.08)
      ],
    );
  }
}

class _JoystickOb extends StatelessWidget {
  const _JoystickOb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final TextTheme _txtTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: _size.width / _fraction,
          width: _size.width / _fraction,
          child: const RiveAnimation.asset(
            _joystickA,
            artboard: 'joystickAW',
          ),
        ),
        SizedBox(height: _size.height * 0.12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Joystick\n\n\n', style: _txtTheme.headlineMedium),
                TextSpan(text: _joystickDes, style: _txtTheme.bodyMedium)
              ])),
        ),
        SizedBox(height: _size.height * 0.1),
        SizedBox(height: _size.height * 0.08),
      ],
    );
  }
}

class _HepticOb extends StatelessWidget {
  const _HepticOb({Key? key}) : super(key: key);
  final String assetName = 'assets/image.svg';
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final TextTheme _txtTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // SvgPicture.asset(assetName), SizedBox(height: _size.height * 0.12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: 'Heptic Feedback\n\n\n',
                    style: _txtTheme.headlineMedium),
                TextSpan(text: _hepticDes, style: _txtTheme.bodyMedium)
              ])),
        ),
        SizedBox(height: _size.height * 0.1),

        SizedBox(height: _size.height * 0.08),
      ],
    );
  }
}
