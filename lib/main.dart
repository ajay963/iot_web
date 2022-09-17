import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/rive_avatar.dart';
import 'package:iot/themes.dart';
import 'package:flutter/material.dart';
import 'package:iot/websocket.dart';
import 'package:iot/widgets/desktop_layout.dart';
import 'package:provider/provider.dart';
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
import 'layouts/desktop_monitor.dart';
import 'package:rive/rive.dart' as rive;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cachedAnimation = await RiveAvatar.cachedAnimation;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  WidgetsBinding.instance.addPostFrameCallback((_) {});

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await Window.initialize();
    doWhenWindowReady(() {
      const initialSize = Size(900, 680);
      // const maxSize = Size(1080, 720);
      appWindow.size = initialSize;
      appWindow.minSize = initialSize;
      appWindow.maxSize = initialSize;
      appWindow.title = "Flutter ESP-IOT";
      appWindow.alignment = Alignment.center;

      appWindow.show();
    });
    await Window.setEffect(
      effect: WindowEffect.aero,
      color: const Color(0xaa000000),
    );
  }

  runApp(MyApp(artboard: cachedAnimation.artboardByName('SPACE')));
}

class MyApp extends StatelessWidget {
  final rive.Artboard? artboard;
  const MyApp({Key? key, required this.artboard}) : super(key: key);

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
      child: GetMaterialApp(
        theme: Themeing.darkTheme,
        color: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? Colors.transparent
            : Colors.black,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? DesktopSingleView(
                title: 'Flutter-ESP32', bottomPannel: WebsocketMobile())
            : WebsocketMobile(),

        // DesktopSingleView(
        //   title: 'Flutter ESP-32',
        //   bottomPannel: Container(
        //     color: Colors.black.withOpacity(0.4),
        //     child: const WebSocketDesktop(),
        //   ),
        // )
      ),
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

class SpaceScene extends StatelessWidget {
  /// All interactive avatar logic is managed there, controller-like.
  final RiveAvatar _avatar;

  SpaceScene(rive.Artboard? cachedArtboard, {Key? key})
      : _avatar = RiveAvatar(cachedArtboard),
        super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: MouseRegion(
          onHover: (event) => _avatar.move(event.localPosition),
          // The useArtboardSize is important for accurate pointer position.
          child: rive.Rive(
            artboard: _avatar.artboard,
            fit: BoxFit.cover,
          ),
        ),
      );
}
