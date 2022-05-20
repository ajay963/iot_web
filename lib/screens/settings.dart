import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iot/provider/network.dart';

class SettingPage extends StatelessWidget {
  final bool hasInternet;
  final ConnectivityResult connectivityResult;
  const SettingPage({
    Key? key,
    required this.hasInternet,
    required this.connectivityResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _txtTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text('Connectivtity', style: _txtTheme.headline2),
            const SizedBox(height: 10),
            Text(
              (hasInternet == true) ? 'Online' : 'No Internet',
              style: TextStyle(
                  fontFamily: _txtTheme.bodyText1!.fontFamily,
                  fontSize: _txtTheme.bodyText1!.fontSize,
                  color: (hasInternet == true) ? Colors.green : Colors.red,
                  fontWeight: _txtTheme.bodyText1!.fontWeight),
            ),
            const SizedBox(height: 10),
            Text(
              NetworkData().networkData(networkResult: connectivityResult),
              style: _txtTheme.bodyText1,
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            Text('App Info', style: _txtTheme.headline2),
            const SizedBox(height: 10),
            Text('App Version', style: _txtTheme.bodyText1),
            const SizedBox(height: 5),
            Text('Flutter Version', style: _txtTheme.bodyText1),
          ],
        ),
      ),
    );
  }
}
