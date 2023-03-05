import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot/colors.dart';
import 'package:iot/widgets/cards.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currTab = 0;
  final CarouselController _carouselController = CarouselController();
  List<Widget> items = [
    CustomCard(
        title: 'Live\nTracking',
        description: 'it is a long established fact that a reader will',
        gradient: CustomGradients.orangeGradient,
        icon: LineIcons.locationArrow,
        isSelected: false),
    CustomCard(
        title: 'Weather\nMonitoring',
        description: 'it is a long established fact that a reader will',
        gradient: CustomGradients.blueGradient,
        icon: LineIcons.cloud,
        isSelected: false),
    CustomCard(
        title: 'Ultrasonic\nRadar',
        description: 'it is a long established fact that a reader will',
        gradient: CustomGradients.greenGradient,
        icon: LineIcons.radiation,
        isSelected: false),
    CustomCard(
        title: 'AQI\nIndex',
        description: 'it is a long established fact that a reader will',
        gradient: CustomGradients.magentaGradient,
        icon: LineIcons.airbnb,
        isSelected: false),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider(
        carouselController: _carouselController,
        options: CarouselOptions(),
        items: [],
      ),
    );
  }
}
