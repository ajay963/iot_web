import 'dart:convert';

import 'package:flutter/cupertino.dart';

class CrawlerData {
  final int xPos;
  final int yPos;
  final bool isHeadLampOn;
  final Color lampColor;
  CrawlerData({
    required this.xPos,
    required this.yPos,
    required this.isHeadLampOn,
    required this.lampColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'xPos': xPos,
      'yPos': yPos,
      'isHeadLampOn': isHeadLampOn,
      'lampColor': lampColor.value,
    };
  }

  factory CrawlerData.fromMap(Map<String, dynamic> map) {
    return CrawlerData(
      xPos: map['xPos']?.toInt() ?? 0,
      yPos: map['yPos']?.toInt() ?? 0,
      isHeadLampOn: map['isHeadLampOn'] ?? false,
      lampColor: Color(map['lampColor']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CrawlerData.fromJson(String source) =>
      CrawlerData.fromMap(json.decode(source));
}
