import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:iot/animation/bird_wallk.dart';
import 'package:iot/controller/master_controller.dart';
import 'home_page.dart';
import 'utilities/themes.dart';

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

  runApp(const WebsocketWrapperWidget());
}

class WebsocketWrapperWidget extends StatelessWidget {
  const WebsocketWrapperWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    return GetMaterialApp(
        theme: Themeing.darkTheme,
        color: (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
            ? Colors.transparent
            : Colors.black,
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        home: GetBuilder<MasterDataController>(
            builder: (MasterDataController data) {
          return (data.isConnected.value) ? const HomePage() : const BirdWalk();
        }));
  }
}
