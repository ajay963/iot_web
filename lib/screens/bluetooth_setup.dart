import 'dart:async';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:iot/Bluetooth/select_bonded_device_page.dart';
import 'package:iot/widgets/buttos.dart';
import 'package:iot/widgets/joystick_pad.dart';

class BluetoothSetup extends StatefulWidget {
  const BluetoothSetup({Key? key}) : super(key: key);

  @override
  State<BluetoothSetup> createState() => _BluetoothSetupState();
}

class _BluetoothSetupState extends State<BluetoothSetup> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((state) {
      _bluetoothState = state;
      setState(() {});
    });
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(const Duration(milliseconds: 400));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        _address = address!;
        setState(() {});
      });
    });
    FlutterBluetoothSerial.instance.name.then((name) {
      _name = name!;
      setState(() {});
    });

    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView(
        children: [
          ListTile(
            title: Text(
              'General',
              style: txtTheme.headlineMedium,
            ),
          ),
          SwitchListTile(
            title: Text(
              'Enable Bluetooth',
              style: txtTheme.bodyMedium,
            ),
            activeColor: Colors.white.withOpacity(0.6),
            activeTrackColor: Colors.white.withOpacity(0.6),
            inactiveTrackColor: Colors.white.withOpacity(0.2),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              // Do the request and update with the true value then
              future() async {
                // async lambda seems to not working
                (value)
                    ? await FlutterBluetoothSerial.instance.requestEnable()
                    : await FlutterBluetoothSerial.instance.requestDisable();
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
              title: Text(
                'Bluetooth status',
                style: txtTheme.bodyMedium,
              ),
              subtitle: Text(
                _bluetoothState.toString(),
                style: txtTheme.labelSmall,
              ),
              trailing: RoundedButton(
                  buttonLabel: 'Settings',
                  fontSize: 14,
                  horizontalPadding: 30,
                  onTap: () => FlutterBluetoothSerial.instance.openSettings())),
          ListTile(
            title: Text(
              'Local adapter address',
              style: txtTheme.bodyMedium,
            ),
            subtitle: Text(
              _address,
              style: txtTheme.labelSmall,
            ),
          ),
          ListTile(
            title: Text(
              'Local adapter name',
              style: txtTheme.bodyMedium,
            ),
            subtitle: Text(
              _name,
              style: txtTheme.labelSmall,
            ),
            onLongPress: null,
          ),

          const SizedBox(height: 40),
          ListTile(
              title: Text(
            'Connection',
            style: txtTheme.headlineMedium,
          )),
          SwitchListTile(
            title: Text(
              'Auto-try specific pin when pairing',
              style: txtTheme.labelSmall,
            ),
            subtitle: const Text('Pin 1234'),
            value: _autoAcceptPairingRequests,
            onChanged: (bool value) {
              setState(() {
                _autoAcceptPairingRequests = value;
              });
              if (value) {
                FlutterBluetoothSerial.instance.setPairingRequestHandler(
                    (BluetoothPairingRequest request) {
                  print("Trying to auto-pair with Pin 1234");
                  if (request.pairingVariant == PairingVariant.Pin) {
                    return Future.value("1234");
                  }
                  return Future.value(null);
                });
              } else {
                FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
              }
            },
            activeTrackColor: Colors.white.withOpacity(0.8),
            selectedTileColor: Colors.white.withOpacity(0.8),
            inactiveThumbColor: Colors.white,
            activeColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.4),
          ),
          const SizedBox(height: 20),
          // TODO : Building a Discovery Page
          ListTile(
            title: RoundedButton(
              buttonLabel: 'Paired Devices',
              fontSize: 20,
              horizontalPadding: 10,
              onTap: () async {
                final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SelectBondedDevicePage(
                          checkAvailability: false);
                    },
                  ),
                );

                if (selectedDevice != null) {
                  print('Connect -> selected ' + selectedDevice.address);
                  _startChat(context, selectedDevice);
                } else {
                  print('Connect -> no device selected');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _startChat(BuildContext context, BluetoothDevice server) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return JoyStickControllerScreen(server: server);
        //ChatPage(server: server);
      },
    ),
  );
}
