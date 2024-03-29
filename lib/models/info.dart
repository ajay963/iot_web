import 'dart:convert';

class RadialControl {
  final int leftPower;
  final int rightPower;
  final bool isLeftPostive;
  final bool isRightPositive;
  final int ledBrightness;
  RadialControl({
    required this.leftPower,
    required this.rightPower,
    required this.isLeftPostive,
    required this.isRightPositive,
    required this.ledBrightness,
  });

  RadialControl copyWith({
    int? leftPower,
    int? rightPower,
    bool? isLeftPostive,
    bool? isRightPositive,
    int? ledBrightness,
  }) {
    return RadialControl(
      leftPower: leftPower ?? this.leftPower,
      rightPower: rightPower ?? this.rightPower,
      isLeftPostive: isLeftPostive ?? this.isLeftPostive,
      isRightPositive: isRightPositive ?? this.isRightPositive,
      ledBrightness: ledBrightness ?? this.ledBrightness,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leftPower': leftPower,
      'rightPower': rightPower,
      'isLeftPostive': isLeftPostive,
      'isRightPositive': isRightPositive,
      'ledBrightness': ledBrightness,
    };
  }

  factory RadialControl.fromMap(Map<String, dynamic> map) {
    return RadialControl(
      leftPower: map['leftPower']?.toInt() ?? 0,
      rightPower: map['rightPower']?.toInt() ?? 0,
      isLeftPostive: map['isLeftPostive'] ?? false,
      isRightPositive: map['isRightPositive'] ?? false,
      ledBrightness: map['ledBrightness']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RadialControl.fromJson(String source) =>
      RadialControl.fromMap(json.decode(source));
}

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

class ControlData {
  int x;
  int y;
  int r;
  int g;
  int b;
  bool led;
  ControlData({
    required this.x,
    required this.y,
    required this.r,
    required this.g,
    required this.b,
    required this.led,
  });

  ControlData copyWith({
    int? x,
    int? y,
    int? r,
    int? g,
    int? b,
    bool? led,
  }) {
    return ControlData(
      x: x ?? this.x,
      y: y ?? this.y,
      r: r ?? this.r,
      g: g ?? this.g,
      b: b ?? this.b,
      led: led ?? this.led,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'r': r,
      'g': g,
      'b': b,
      'led': led,
    };
  }

  factory ControlData.fromMap(Map<String, dynamic> map) {
    return ControlData(
      x: map['x']?.toInt() ?? 0,
      y: map['y']?.toInt() ?? 0,
      r: map['r']?.toInt() ?? 0,
      g: map['g']?.toInt() ?? 0,
      b: map['b']?.toInt() ?? 0,
      led: map['led'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ControlData.fromJson(String source) =>
      ControlData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ControlData(x: $x, y: $y, r: $r, g: $g, b: $b, led: $led)';
  }
}
