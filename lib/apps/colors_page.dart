import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iot/utilities/colors.dart';

import '../widgets/buttos.dart';

const int gasData1 = 142;
const int gasData2 = 1942;
const int gasData3 = 2317;

class ColorsPage extends StatefulWidget {
  const ColorsPage({Key? key}) : super(key: key);

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  Color selectedColor = CustomColors.redShade1;
  CarouselController carouselController = CarouselController();
  int _currIndex = 0;
  changePage(int index) {
    selectedColor = CustomColors.colorList[index];
    setState(() {});
    _currIndex = index;
    debugPrint(_currIndex.toString());
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Colour',
              style: textTheme.displayLarge!
                  .copyWith(fontSize: 40, color: CustomColors.greyShade3),
            ),
          ),
          SizedBox(height: 0.1 * screenSize.height),
          Center(
            child: AnimatedContainer(
              height: 150,
              width: 150,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: selectedColor.withOpacity(0.4),
                        offset: const Offset(0, 10),
                        blurRadius: 24,
                        spreadRadius: 6)
                  ]),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                selectedColor
                    .toString()
                    .replaceAll('Color(0xff', '#')
                    .replaceAll(')', '')
                    .toUpperCase(),
                style: textTheme.displaySmall!
                    .copyWith(fontSize: 24, color: CustomColors.greyShade3),
              ),
            ),
          ),
          SizedBox(
            height: 0.1 * screenSize.height,
          ),
          SizedBox(
            height: 0.18 * screenSize.height,
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: CustomColors.colorList.length,
              itemBuilder: (context, index, currPage) {
                return colorBox(
                    color: CustomColors.colorList[index],
                    isSelected: (_currIndex == index));
              },
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                scrollPhysics: const BouncingScrollPhysics(),
                viewportFraction: 0.2,
                aspectRatio: 1,
                initialPage: _currIndex,
                onPageChanged: (index, _) => changePage(index),
              ),
            ),
          ),
          AnimatedContainer(
            height: 0.1 * screenSize.height,
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              selectedColor.withOpacity(0),
              selectedColor.withOpacity(0.2)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
        ],
      ),
    );
  }

  colorBox({required Color color, required bool isSelected}) {
    return AnimatedContainer(
      height: (isSelected) ? 80 : 50,
      width: (isSelected) ? 80 : 50,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: (isSelected)
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.4),
                      offset: const Offset(0, 10),
                      blurRadius: 24,
                      spreadRadius: 6)
                ]
              : []),
    );
  }
}
