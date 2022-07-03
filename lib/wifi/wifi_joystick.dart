import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iot/provider/crawler_data.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class JoyStickControllerScreen extends StatefulWidget {
  final BluetoothDevice server;
  const JoyStickControllerScreen({Key? key, required this.server})
      : super(key: key);

  @override
  State<JoyStickControllerScreen> createState() =>
      _JoyStickControllerScreenState();
}

class _JoyStickControllerScreenState extends State<JoyStickControllerScreen> {
  int led = 0; // anlog value for led
  IOWebSocketChannel channel =
      IOWebSocketChannel.connect("ws://192.168.0.1:81");
  bool connected = false; //boolean value to track if WebSocket is connected

  @override
  void initState() {
    led = 0; //initially leadstatus is off so its 0
    connected = false; //initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  channelconnect() {
    //function to connect
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.0.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "poweron:success") {
              led = 255;
            } else if (message == "poweroff:success") {
              led = 0;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      if (led == 0 && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _crawlerData = Provider.of<CrawlerData>(context);
    final double _screenH = MediaQuery.of(context).size.height;
    final TextTheme txtTheme = Theme.of(context).textTheme;
    return Material(
      color: Colors.orange,
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: '32 ',
                  style: txtTheme.displayLarge,
                ),
                TextSpan(text: 'Kmph', style: txtTheme.headlineMedium),
              ])),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: '34 Deg Clockwise\n',
                  style: txtTheme.bodyMedium,
                ),
                TextSpan(text: 'Temp: 34', style: txtTheme.bodyMedium),
                TextSpan(
                  text: 'o C',
                  style: txtTheme.displaySmall,
                ),
                TextSpan(
                  text: '\nHumidity: 34 oC \n',
                  style: txtTheme.bodyMedium,
                ),
              ])),
              SizedBox(height: _screenH * 0.02),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: _crawlerData.getXPosition.toString() + ' : ',
                  style: txtTheme.bodyMedium,
                ),
                TextSpan(
                    text: _crawlerData.getYPosition.toInt().toString(),
                    style: txtTheme.bodyMedium),
              ])),
              SizedBox(height: _screenH * 0.06),
              Center(child: _JoystickPad(
                onchaged: () {
                  sendcmd(_crawlerData.getXPosition.toString());
                },
              )),
              SizedBox(height: _screenH * 0.02),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CircularButton(
                  icon: FontAwesomeIcons.bullhorn,
                  onTap: () {},
                  state: false,
                ),
                const SizedBox(width: 20),
                CircularButton(
                  icon: FontAwesomeIcons.bolt,
                  onTap: () {},
                  state: false,
                )
              ]),
              SizedBox(height: _screenH * 0.02),
            ]),
      )),
    );
  }
}

const String _gyro = 'assets/joystick.svg';
// const String _joystick = 'assets/joystick.svg';

// const String assetName = 'assets/image.svg';
class _JoystickPad extends StatelessWidget {
  final Function onchaged;
  const _JoystickPad({Key? key, required this.onchaged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.width / 1.2,
      width: _size.width / 1.2,
      child: Stack(alignment: AlignmentDirectional.center, children: [
        Transform.rotate(
          angle: 0,
          child: SvgPicture.asset(
            _gyro,
            height: _size.width / 1.2,
            width: _size.height / 1.2,
          ),
        ),
        SizedBox(
          height: _size.width / 2,
          width: _size.width / 2,
          // ignore: prefer_const_constructors
          child: _JoyStickController(onChange: onchaged),
        ),
      ]),
    );
  }
}

class _JoyStickController extends StatefulWidget {
  final Function onChange;

  const _JoyStickController({Key? key, required this.onChange})
      : super(key: key);

  @override
  State<_JoyStickController> createState() => __JoyStickControllerState();
}

class __JoyStickControllerState extends State<_JoyStickController> {
  double _x = 0;
  double _y = 0;

  final JoystickMode _joystickMode = JoystickMode.all;
  void changePosistion(double xStep, double yStep) {
    _x = xStep * 100;
    _y = yStep * -100;
  }

  void resetPosistion() {
    setState(() {
      _x = 0;
      _y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final TextTheme txtTheme = Theme.of(context).textTheme
    final _crawlerData = Provider.of<CrawlerData>(context);

    return Joystick(
      mode: _joystickMode,
      stick: Container(
        height: 60,
        width: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
      base: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent, width: 10),
        ),
      ),
      stickOffsetCalculator: const CircleStickOffsetCalculator(),
      listener: (details) {
        changePosistion(details.x, details.y);
        _crawlerData.setXPosition(x: _x.toInt());
        _crawlerData.setYPosition(y: _y.toInt());
        widget.onChange();
        setState(() {});
      },
      onStickDragEnd: () {
        resetPosistion();
        _crawlerData.setXPosition(x: 0);
        _crawlerData.setYPosition(y: 0);
      },
    );
  }
}
