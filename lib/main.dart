import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iot/apps/atmos_system.dart';
import 'package:iot/layouts/two_side.dart';
import 'package:iot/rive_avatar.dart';
import 'package:iot/themes.dart';
import 'package:flutter/material.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:provider/provider.dart';
import 'package:iot/widgets/google_map.dart';
import 'package:iot/widgets/crawler_info.dart';
import 'package:iot/widgets/joystick_pad.dart';
import 'package:iot/provider/crawler_data.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:iot/widgets/collision_widget.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:rive/rive.dart' as rive;
import 'layouts/circular_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themeing.darkTheme,
      color: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          ? Colors.transparent
          : Colors.black,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
          ?
          //  const Material(
          // color: Colors.transparent,
          // child:
          // Center(child: LoadAnimation()))

          TowColumn(
              leftChild: const SideNavbar(), rightChild: AtmosDesktopView())

          // DesktopSingleView(
          // title: 'Flutter-ESP32', bottomPannel: TempCumRGBApp())
          : const SingleHandControl(),
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
            // KBackButton(onTap: () {}),
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

class SideNavbar extends StatelessWidget {
  const SideNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: MoveWindow(),
        ),
        Row(children: [
          const SizedBox(width: 20),
          KBackButton(onTap: () {}),
          const SizedBox(width: 15),
          const KCloseWindow()
        ]),
      ],
    );
  }
}
