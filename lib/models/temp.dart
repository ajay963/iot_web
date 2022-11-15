import 'dart:convert';

class GraphData {
  GraphData({required this.time, required this.value});
  double value;
  double time;
}

class AtmosDataModel {
  int temp;
  int humidity;
  AtmosDataModel({
    required this.temp,
    required this.humidity,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
    };
  }

  factory AtmosDataModel.fromMap(Map<String, dynamic> map) {
    return AtmosDataModel(
      temp: map['temp']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AtmosDataModel.fromJson(String source) =>
      AtmosDataModel.fromMap(json.decode(source));
}

class AtmosData {
  int temp;
  int humidity;
  int pressure;
  int altitude;
  AtmosData({
    required this.temp,
    required this.humidity,
    required this.pressure,
    required this.altitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
      'pressure': pressure,
      'altitude': altitude,
    };
  }

  factory AtmosData.fromMap(Map<String, dynamic> map) {
    return AtmosData(
      temp: map['temp']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
      pressure: map['pressure']?.toInt() ?? 0,
      altitude: map['altitude']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AtmosData.fromJson(String source) =>
      AtmosData.fromMap(json.decode(source));
}

class SensorInfo {
  final int temp;
  final int humidity;
  final GyroData gyroData;
  final GeoLocationData locationData;
  SensorInfo({
    required this.temp,
    required this.humidity,
    required this.gyroData,
    required this.locationData,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
      'gyroData': gyroData.toMap(),
      'locationData': locationData.toMap(),
    };
  }

  factory SensorInfo.fromMap(Map<String, dynamic> map) {
    return SensorInfo(
      temp: map['temp']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
      gyroData: GyroData.fromMap(map['gyroData']),
      locationData: GeoLocationData.fromMap(map['locationData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorInfo.fromJson(String source) =>
      SensorInfo.fromMap(json.decode(source));
}

class GeoLocationData {
  double log;
  double lat;
  int seaLevel;
  int satelliteNo;
  GeoLocationData({
    required this.log,
    required this.lat,
    required this.seaLevel,
    required this.satelliteNo,
  });

  GeoLocationData copyWith({
    double? log,
    double? lat,
    int? seaLevel,
    int? satelliteNo,
  }) {
    return GeoLocationData(
      log: log ?? this.log,
      lat: lat ?? this.lat,
      seaLevel: seaLevel ?? this.seaLevel,
      satelliteNo: satelliteNo ?? this.satelliteNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'log': log,
      'lat': lat,
      'seaLevel': seaLevel,
      'satelliteNo': satelliteNo,
    };
  }

  factory GeoLocationData.fromMap(Map<String, dynamic> map) {
    return GeoLocationData(
      log: map['log']?.toDouble() ?? 0.0,
      lat: map['lat']?.toDouble() ?? 0.0,
      seaLevel: map['seaLevel']?.toInt() ?? 0,
      satelliteNo: map['satelliteNo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoLocationData.fromJson(String source) =>
      GeoLocationData.fromMap(json.decode(source));
}

class GyroData {
  int x;
  int y;
  int z;
  GyroData({
    required this.x,
    required this.y,
    required this.z,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'z': z,
    };
  }

  factory GyroData.fromMap(Map<String, dynamic> map) {
    return GyroData(
      x: map['x']?.toInt() ?? 0,
      y: map['y']?.toInt() ?? 0,
      z: map['z']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GyroData.fromJson(String source) =>
      GyroData.fromMap(json.decode(source));
}
