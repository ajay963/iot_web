import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../home_page.dart';
import '../utilities/colors.dart';
import '../widgets/buttos.dart';

const String path = 'assets/animations/birdy.riv';

class BirdWalk extends StatelessWidget {
  const BirdWalk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.yellow.shade50,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomBackButton(onTap: () => Navigator.pop(context)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 0.8 * MediaQuery.of(context).size.width,
              width: 0.8 * MediaQuery.of(context).size.width,
              child: const RiveAnimation.asset(
                path,
                animations: ['Pro'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            'connecting...',
            style: textTheme.displayLarge!
                .copyWith(color: CustomColors.greyShade3, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
