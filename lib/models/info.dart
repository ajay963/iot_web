import 'dart:convert';

class ControlData {
  final int xPos;
  final int yPos;
  final bool isActive;
  final RGBled rgbLED;
  ControlData({
    required this.xPos,
    required this.yPos,
    required this.isActive,
    required this.rgbLED,
  });

  Map<String, dynamic> toMap() {
    return {
      'xPos': xPos,
      'yPos': yPos,
      'isActive': isActive,
      'rgbLED': rgbLED.toMap(),
    };
  }

  factory ControlData.fromMap(Map<String, dynamic> map) {
    return ControlData(
      xPos: map['xPos']?.toInt() ?? 0,
      yPos: map['yPos']?.toInt() ?? 0,
      isActive: map['isActive'] ?? false,
      rgbLED: RGBled.fromMap(map['rgbLED']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ControlData.fromJson(String source) =>
      ControlData.fromMap(json.decode(source));
}

class RGBled {
  int red;
  int blue;
  int green;
  RGBled({
    required this.red,
    required this.blue,
    required this.green,
  });

  Map<String, dynamic> toMap() {
    return {
      'red': red,
      'blue': blue,
      'green': green,
    };
  }

  factory RGBled.fromMap(Map<String, dynamic> map) {
    return RGBled(
      red: map['red']?.toInt() ?? 0,
      blue: map['blue']?.toInt() ?? 0,
      green: map['green']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RGBled.fromJson(String source) => RGBled.fromMap(json.decode(source));
}
