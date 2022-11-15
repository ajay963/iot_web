import 'package:flutter/Material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuickInfo extends StatelessWidget {
  final String title;
  final String data;
  const QuickInfo({Key? key, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(children: [
        TextSpan(text: data + '\n', style: txtTheme.displayMedium),
        TextSpan(text: title, style: txtTheme.bodyMedium),
      ]),
    );
  }
}

class TempWidget extends StatelessWidget {
  final int temp;
  final int max;
  final int min;
  const TempWidget({
    Key? key,
    required this.temp,
    required this.max,
    required this.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              FontAwesomeIcons.temperatureHigh,
              size: 32,
            ),
            const SizedBox(width: 10),
            RichText(
              text: TextSpan(children: [
                TextSpan(text: temp.toString(), style: txtTheme.displayMedium),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(4, -20),
                    child: Text(
                      'o',
                      //superscript is usually smaller in size
                      textScaleFactor: 0.7,
                      style: txtTheme.bodyMedium,
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(text: 'Temperatue', style: txtTheme.bodyMedium),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(4, -20),
                child: Text(
                  'o',
                  //superscript is usually smaller in size
                  textScaleFactor: 0.7,
                  style: txtTheme.bodyMedium,
                ),
              ),
            ),
          ]),
        ),
        Row(
          children: [
            Text('max : ' + max.toString()),
            const SizedBox(width: 10),
            Text('min : ' + min.toString()),
          ],
        ),
      ],
    );
  }
}

class HumidityWidget extends StatelessWidget {
  final int humidity;
  final int max;
  final int min;
  const HumidityWidget({
    Key? key,
    required this.humidity,
    required this.max,
    required this.min,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              FontAwesomeIcons.droplet,
              size: 32,
            ),
            const SizedBox(width: 10),
            Text(humidity.toString() + '%', style: txtTheme.displayMedium),
          ],
        ),
        const Text('Humidity'),
        Row(
          children: [
            Text('max : ' + max.toString()),
            const SizedBox(width: 10),
            Text('min : ' + min.toString()),
          ],
        ),
      ],
    );
  }
}

class SatelliteInfoWidget extends StatelessWidget {
  final int seaLevel;
  final int satelliteNo;
  final double lat;
  final double long;
  const SatelliteInfoWidget(
      {Key? key,
      required this.seaLevel,
      required this.satelliteNo,
      required this.lat,
      required this.long})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          children: [
            QuickInfo(title: 'Sea Level', data: seaLevel.toString()),
            const SizedBox(width: 20),
            QuickInfo(title: 'Satellite', data: satelliteNo.toString())
          ],
        ),
        Text(
          'latitude : ' + lat.toString(),
          style: txtTheme.bodyMedium,
        ),
        Text(
          'longitude : ' + long.toString(),
          style: txtTheme.bodyMedium,
        )
      ],
    );
  }
}

class AtmosDataWidget extends StatelessWidget {
  final int airIndex;
  final int carbonMonoxide;
  final int methane;
  final int conductivity;
  const AtmosDataWidget(
      {Key? key,
      required this.airIndex,
      required this.carbonMonoxide,
      required this.methane,
      required this.conductivity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        QuickInfo(title: 'Air Quality', data: airIndex.toString()),
        const SizedBox(width: 20),
        Column(
          children: [
            Text('methane : ' + methane.toString(), style: txtTheme.bodyMedium),
            Text('carbon monoxide : ' + carbonMonoxide.toString(),
                style: txtTheme.bodyMedium),
            Text('conductivity : ' + conductivity.toString(),
                style: txtTheme.bodyMedium),
          ],
        ),
      ],
    );
  }
}
