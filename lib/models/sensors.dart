import 'dart:convert';

class SensorsData {
  BME280 atmosphericData;
  NeoGPS6M gpsData;
  MPU6050Gyro gyroData;
  GasData gasData;
  SensorsData({
    required this.atmosphericData,
    required this.gpsData,
    required this.gyroData,
    required this.gasData,
  });

  Map<String, dynamic> toMap() {
    return {
      'atmosphericData': atmosphericData.toMap(),
      'gpsData': gpsData.toMap(),
      'gyroData': gyroData.toMap(),
      'gasData': gasData.toMap(),
    };
  }

  factory SensorsData.fromMap(Map<String, dynamic> map) {
    return SensorsData(
      atmosphericData: BME280.fromMap(map['atmosphericData']),
      gpsData: NeoGPS6M.fromMap(map['gpsData']),
      gyroData: MPU6050Gyro.fromMap(map['gyroData']),
      gasData: GasData.fromMap(map['gasData']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SensorsData.fromJson(String source) =>
      SensorsData.fromMap(json.decode(source));
}

class BME280 {
  int temp;
  int humidity;
  int pressure;
  BME280({
    required this.temp,
    required this.humidity,
    required this.pressure,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
      'pressure': pressure,
    };
  }

  factory BME280.fromMap(Map<String, dynamic> map) {
    return BME280(
      temp: map['temp']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
      pressure: map['pressure']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BME280.fromJson(String source) => BME280.fromMap(json.decode(source));
}

class NeoGPS6M {
  double log;
  double lat;
  int seaLevel;
  int satelliteNo;
  NeoGPS6M({
    required this.log,
    required this.lat,
    required this.seaLevel,
    required this.satelliteNo,
  });

  Map<String, dynamic> toMap() {
    return {
      'log': log,
      'lat': lat,
      'seaLevel': seaLevel,
      'satelliteNo': satelliteNo,
    };
  }

  factory NeoGPS6M.fromMap(Map<String, dynamic> map) {
    return NeoGPS6M(
      log: map['log']?.toDouble() ?? 0.0,
      lat: map['lat']?.toDouble() ?? 0.0,
      seaLevel: map['seaLevel']?.toInt() ?? 0,
      satelliteNo: map['satelliteNo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NeoGPS6M.fromJson(String source) =>
      NeoGPS6M.fromMap(json.decode(source));
}

class MPU6050Gyro {
  int xAxis;
  int yAxis;
  int zAxis;
  MPU6050Gyro({
    required this.xAxis,
    required this.yAxis,
    required this.zAxis,
  });

  Map<String, dynamic> toMap() {
    return {
      'xAxis': xAxis,
      'yAxis': yAxis,
      'zAxis': zAxis,
    };
  }

  factory MPU6050Gyro.fromMap(Map<String, dynamic> map) {
    return MPU6050Gyro(
      xAxis: map['xAxis']?.toInt() ?? 0,
      yAxis: map['yAxis']?.toInt() ?? 0,
      zAxis: map['zAxis']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory MPU6050Gyro.fromJson(String source) =>
      MPU6050Gyro.fromMap(json.decode(source));
}

class GasData {
  int airIndex;
  int co2;
  int ch4;
  GasData({
    required this.airIndex,
    required this.co2,
    required this.ch4,
  });

  Map<String, dynamic> toMap() {
    return {
      'airIndex': airIndex,
      'co2': co2,
      'ch4': ch4,
    };
  }

  factory GasData.fromMap(Map<String, dynamic> map) {
    return GasData(
      airIndex: map['airIndex']?.toInt() ?? 0,
      co2: map['co2']?.toInt() ?? 0,
      ch4: map['ch4']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GasData.fromJson(String source) =>
      GasData.fromMap(json.decode(source));
}
