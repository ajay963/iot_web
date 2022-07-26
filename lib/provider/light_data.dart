import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorData extends ChangeNotifier {
  double _brightness = 100;
  Color _colorData1 = const Color(0xff00ffe0);
  Color _colorData2 = const Color(0xff00ffe0);

  final List<Color> _recentColorsList = [const Color(0xff00ffe0)];
  final List<Color> _favColorsList = [const Color(0xff00ffe0)];

  double get getBulbBrightness => _brightness;
  Color get getColor1 => _colorData1;
  Color get getColor2 => _colorData2;
  Color get prevColor => _recentColorsList[1];

  String get getColorInString => _colorData1
      .toString()
      .replaceAll('Color(0xff', '#')
      .replaceAll(')', '')
      .toUpperCase();
  List<Color> get getRecentColor => _recentColorsList;
  List<Color> get getFavColor => _favColorsList;
  void setBulbBrightness({required double bright}) {
    _brightness = bright;
    notifyListeners();
  }

  void setColor1({required Color colorData}) {
    _colorData1 = colorData;
    notifyListeners();
  }

  void setColor2({required Color colorData}) {
    _colorData2 = colorData;
    notifyListeners();
  }

  void addRecentColor({required Color colorData}) {
    _recentColorsList.insert(0, colorData);
    if (_recentColorsList.length > 40) _recentColorsList.removeLast();
    notifyListeners();
  }

  void addFavColor({required Color colorData}) {
    _recentColorsList.insert(0, colorData);
    notifyListeners();
  }
}
