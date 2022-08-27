import 'dart:convert';

class ControlData {
  final int xPos;
  final int yPos;
  final bool isActive;
  final int red;
  final int green;
  final int blue;

  ControlData({
    required this.xPos,
    required this.yPos,
    required this.isActive,
    required this.red,
    required this.green,
    required this.blue,
  });

  Map<String, dynamic> toMap() {
    return {
      'xPos': xPos,
      'yPos': yPos,
      'isActive': isActive,
      'red': red,
      'green': green,
      'blue': blue,
    };
  }

  factory ControlData.fromMap(Map<String, dynamic> map) {
    return ControlData(
      xPos: map['xPos']?.toInt() ?? 0,
      yPos: map['yPos']?.toInt() ?? 0,
      isActive: map['isActive'] ?? false,
      red: map['red']?.toInt() ?? 0,
      green: map['green']?.toInt() ?? 0,
      blue: map['blue']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ControlData.fromJson(String source) =>
      ControlData.fromMap(json.decode(source));
}
