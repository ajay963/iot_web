import 'dart:convert';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../provider/crawler_data.dart';
import 'buttos.dart';
import 'dart:typed_data';

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class JoyStickControllerScreen extends StatefulWidget {
  final BluetoothDevice server;
  const JoyStickControllerScreen({Key? key, required this.server})
      : super(key: key);

  @override
  State<JoyStickControllerScreen> createState() =>
      _JoyStickControllerScreenState();
}

class _JoyStickControllerScreenState extends State<JoyStickControllerScreen> {
  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';
  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
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
                  isConnected
                      ? _sendMessage(_crawlerData.getXPosition.toString())
                      : null;
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
