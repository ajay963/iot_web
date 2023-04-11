import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utilities/colors.dart';
import '../widgets/buttos.dart';
import 'radar_page.dart';

class GPSPage extends StatefulWidget {
  const GPSPage({Key? key}) : super(key: key);

  @override
  State<GPSPage> createState() => _GPSPageState();
}

class _GPSPageState extends State<GPSPage> {
  int satelliteNo = 0;
  int velocity = 0;

  late GoogleMapController _controller;
  BitmapDescriptor currentPosMarker = BitmapDescriptor.defaultMarker;
  CameraPosition _currentPos = const CameraPosition(
    target: LatLng(23.795399, 86.427040),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    changeMaptheme();
    initMarker();
  }

  changeCameraPosition(double lat, double lng) {
    _currentPos = CameraPosition(target: LatLng(lat, lng));
    _controller.animateCamera(CameraUpdate.newCameraPosition(_currentPos));
  }

  maptheme(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  changeMaptheme() {
    getJsonFile('assets/maps/sllverMap.json').then((path) => maptheme(path));
  }

  void initMarker() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(40, 40)),
            "assets/maps/marker.png")
        .then((icon) {
      currentPosMarker = icon;
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CurvedContainer(
        height: 250,
        gradientColors: CustomGradients.waterGradient,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 0.1 * MediaQuery.of(context).size.width,
              vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: satelliteNo.toString() + '\n',
                        style: textTheme.displaySmall),
                    TextSpan(text: 'Satellites', style: textTheme.labelMedium)
                  ])),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: velocity.toString(),
                        style: textTheme.displaySmall),
                    TextSpan(
                        text: '\tmph\n',
                        style: textTheme.displaySmall!.copyWith(fontSize: 16)),
                    TextSpan(text: 'velocity', style: textTheme.labelMedium)
                  ])),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: GoogleMap(
              initialCameraPosition: _currentPos,
              onCameraMove: (pos) {},
              markers: {
                Marker(
                    markerId: const MarkerId("current position"),
                    position: _currentPos.target,
                    icon: currentPosMarker)
              },
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                changeMaptheme();
                setState(() {});
              },
            ),
          ),
          SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: ColoredBox(
                      color: Colors.black,
                      child: CustomBackButton(
                          onTap: () => Navigator.pop(context))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
