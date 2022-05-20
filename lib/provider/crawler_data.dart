import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CrawlerData extends ChangeNotifier {
  int _rotationAngle = 0;
  int _xpos = 0;
  int _ypos = 0;
  int get getRotation => _rotationAngle;
  int get getXPosition => _xpos;
  int get getYPosition => _ypos;

  void setXPosition({required int x}) {
    _xpos = x;
    notifyListeners();
  }

  void setYPosition({required int y}) {
    _ypos = y;
    notifyListeners();
  }

  void setRotation({required int rotation}) {
    _rotationAngle = rotation;
    notifyListeners();
  }
}
