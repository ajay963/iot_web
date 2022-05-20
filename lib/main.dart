import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/onBoardScreens/on_board.dart';
import 'package:iot/screens/bluetooth_setup.dart';
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
          theme: Themeing.lightTheme,
          color: Colors.orange,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: Colors.orange.shade500,
              body: const BluetoothSetup())),
    );
  }
}
