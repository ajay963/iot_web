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
