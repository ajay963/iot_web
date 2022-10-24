import 'dart:convert';

class MobileControl {
  final int xPos;
  final int yPos;
  final bool isActive;
  final RGBled rgbLED;
  MobileControl({
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

  factory MobileControl.fromMap(Map<String, dynamic> map) {
    return MobileControl(
      xPos: map['xPos']?.toInt() ?? 0,
      yPos: map['yPos']?.toInt() ?? 0,
      isActive: map['isActive'] ?? false,
      rgbLED: RGBled.fromMap(map['rgbLED']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MobileControl.fromJson(String source) =>
      MobileControl.fromMap(json.decode(source));
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
