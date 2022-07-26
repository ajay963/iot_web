import 'package:iot/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iot/websocket_led.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:iot/provider/network.dart';
import 'package:iot/widgets/google_map.dart';
import 'package:iot/widgets/crawler_info.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:iot/provider/colors_list.dart';
import 'package:iot/provider/crawler_data.dart';
import 'package:iot/provider/light_data.dart';
import 'package:iot/provider/sensors_data.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:iot/widgets/collision_widget.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
  await Window.initialize();
  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    WindowEffect.acrylic;
    appWindow.show();
  });
  await Window.setEffect(
    effect: WindowEffect.aero,
    color: const Color(0xAA000000),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ColorData>(create: (context) => ColorData()),
        ChangeNotifierProvider<LuxData>(create: (context) => LuxData()),
        ChangeNotifierProvider<TempData>(create: (context) => TempData()),
        ChangeNotifierProvider<HumidityData>(
            create: (context) => HumidityData()),
        ChangeNotifierProvider<InternetCheckerClass>(
            create: (context) => InternetCheckerClass()),
        ChangeNotifierProvider<ColorList>(create: (context) => ColorList()),
        ChangeNotifierProvider<CrawlerData>(create: (context) => CrawlerData())
      ],
      child: MaterialApp(
          theme: Themeing.darkTheme,
          color: Colors.transparent,
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const WebSocketLed()),
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
                      width: MediaQuery.of(context).size.width - 20,
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
