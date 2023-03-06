import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot/widgets/cards.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'utilities/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currTab = 0;
  final CarouselController _carouselController = CarouselController();

  List<Widget> items(int index) {
    List<Widget> items = [
      CustomCard(
          title: 'Live\nTracking',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.orangeGradient,
          icon: LineIcons.locationArrow,
          isSelected: (index == 0)),
      CustomCard(
          title: 'Weather\nMonitoring',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.blueGradient,
          icon: LineIcons.cloud,
          isSelected: (index == 1)),
      CustomCard(
          title: 'Ultrasonic\nRadar',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.greenGradient,
          icon: LineIcons.broadcastTower,
          isSelected: (index == 2)),
      CustomCard(
          title: 'AQI\nIndex',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.magentaGradient,
          icon: LineIcons.airbnb,
          isSelected: (index == 3)),
    ];
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Text(
                'View',
                style: textTheme.bodyMedium!
                    .copyWith(fontSize: 20, letterSpacing: 2),
              ),
            ),
            style: TextButton.styleFrom(
                backgroundColor: CustomColors.blackShade2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
          ),
          const SizedBox(height: 20),
          AnimatedSmoothIndicator(
              activeIndex: currTab,
              count: items(currTab).length,
              effect: SwapEffect(
                type: SwapType.yRotation,
                activeDotColor: CustomGradients.gradientList[currTab].color2,
              ))
        ],
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.6,
                  viewportFraction: 1,
                  autoPlayCurve: Curves.bounceInOut,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currTab = index;
                    });
                  }),
              items: items(currTab),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    CustomGradients.gradientList[currTab].color1
                        .withOpacity(0.2),
                    CustomGradients.gradientList[currTab].color2
                        .withOpacity(0.0)
                  ])),
            ),
          ]),
    );
  }
}
