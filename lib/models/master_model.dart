import 'dart:convert';

class AtmosDataModel {
  int temp;
  int humidity;
  int pressure;
  AtmosDataModel({
    required this.temp,
    required this.humidity,
    required this.pressure,
  });

  AtmosDataModel copyWith({
    int? temp,
    int? humidity,
    int? pressure,
  }) {
    return AtmosDataModel(
      temp: temp ?? this.temp,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temp': temp,
      'humidity': humidity,
      'pressure': pressure,
    };
  }

  factory AtmosDataModel.fromMap(Map<String, dynamic> map) {
    return AtmosDataModel(
      temp: map['temp']?.toInt() ?? 0,
      humidity: map['humidity']?.toInt() ?? 0,
      pressure: map['pressure']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AtmosDataModel.fromJson(String source) =>
      AtmosDataModel.fromMap(json.decode(source));
}

class GPSDataModel {
  double lat;
  double lon;
  GPSDataModel({
    required this.lat,
    required this.lon,
  });

  GPSDataModel copyWith({
    double? lat,
    double? lon,
  }) {
    return GPSDataModel(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

  factory GPSDataModel.fromMap(Map<String, dynamic> map) {
    return GPSDataModel(
      lat: map['lat']?.toDouble() ?? 0.0,
      lon: map['lon']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GPSDataModel.fromJson(String source) =>
      GPSDataModel.fromMap(json.decode(source));
}

class GasDataModel {
  int mq4;
  int mq7;
  int mq135;
  GasDataModel({
    required this.mq4,
    required this.mq7,
    required this.mq135,
  });

  GasDataModel copyWith({
    int? mq4,
    int? mq7,
    int? mq135,
  }) {
    return GasDataModel(
      mq4: mq4 ?? this.mq4,
      mq7: mq7 ?? this.mq7,
      mq135: mq135 ?? this.mq135,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mq4': mq4,
      'mq7': mq7,
      'mq135': mq135,
    };
  }

  factory GasDataModel.fromMap(Map<String, dynamic> map) {
    return GasDataModel(
      mq4: map['mq4']?.toInt() ?? 0,
      mq7: map['mq7']?.toInt() ?? 0,
      mq135: map['mq135']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GasDataModel.fromJson(String source) =>
      GasDataModel.fromMap(json.decode(source));
}

class ReflexDataModel {
  int yaw;
  int pitch;
  int roll;
  int fClr;
  int lClr;
  int rClr;
  ReflexDataModel({
    required this.yaw,
    required this.pitch,
    required this.roll,
    required this.fClr,
    required this.lClr,
    required this.rClr,
  });

  ReflexDataModel copyWith({
    int? yaw,
    int? pitch,
    int? roll,
    int? fClr, // front clearence
    int? lClr, // left clearence
    int? rClr, // right clearence
  }) {
    return ReflexDataModel(
      yaw: yaw ?? this.yaw,
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
      fClr: fClr ?? this.fClr,
      lClr: lClr ?? this.lClr,
      rClr: rClr ?? this.rClr,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'yaw': yaw,
      'pitch': pitch,
      'roll': roll,
      'fClr': fClr,
      'lClr': lClr,
      'rClr': rClr,
    };
  }

  factory ReflexDataModel.fromMap(Map<String, dynamic> map) {
    return ReflexDataModel(
      yaw: map['yaw']?.toInt() ?? 0,
      pitch: map['pitch']?.toInt() ?? 0,
      roll: map['roll']?.toInt() ?? 0,
      fClr: map['fClr']?.toInt() ?? 0,
      lClr: map['lClr']?.toInt() ?? 0,
      rClr: map['rClr']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReflexDataModel.fromJson(String source) =>
      ReflexDataModel.fromMap(json.decode(source));
}

class MasterDataModel {
  AtmosDataModel atmos;
  GPSDataModel gps;
  GasDataModel gas;
  ReflexDataModel reflex;
  MasterDataModel({
    required this.atmos,
    required this.gps,
    required this.gas,
    required this.reflex,
  });

  MasterDataModel copyWith({
    AtmosDataModel? atmos,
    GPSDataModel? gps,
    GasDataModel? gas,
    ReflexDataModel? reflex,
  }) {
    return MasterDataModel(
      atmos: atmos ?? this.atmos,
      gps: gps ?? this.gps,
      gas: gas ?? this.gas,
      reflex: reflex ?? this.reflex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'atmos': atmos.toMap(),
      'gps': gps.toMap(),
      'gas': gas.toMap(),
      'reflex': reflex.toMap(),
    };
  }

  factory MasterDataModel.fromMap(Map<String, dynamic> map) {
    return MasterDataModel(
      atmos: AtmosDataModel.fromMap(map['atmos']),
      gps: GPSDataModel.fromMap(map['gps']),
      gas: GasDataModel.fromMap(map['gas']),
      reflex: ReflexDataModel.fromMap(map['reflex']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MasterDataModel.fromJson(String source) =>
      MasterDataModel.fromMap(json.decode(source));
}
