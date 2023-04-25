import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iot/apps/controller_page.dart';
import 'package:iot/apps/tracking_page.dart';
import 'package:iot/controller/weather_page.dart';
import 'package:iot/models/gradient_model.dart';
import 'package:iot/widgets/cards.dart';
import 'package:line_icons/line_icons.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'apps/aqi_page.dart';
import 'apps/radar_page.dart';
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
          icon: Iconsax.location,
          isSelected: (index == 0)),
      CustomCard(
          title: 'Rover\nController',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.lavaGradient,
          icon: Iconsax.notification_circle,
          isSelected: (index == 1)),
      CustomCard(
          title: 'Weather\nMonitoring',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.blueGradient,
          icon: Iconsax.cloud,
          isSelected: (index == 2)),
      CustomCard(
          title: 'Ultrasonic\nRadar',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.greenGradient,
          icon: Iconsax.radar_2,
          isSelected: (index == 3)),
      CustomCard(
          title: 'AQI\nIndex',
          description: 'it is a long established fact that a reader will',
          gradient: CustomGradients.magentaGradient,
          icon: Iconsax.airdrop,
          isSelected: (index == 4)),
    ];
    return items;
  }

  List<Widget> appPages = [
    const GPSPage(),
    const ControllerPage(),
    WeatherPage(),
    const RadarPage(),
    const AQIPage(),
  ];
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: CustomMenuButton(onTap: () {
            showDialog(
                useSafeArea: false,
                context: context,
                builder: (context) {
                  return const AppMenu();
                });
          }),
        ),
      ),
      floatingActionButton: Visibility(
        visible: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (contetx) => appPages[currTab]));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
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

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: Colors.black.withOpacity(0.6),
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: CustomCloseButton(onTap: () {
            Navigator.pop(context);
            debugPrint('Button tap');
          }),
        ),
      ),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.2 * MediaQuery.of(context).size.height,
              ),
              items(
                  label: 'network info',
                  icon: LineIcons.wifi,
                  gradientColor: CustomGradients.yellowGradient,
                  onTap: () {},
                  textTheme: textTheme),
              lineDivider(),
              items(
                  label: 'Database',
                  icon: LineIcons.database,
                  gradientColor: CustomGradients.naturegreenGradient,
                  onTap: () {},
                  textTheme: textTheme),
              lineDivider(),
              items(
                  label: 'Error Log',
                  icon: LineIcons.bug,
                  gradientColor: CustomGradients.lavaGradient,
                  onTap: () {},
                  textTheme: textTheme),
              lineDivider(),
              items(
                  label: 'About App',
                  icon: LineIcons.infoCircle,
                  gradientColor: CustomGradients.waterGradient,
                  onTap: () {},
                  textTheme: textTheme),
              lineDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget lineDivider() {
    return Container(
      height: 2,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.2),
          Colors.white.withOpacity(0.0)
        ],
      )),
    );
  }

  Widget items(
      {required String label,
      required IconData icon,
      required GradientModel gradientColor,
      required Function() onTap,
      required TextTheme textTheme}) {
    return InkWell(
      onTap: onTap,
      splashColor: gradientColor.color2.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.only(left: 80, top: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [gradientColor.color1, gradientColor.color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
            ),
            const SizedBox(width: 40),
            Text(
              label,
              style: textTheme.bodyMedium!
                  .copyWith(fontSize: 20, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class CustomMenuButton extends StatelessWidget {
  final Function() onTap;
  const CustomMenuButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Ink(
        height: 56,
        width: 56,
        child: const Center(
          child: Icon(LineIcons.pencilRuler),
        ),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: CustomColors.blackShade1),
      ),
    );
  }
}

class CustomCloseButton extends StatelessWidget {
  final Function() onTap;

  const CustomCloseButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: 56,
        width: 56,
        child: Center(
          child: Icon(
            LineIcons.times,
            color: Colors.white.withOpacity(0.8),
            size: 30,
          ),
        ),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
          gradient: LinearGradient(
            colors: [CustomColors.redShade1, CustomColors.redShade2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
