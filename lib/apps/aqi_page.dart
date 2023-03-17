import 'package:flutter/material.dart';
import 'package:iot/utilities/colors.dart';

import '../widgets/buttos.dart';

const int gasData1 = 142;
const int gasData2 = 1942;
const int gasData3 = 2317;

class AQIPage extends StatelessWidget {
  const AQIPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomBackButton(onTap: () => Navigator.pop(context)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'AQI',
                style: textTheme.displayLarge!
                    .copyWith(fontSize: 40, color: CustomColors.greyShade3),
              ),
            ),
            SizedBox(height: 0.1 * screenSize.height),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Index',
                style: textTheme.bodyLarge!
                    .copyWith(fontSize: 32, color: CustomColors.greyShade3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                gasData1.toString(),
                style: textTheme.displaySmall!
                    .copyWith(fontSize: 48, color: CustomColors.blackShade2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'risk level : low',
                style: textTheme.bodyLarge!
                    .copyWith(fontSize: 20, color: CustomColors.greyShade3),
              ),
            ),
            SizedBox(height: 0.1 * screenSize.height),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Other Gases',
                style: textTheme.bodyLarge!
                    .copyWith(fontSize: 32, color: CustomColors.greyShade3),
              ),
            ),
            SizedBox(height: 0.02 * screenSize.height),
            gasConcentrationBox(
                label: 'Carbon Monoxide',
                concentration: gasData3,
                unit: 'ppm',
                textTheme: textTheme),
            gasConcentrationBox(
                label: 'Flamable Gases',
                concentration: gasData2,
                unit: 'ppm',
                textTheme: textTheme)
          ],
        ),
      ),
    );
  }

  gasConcentrationBox(
      {required String label,
      required int concentration,
      required String unit,
      required TextTheme textTheme}) {
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: textTheme.bodyLarge!
                  .copyWith(fontSize: 16, color: CustomColors.blackShade1),
            ),
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: concentration.toString() + ' ',
              style: textTheme.displaySmall!.copyWith(
                fontSize: 36,
                color: CustomColors.blackShade2,
              ),
            ),
            TextSpan(
              text: unit,
              style: textTheme.bodyLarge!.copyWith(
                  fontSize: 24,
                  color: CustomColors.greyShade1,
                  fontWeight: FontWeight.w500),
            )
          ]))
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xffcccccc).withOpacity(0.4),
            CustomColors.greyShade3.withOpacity(0.4)
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}
