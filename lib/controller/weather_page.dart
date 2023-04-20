import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iot/models/master_model.dart';
import 'package:iot/utilities/logger.dart';
import 'package:iot/widgets/graph_charts.dart';
import 'package:line_icons/line_icons.dart';

import '../utilities/colors.dart';
import '../widgets/buttos.dart';
import 'master_controller.dart';

final log = getLogger('weather_page');

class WeatherPage extends StatelessWidget {
  WeatherPage({Key? key}) : super(key: key);
  final MasterDataController data = Get.find<MasterDataController>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GetBuilder<MasterDataController>(
        builder: (MasterDataController data) {
      return Scaffold(
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Text('Weather',
                    style: textTheme.displayLarge!.copyWith(
                      color: CustomColors.greyShade2,
                    )),
              ),
              SizedBox(height: 0.1 * MediaQuery.of(context).size.height),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: data.sensorsData.value.atmos.temp.toString(),
                        style: textTheme.displaySmall!.copyWith(
                          color: CustomColors.greyShade1,
                          fontSize: 48,
                        )),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -20),
                        child: Text('oC',
                            //superscript is usually smaller in size
                            textScaleFactor: 1,
                            style: textTheme.displaySmall!.copyWith(
                              color: CustomColors.greyShade2,
                              fontSize: 20,
                            )),
                      ),
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Highest : ' + data.tempHL.highest.toString(),
                        style: textTheme.bodyMedium!.copyWith(
                          color: CustomColors.greyShade3,
                          fontSize: 20,
                        )),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -5),
                        child: Text('o',
                            //superscript is usually smaller in size
                            textScaleFactor: 1,
                            style: textTheme.bodyMedium!.copyWith(
                              color: CustomColors.greyShade3,
                              fontSize: 16,
                            )),
                      ),
                    )
                  ]),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Lowest : ' + data.tempHL.lowest.toString(),
                        style: textTheme.bodyMedium!.copyWith(
                          color: CustomColors.greyShade3,
                          fontSize: 20,
                        )),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(2, -5),
                        child: Text('o',
                            //superscript is usually smaller in size
                            textScaleFactor: 1,
                            style: textTheme.bodyMedium!.copyWith(
                              color: CustomColors.greyShade3,
                              fontSize: 16,
                            )),
                      ),
                    )
                  ]),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 0.2 * MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Charts(
                    list: data.tempList,
                    xAisLabel: 'time',
                    yAxisLabel: 'temperature'),
              ),
              const SizedBox(height: 40),
              visualData(data.sensorsData.value.atmos.humidity,
                  unit: '%',
                  label: 'humidity',
                  icon: LineIcons.water,
                  textTheme: textTheme),
              visualData(data.sensorsData.value.atmos.pressure,
                  unit: 'Pa',
                  label: 'pressure',
                  icon: LineIcons.wind,
                  textTheme: textTheme),
            ],
          ),
        ),
      );
    });
  }

  Widget visualData(int data,
      {required String unit,
      required label,
      required IconData icon,
      required TextTheme textTheme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: CustomColors.greyShade3,
          ),
          const SizedBox(width: 40),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: data.toString() + '\t' + unit + '\n',
                style: textTheme.displaySmall!.copyWith(
                  color: CustomColors.greyShade3,
                  fontSize: 36,
                )),
            TextSpan(
                text: label,
                style: textTheme.bodyMedium!.copyWith(
                  color: CustomColors.greyShade3,
                  fontSize: 20,
                )),
          ]))
        ],
      ),
    );
  }
}
