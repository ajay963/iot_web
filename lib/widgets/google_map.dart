import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsWidget extends StatefulWidget {
  const GoogleMapsWidget({Key? key}) : super(key: key);

  @override
  State<GoogleMapsWidget> createState() => _GoogleMapsWidgetState();
}

class _GoogleMapsWidgetState extends State<GoogleMapsWidget> {
  late GoogleMapController _mapController;
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(23.749055, 86.269883),
    zoom: 14.4746,
  );
  changeMapMode() {
    getMapStyle('assets/maps/darkMap.json').then(setMapStyle);
  }

  void setMapStyle(String mapStyle) {
    _mapController.setMapStyle(mapStyle);
  }

  Future<String> getMapStyle(String path) async {
    return await rootBundle.loadString(path);
  }

  @override
  void initState() {
    changeMapMode();
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController mapController) {
        _mapController = mapController;
        changeMapMode();
        setState(() {});
      },
      onTap: (latlng) {
        latlng.latitude;
        latlng.longitude;
      },
      compassEnabled: false,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
