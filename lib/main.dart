import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:iot/widgets/collision_widget.dart';
import 'package:iot/widgets/crawler_info.dart';
import 'package:iot/widgets/google_map.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:provider/provider.dart';
import 'package:iot/provider/colors_list.dart';
import 'package:iot/provider/crawler_data.dart';
import 'package:iot/provider/light_data.dart';
import 'package:iot/provider/network.dart';
import 'package:iot/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LightData>(create: (context) => LightData()),
        ChangeNotifierProvider<InternetCheckerClass>(
            create: (context) => InternetCheckerClass()),
        ChangeNotifierProvider<ColorList>(create: (context) => ColorList()),
        ChangeNotifierProvider<CrawlerData>(create: (context) => CrawlerData())
      ],
      child: MaterialApp(
          theme: Themeing.darkTheme,
          color: Colors.orange,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const CrController()),
    );
  }
}

class CrController extends StatelessWidget {
  const CrController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrawlerData _crawlerData = Provider.of<CrawlerData>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(alignment: Alignment.center, children: [
          const GoogleMapsWidget(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const KAppBar(),
              Stack(alignment: Alignment.bottomCenter, children: [
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0.8)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                ),
                Column(
                  children: [
                    const CrJoyStickPad(),
                    SizedBox(
                      width: double.infinity - 20,
                      child: CrawlerInfo(
                          speed: _crawlerData.getXPosition ~/ 2,
                          temp: (_crawlerData.getYPosition - 30).abs(),
                          humidity: _crawlerData.getYPosition.abs()),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}

class KAppBar extends StatelessWidget {
  const KAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CrawlerData _crawlerData = Provider.of<CrawlerData>(context);
    return Stack(children: [
      Container(
        width: double.infinity,
        height: 74,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black.withOpacity(0.8),
          Colors.black.withOpacity(0)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      SizedBox(
        width: double.infinity,
        height: 74,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 20),
            KBackButton(onTap: () {}),
            const SizedBox(width: 40),
            CollisionWidget(distance: (_crawlerData.getYPosition / 2).abs()),
          ],
        ),
      ),
    ]);
  }
}
